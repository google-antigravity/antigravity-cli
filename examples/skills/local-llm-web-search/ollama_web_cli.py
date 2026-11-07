#!~/ai-workspace/environments/tts-env/bin/python
"""
ollama-web (oweb) — Universal Web-Search & Voice CLI Terminal Tool for Ollama on NVIDIA DGX Spark.

Works with EVERY model in your local Ollama repository (both native tool-calling models
like `libertas:latest`, `gemma4:31b`, `llama3.1:70b`, and pure completion/uncensored models
like `richardyoung/gemma-2-9b-it-abliterated:Q4_K_M`, `dolphin-llama3:70b`, `epistemic_doctrine:latest`).

Features:
1. Universal Live Web Search (`ddgs` Web + News + Wikipedia + BeautifulSoup full-page scraping).
2. Automatic URL Extraction: Any `http://` or `https://` link in your prompt is scraped and fed into context.
3. Dual-Engine Execution:
   - Universal Context Injection (works on 100% of Ollama models with zero per-model coding).
   - Native Ollama Tool-Calling (`--agent`) for models with `tools` capability.
4. Built-in Sovereign Voice Integration:
   - `--speak` (Piper TTS, ~0.2s latency) or `--kokoro` (Kokoro-82M `bm_george` British Baritone).
   - Interactive `/voice` command to dictate your question using local Faster-Whisper.
"""

import os
import re
import sys
import json
import time
import socket
import argparse
import subprocess
import urllib.parse
import urllib.request
import xml.etree.ElementTree as ET
from datetime import datetime

import requests
from bs4 import BeautifulSoup
from ddgs import DDGS

OLLAMA_HOST = os.environ.get("OLLAMA_HOST", "http://127.0.0.1:11434").rstrip("/")
DEFAULT_MODEL = os.environ.get("OLLAMA_WEB_MODEL", "richardyoung/gemma-2-9b-it-abliterated:Q4_K_M")
VOICE_SOCK = f"/run/user/{os.getuid()}/voice_dictate.sock"

# ANSI Colors for crisp terminal output
C_CYAN = "\033[96m"
C_GREEN = "\033[92m"
C_YELLOW = "\033[93m"
C_MAGENTA = "\033[95m"
C_DIM = "\033[2m"
C_BOLD = "\033[1m"
C_RESET = "\033[0m"


def get_local_models():
    """Returns list of local (non-0B cloud stub) Ollama models."""
    try:
        r = requests.get(f"{OLLAMA_HOST}/api/tags", timeout=5)
        r.raise_for_status()
        models = r.json().get("models", [])
        # Prefer actual downloaded local models (>10MB) first
        local = [m for m in models if m.get("size", 0) > 10_000_000 and "embed" not in m.get("name", "")]
        cloud = [m for m in models if m.get("size", 0) <= 10_000_000]
        return local + cloud
    except Exception as e:
        print(f"{C_YELLOW}[!] Warning: Could not query Ollama at {OLLAMA_HOST}: {e}{C_RESET}")
        return []


def resolve_model_name(requested_name):
    """Matches partial or exact model names in Ollama."""
    models = get_local_models()
    if not models:
        return requested_name
    names = [m["name"] for m in models]
    if requested_name in names:
        return requested_name
    for n in names:
        if n.lower().startswith(requested_name.lower()) or requested_name.lower() in n.lower():
            return n
    return requested_name


def get_model_capabilities(model_name):
    """Queries Ollama `/api/show` to inspect model capabilities (`tools`, `thinking`, `completion`)."""
    try:
        r = requests.post(f"{OLLAMA_HOST}/api/show", json={"name": model_name}, timeout=5)
        if r.status_code == 200:
            data = r.json()
            return data.get("capabilities", ["completion"])
    except Exception:
        pass
    return ["completion"]


def fetch_url_text(url, max_chars=4500):
    """Fetches a live webpage and extracts clean readable article text."""
    headers = {
        "User-Agent": (
            "Mozilla/5.0 (X11; Linux aarch64) AppleWebKit/537.36 "
            "(KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36"
        )
    }
    try:
        resp = requests.get(url, headers=headers, timeout=8)
        resp.raise_for_status()
        soup = BeautifulSoup(resp.text, "lxml")
        for tag in soup(["script", "style", "noscript", "nav", "footer", "header", "aside", "form", "svg"]):
            tag.decompose()
        title = soup.title.string.strip() if soup.title and soup.title.string else url
        paragraphs = [p.get_text(" ", strip=True) for p in soup.find_all(["p", "h1", "h2", "h3", "li", "article"])]
        text = "\n".join(p for p in paragraphs if len(p) > 35)
        if not text:
            text = soup.get_text(" ", strip=True)
        text = re.sub(r"\s+", " ", text).strip()
        return {"url": url, "title": title, "content": text[:max_chars]}
    except Exception as e:
        return {"url": url, "title": url, "content": f"[Could not scrape full page: {e}]"}


def google_news_rss_fallback(query, max_results=5):
    """Fallback live search via Google News RSS if DuckDuckGo is unreachable."""
    results = []
    try:
        encoded = urllib.parse.quote(query)
        url = f"https://news.google.com/rss/search?q={encoded}&hl=en-US&gl=US&ceid=US:en"
        resp = requests.get(url, timeout=6)
        root = ET.fromstring(resp.content)
        for item in root.findall(".//item")[:max_results]:
            title = item.findtext("title", "")
            link = item.findtext("link", "")
            pub_date = item.findtext("pubDate", "")
            desc = BeautifulSoup(item.findtext("description", ""), "lxml").get_text(" ", strip=True)
            results.append({
                "title": title,
                "href": link,
                "body": f"({pub_date}) {desc}"
            })
    except Exception:
        pass
    return results


def perform_web_search(query, max_results=5, deep_scrape_top=2):
    """
    Executes a live web + news search using DDGS (with Google News RSS fallback)
    and optionally scrapes the top N pages for deep context.
    """
    clean_q = re.sub(r"^(search( the web)?( for)?|look up|find)\s+", "", query, flags=re.I).strip()
    if not clean_q:
        clean_q = query

    print(f"{C_CYAN}🌐 Searching live web for:{C_RESET} {C_BOLD}{clean_q}{C_RESET} ...", flush=True)
    results = []

    try:
        ddgs = DDGS()
        # If query asks about news/today/latest, include news search as well
        is_news = any(w in clean_q.lower() for w in ["news", "today", "latest", "current", "weather", "price", "update", "recent"])
        if is_news:
            try:
                news_hits = list(ddgs.news(clean_q, max_results=3))
                for n in news_hits:
                    results.append({
                        "title": n.get("title", ""),
                        "href": n.get("url", ""),
                        "body": f"[{n.get('date', '')} - {n.get('source', '')}] {n.get('body', '')}"
                    })
            except Exception:
                pass

        web_hits = list(ddgs.text(clean_q, max_results=max_results + 3))
        seen_urls = {r["href"] for r in results}
        for w in web_hits:
            u = w.get("href", "")
            if u and u not in seen_urls and "bing.com/aclick" not in u and "doubleclick.net" not in u:
                results.append({
                    "title": w.get("title", ""),
                    "href": u,
                    "body": w.get("body", "")
                })
                seen_urls.add(u)
    except Exception as e:
        print(f"{C_YELLOW}  [DDGS fallback triggered: {e}]{C_RESET}")

    if not results:
        results = google_news_rss_fallback(clean_q, max_results=max_results)

    results = results[:max_results]
    for idx, r in enumerate(results, 1):
        print(f"  {C_GREEN}[{idx}]{C_RESET} {r['title']} {C_DIM}({r['href']}){C_RESET}", flush=True)

    # Scrape top N results for richer factual body text
    scraped_pages = []
    for r in results[:deep_scrape_top]:
        href = r.get("href", "")
        if href.startswith("http") and "google.com/rss" not in href:
            page = fetch_url_text(href, max_chars=2500)
            if page["content"] and not page["content"].startswith("[Could not"):
                scraped_pages.append(page)

    return results, scraped_pages


def build_web_context_block(query, results, scraped_pages):
    """Formats live web search results and scraped page excerpts into a clean context block."""
    now_str = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    lines = [
        f"=== LIVE WEB SEARCH RESULTS (Retrieved: {now_str}) ===",
        f"Search Query: {query}",
        ""
    ]
    for i, r in enumerate(results, 1):
        lines.append(f"[{i}] Title: {r.get('title')}")
        lines.append(f"    URL: {r.get('href')}")
        lines.append(f"    Snippet: {r.get('body')}")
        lines.append("")

    if scraped_pages:
        lines.append("=== EXTRACTED WEBPAGE CONTENT ===")
        for p in scraped_pages:
            lines.append(f"Source URL: {p['url']} ({p['title']})")
            lines.append(f"Extracted Text: {p['content']}")
            lines.append("")

    lines.append(
        "Instruction: Use the live web search results above to answer the user's question accurately "
        "and cite relevant source URLs or facts."
    )
    return "\n".join(lines)


def should_auto_search(prompt, mode="auto"):
    """Determines whether a prompt should trigger live web search."""
    if mode == "always":
        return True
    if mode == "off":
        return False
    # In 'auto' mode, search by default unless it's a pure greeting or code-only snippet without factual query
    p_low = prompt.strip().lower()
    if p_low in ("hi", "hello", "hey", "thanks", "thank you", "ok", "okay"):
        return False
    return True


def speak_response(text, engine="piper"):
    """Speaks the response aloud using the local Sovereign Voice Daemon (`ai-say`)."""
    clean = re.sub(r"https?://\S+", "", text)
    clean = re.sub(r"[`*_#>\[\]()~]+", " ", clean)
    clean = re.sub(r"\s+", " ", clean).strip()
    if not clean:
        return
    cmd = ["ai-say", "--kokoro", clean] if engine == "kokoro" else ["ai-say", clean]
    subprocess.run(cmd, check=False, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)


def record_voice_prompt():
    """Records a spoken prompt from the microphone and transcribes via local Faster-Whisper."""
    raw_path = "/tmp/ollama_web_voice.raw"
    if os.path.exists(raw_path):
        try:
            os.remove(raw_path)
        except OSError:
            pass
    print(f"{C_MAGENTA}🎙️  Listening... Speak your prompt now and press Enter when finished:{C_RESET}", flush=True)
    proc = subprocess.Popen(
        ["~/.local/bin/pw-record", "--rate=16000", "--channels=1", "--format=s16", "--raw", "-"],
        stdout=open(raw_path, "wb"),
        stderr=subprocess.DEVNULL
    )
    try:
        input()
    except (KeyboardInterrupt, EOFError):
        pass
    proc.terminate()
    try:
        proc.wait(timeout=1.0)
    except Exception:
        proc.kill()

    if not os.path.exists(raw_path) or os.path.getsize(raw_path) < 6400:
        print(f"{C_YELLOW}[!] Recording too short.{C_RESET}")
        return ""

    try:
        s = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
        s.settimeout(8.0)
        s.connect(VOICE_SOCK)
        s.sendall(f"TRANSCRIBE_RAW:{raw_path}\n".encode("utf-8"))
        transcript = s.recv(4096).decode("utf-8", errors="ignore").strip()
        s.close()
        if transcript:
            print(f"{C_GREEN}✓ Transcribed:{C_RESET} {transcript}")
        return transcript
    except Exception as e:
        print(f"{C_YELLOW}[!] Whisper daemon error: {e}{C_RESET}")
        return ""


OLLAMA_TOOLS_SCHEMA = [
    {
        "type": "function",
        "function": {
            "name": "web_search",
            "description": "Search the live internet for current events, facts, news, documentation, or any topic.",
            "parameters": {
                "type": "object",
                "properties": {
                    "query": {
                        "type": "string",
                        "description": "The search query string"
                    }
                },
                "required": ["query"]
            }
        }
    },
    {
        "type": "function",
        "function": {
            "name": "fetch_url",
            "description": "Fetch and read the full text content of a specific webpage URL.",
            "parameters": {
                "type": "object",
                "properties": {
                    "url": {
                        "type": "string",
                        "description": "The full http/https URL to read"
                    }
                },
                "required": ["url"]
            }
        }
    }
]


def query_ollama_with_web(
    model,
    user_prompt,
    history,
    search_mode="auto",
    use_native_tools=False,
    enable_thinking=False,
    max_results=5,
    speak_mode=None
):
    """
    Universal Ollama execution pipeline:
    1. Extracts any explicit URLs in user_prompt and scrapes them.
    2. Runs universal web search injection (works on ALL models, with or without `tools` support),
       OR native tool calling if `--agent` is enabled on a tool-capable model.
    3. Streams tokens live to the terminal and optionally speaks the response via Piper/Kokoro TTS.
    """
    capabilities = get_model_capabilities(model)
    supports_tools = "tools" in capabilities
    supports_thinking = "thinking" in capabilities

    # 1. Check for explicit URLs in the prompt
    urls = re.findall(r"https?://[^\s)>\]\"']+", user_prompt)
    scraped_explicit = []
    for u in urls[:3]:
        print(f"{C_CYAN}📄 Fetching URL:{C_RESET} {u} ...", flush=True)
        scraped_explicit.append(fetch_url_text(u, max_chars=4000))

    # 2. Universal Web Search Injection (unless native agentic tool-calling only is requested)
    augmented_user_content = user_prompt
    if scraped_explicit:
        url_block = "\n\n=== SCRAPED WEBPAGE CONTENT ===\n" + "\n\n".join(
            f"URL: {p['url']}\nTitle: {p['title']}\nContent: {p['content']}" for p in scraped_explicit
        )
        augmented_user_content = f"{url_block}\n\nUser Question: {user_prompt}"

    if not use_native_tools and should_auto_search(user_prompt, mode=search_mode):
        results, scraped_pages = perform_web_search(user_prompt, max_results=max_results, deep_scrape_top=2)
        if results:
            web_block = build_web_context_block(user_prompt, results, scraped_pages)
            augmented_user_content = f"{web_block}\n\nUser Question: {user_prompt}"

    messages = list(history) + [{"role": "user", "content": augmented_user_content}]

    payload = {
        "model": model,
        "messages": messages,
        "stream": True
    }
    if supports_thinking:
        payload["think"] = bool(enable_thinking)

    # If native agentic tool calling is requested and supported by the model
    if use_native_tools and supports_tools:
        t_payload = dict(payload)
        t_payload["tools"] = OLLAMA_TOOLS_SCHEMA
        t_payload["stream"] = False
        print(f"{C_DIM}[Agentic Tool Mode active for {model}]{C_RESET}", flush=True)
        resp = requests.post(f"{OLLAMA_HOST}/api/chat", json=t_payload, timeout=180)
        resp.raise_for_status()
        msg = resp.json().get("message", {})
        tool_calls = msg.get("tool_calls", [])
        if tool_calls:
            messages.append(msg)
            for tc in tool_calls:
                fn = tc.get("function", {})
                fn_name = fn.get("name")
                fn_args = fn.get("arguments", {})
                if isinstance(fn_args, str):
                    try:
                        fn_args = json.loads(fn_args)
                    except Exception:
                        fn_args = {"query": fn_args}
                if fn_name == "web_search":
                    q = fn_args.get("query", user_prompt)
                    res, pages = perform_web_search(q, max_results=max_results, deep_scrape_top=2)
                    tool_out = build_web_context_block(q, res, pages)
                elif fn_name == "fetch_url":
                    u = fn_args.get("url", "")
                    print(f"{C_CYAN}📄 Model requested URL:{C_RESET} {u} ...", flush=True)
                    p = fetch_url_text(u, max_chars=4000)
                    tool_out = f"Title: {p['title']}\nURL: {p['url']}\nContent: {p['content']}"
                else:
                    tool_out = "Unknown tool"
                messages.append({"role": "tool", "content": tool_out})
            payload["messages"] = messages

    # Stream final response to terminal
    print(f"\n{C_MAGENTA}{C_BOLD}[{model}]{C_RESET} ", end="", flush=True)
    full_reply = []
    try:
        with requests.post(f"{OLLAMA_HOST}/api/chat", json=payload, stream=True, timeout=300) as r:
            r.raise_for_status()
            for line in r.iter_lines():
                if not line:
                    continue
                chunk = json.loads(line.decode("utf-8"))
                token = chunk.get("message", {}).get("content", "")
                if token:
                    print(token, end="", flush=True)
                    full_reply.append(token)
                if chunk.get("done"):
                    break
    except KeyboardInterrupt:
        print(f"\n{C_YELLOW}[Generation interrupted]{C_RESET}")
    except Exception as e:
        print(f"\n{C_YELLOW}[!] Ollama error: {e}{C_RESET}")

    print("\n", flush=True)
    reply_str = "".join(full_reply).strip()

    if reply_str:
        history.append({"role": "user", "content": user_prompt})
        history.append({"role": "assistant", "content": reply_str})
        if speak_mode:
            speak_response(reply_str, engine=speak_mode)

    return reply_str


def interactive_repl(model, search_mode="auto", use_native_tools=False, enable_thinking=False, speak_mode=None):
    """Interactive terminal loop (`ollama run` style with live web search & voice)."""
    caps = get_model_capabilities(model)
    print(f"{C_BOLD}{C_CYAN}=================================================================={C_RESET}")
    print(f"{C_BOLD} 🌐 Sovereign Ollama Web CLI (`ollama-web` / `oweb`){C_RESET}")
    print(f" Active Model : {C_GREEN}{model}{C_RESET} {C_DIM}(capabilities: {', '.join(caps)}){C_RESET}")
    print(f" Web Search   : {C_GREEN}{search_mode.upper()}{C_RESET} {'(+ Native Agent Tools)' if use_native_tools else '(Universal Search Injection)'}")
    print(f" Voice Output : {C_GREEN}{speak_mode.upper() if speak_mode else 'OFF'}{C_RESET} {C_DIM}(toggle with /speak or /kokoro){C_RESET}")
    print(f" Commands     : {C_YELLOW}/search <q>{C_RESET}, {C_YELLOW}/url <link>{C_RESET}, {C_YELLOW}/voice{C_RESET}, {C_YELLOW}/models{C_RESET}, {C_YELLOW}/model <name>{C_RESET}, {C_YELLOW}/speak{C_RESET}, {C_YELLOW}/kokoro{C_RESET}, {C_YELLOW}/clear{C_RESET}, {C_YELLOW}/exit{C_RESET}")
    print(f"{C_BOLD}{C_CYAN}=================================================================={C_RESET}\n")

    history = [
        {
            "role": "system",
            "content": (
                "You are an intelligent AI assistant running locally via Ollama on an NVIDIA DGX Spark workstation "
                "with live internet search access. Answer accurately using the provided live web search results."
            )
        }
    ]

    while True:
        try:
            prompt = input(f"{C_BOLD}{C_GREEN}>>> {C_RESET}").strip()
        except (KeyboardInterrupt, EOFError):
            print("\nExiting ollama-web.")
            break

        if not prompt:
            continue

        if prompt.lower() in ("/exit", "/quit", "/bye", "exit", "quit"):
            break
        elif prompt.lower() == "/help":
            print(
                f"\n{C_BOLD}Available Slash Commands:{C_RESET}\n"
                f"  {C_YELLOW}/search <query>{C_RESET}  - Force live web search for <query>\n"
                f"  {C_YELLOW}/noser <query>{C_RESET}   - Ask model directly without web search\n"
                f"  {C_YELLOW}/url <https://>{C_RESET}  - Scrape a webpage URL and summarize it\n"
                f"  {C_YELLOW}/voice{C_RESET}           - Dictate your question using microphone (Faster-Whisper)\n"
                f"  {C_YELLOW}/speak{C_RESET}           - Toggle Piper TTS spoken replies ON/OFF\n"
                f"  {C_YELLOW}/kokoro{C_RESET}          - Toggle Kokoro-82M British Baritone spoken replies ON/OFF\n"
                f"  {C_YELLOW}/models{C_RESET}          - List all local Ollama models\n"
                f"  {C_YELLOW}/model <name>{C_RESET}    - Switch active Ollama model on the fly\n"
                f"  {C_YELLOW}/clear{C_RESET}           - Clear conversation history\n"
                f"  {C_YELLOW}/exit{C_RESET}            - Exit ollama-web\n"
            )
            continue
        elif prompt.lower() == "/clear":
            history = history[:1]
            print(f"{C_CYAN}✓ Conversation history cleared.{C_RESET}\n")
            continue
        elif prompt.lower() == "/models":
            models = get_local_models()
            print(f"\n{C_BOLD}Available Ollama Models:{C_RESET}")
            for m in models:
                sz = m.get("size", 0) / (1024 ** 3)
                tag = f"{sz:.1f} GB" if sz > 0.05 else "Cloud"
                mark = "*" if m["name"] == model else " "
                print(f" {C_GREEN}{mark} {m['name']:<48}{C_RESET} [{tag}]")
            print("")
            continue
        elif prompt.lower().startswith("/model "):
            req_m = prompt[7:].strip()
            model = resolve_model_name(req_m)
            caps = get_model_capabilities(model)
            print(f"{C_GREEN}✓ Switched active model to:{C_RESET} {C_BOLD}{model}{C_RESET} ({', '.join(caps)})\n")
            continue
        elif prompt.lower() == "/speak":
            speak_mode = None if speak_mode == "piper" else "piper"
            print(f"{C_GREEN}✓ Piper TTS Voice Output:{C_RESET} {speak_mode.upper() if speak_mode else 'OFF'}\n")
            continue
        elif prompt.lower() == "/kokoro":
            speak_mode = None if speak_mode == "kokoro" else "kokoro"
            print(f"{C_GREEN}✓ Kokoro-82M Voice Output:{C_RESET} {speak_mode.upper() if speak_mode else 'OFF'}\n")
            continue
        elif prompt.lower() == "/voice":
            prompt = record_voice_prompt()
            if not prompt:
                continue

        cur_search_mode = search_mode
        if prompt.lower().startswith("/search "):
            prompt = prompt[8:].strip()
            cur_search_mode = "always"
        elif prompt.lower().startswith("/noser "):
            prompt = prompt[7:].strip()
            cur_search_mode = "off"
        elif prompt.lower().startswith("/url "):
            u = prompt[5:].strip()
            prompt = f"Summarize and explain the contents of {u}"
            cur_search_mode = "off"

        query_ollama_with_web(
            model=model,
            user_prompt=prompt,
            history=history,
            search_mode=cur_search_mode,
            use_native_tools=use_native_tools,
            enable_thinking=enable_thinking,
            speak_mode=speak_mode
        )


def main():
    parser = argparse.ArgumentParser(
        prog="ollama-web",
        description="Universal Live Web-Search & Voice CLI for all local Ollama models."
    )
    parser.add_argument(
        "-m", "--model",
        default=DEFAULT_MODEL,
        help=f"Ollama model name or substring (default: {DEFAULT_MODEL})"
    )
    parser.add_argument(
        "--list-models", "-l",
        action="store_true",
        help="List all available Ollama models and their capabilities"
    )
    parser.add_argument(
        "--no-search",
        action="store_true",
        help="Disable automatic web search for the initial query"
    )
    parser.add_argument(
        "--agent",
        action="store_true",
        help="Use native Ollama tool-calling schema (for models with `tools` capability)"
    )
    parser.add_argument(
        "--think",
        action="store_true",
        help="Enable internal reasoning chain on thinking models"
    )
    parser.add_argument(
        "--speak", "-s",
        action="store_true",
        help="Speak the model's response aloud via Piper TTS"
    )
    parser.add_argument(
        "--kokoro", "-k",
        action="store_true",
        help="Speak the model's response aloud via Kokoro-82M (bm_george British Baritone)"
    )
    parser.add_argument(
        "--max-results", "-n",
        type=int,
        default=5,
        help="Number of web search results to retrieve (default: 5)"
    )
    parser.add_argument(
        "prompt",
        nargs="*",
        help="Optional prompt (if omitted, starts interactive terminal session)"
    )

    args = parser.parse_args()

    if args.list_models:
        models = get_local_models()
        print(f"{C_BOLD}{'MODEL NAME':<50} {'SIZE':<10} {'CAPABILITIES'}{C_RESET}")
        print("-" * 85)
        for m in models:
            sz = m.get("size", 0) / (1024 ** 3)
            sz_str = f"{sz:.1f} GB" if sz > 0.05 else "Cloud"
            caps = ", ".join(get_model_capabilities(m["name"]))
            print(f"{m['name']:<50} {sz_str:<10} {caps}")
        return

    # Support `ollama-web <model_name>` to start interactive session with that model
    prompt_parts = list(args.prompt)
    model_name = args.model
    if len(prompt_parts) == 1 and args.model == DEFAULT_MODEL:
        models = [m["name"] for m in get_local_models()]
        cand = resolve_model_name(prompt_parts[0])
        if cand in models and (":" in prompt_parts[0] or prompt_parts[0].lower() in [m.split(":")[0].lower() for m in models]):
            model_name = cand
            prompt_parts = []

    model_name = resolve_model_name(model_name)
    speak_mode = "kokoro" if args.kokoro else ("piper" if args.speak else None)
    search_mode = "off" if args.no_search else "auto"

    if prompt_parts:
        user_prompt = " ".join(prompt_parts)
        history = [
            {
                "role": "system",
                "content": (
                    "You are an intelligent AI assistant running locally via Ollama on an NVIDIA DGX Spark workstation "
                    "with live internet search access. Answer accurately using the provided live web search results."
                )
            }
        ]
        query_ollama_with_web(
            model=model_name,
            user_prompt=user_prompt,
            history=history,
            search_mode=search_mode,
            use_native_tools=args.agent,
            enable_thinking=args.think,
            max_results=args.max_results,
            speak_mode=speak_mode
        )
    else:
        interactive_repl(
            model=model_name,
            search_mode=search_mode,
            use_native_tools=args.agent,
            enable_thinking=args.think,
            speak_mode=speak_mode
        )


if __name__ == "__main__":
    main()
