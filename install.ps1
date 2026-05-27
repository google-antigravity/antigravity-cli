$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest
if ($ExecutionContext.SessionState.LanguageMode -ne 'ConstrainedLanguage') {
    try {
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    } catch {
        # Ignore failure, TLS 1.2 might already be default or we can't set it.
    }
}

$hasPath = ($null -ne $MyInvocation.MyCommand) -and ($null -ne $MyInvocation.MyCommand.PSObject.Properties['Path'])
$scriptPath = if ($hasPath) { $MyInvocation.MyCommand.Path } else { $null }
$isSourced = [string]::IsNullOrEmpty($scriptPath) -or ($MyInvocation.InvocationName -eq '.')

$stagingPayload = $null
$script:installExitCode = 0

function Invoke-Install {
    param($ScriptArgs)

    $DOWNLOAD_BASE_URL = "https://antigravity-cli-auto-updater-974169037036.us-central1.run.app"
    $TARGET_DIR = Join-Path $env:LOCALAPPDATA "agy\bin"
    $CUSTOM_DIR = ""
    $passthroughArgs = @()

    # Secure loop argument parsing and forward gathering
    for ($i = 0; $i -lt $ScriptArgs.Count; $i++) {
        if ($ScriptArgs[$i] -eq "-d" -or $ScriptArgs[$i] -eq "--dir") {
            if ($i + 1 -lt $ScriptArgs.Count) {
                $CUSTOM_DIR = $ScriptArgs[$i + 1]
                $i++
            } else {
                Write-Error "Error: Missing value for directory option." -ErrorAction Continue
                if ($isSourced) { throw "Error: Missing value for directory option." } else { $script:installExitCode = 1; return }
            }
        } else {
            $passthroughArgs += $ScriptArgs[$i]
        }
    }
    if ($CUSTOM_DIR -ne "") { $TARGET_DIR = $CUSTOM_DIR }
    $binaryPath = Join-Path $TARGET_DIR "agy.exe"

    # Pre-existence & Dynamic Path Check
    if (Test-Path $binaryPath) {
        Write-Host "Notice: 'agy.exe' is already installed at $binaryPath."
        Write-Host "The Antigravity CLI automatically self-updates in the background."
        Write-Host "If you want to perform a fresh installation, delete the binary first:"
        Write-Host "  Remove-Item `"$binaryPath`" -Force"
        $script:installExitCode = 0; return
    }

    # 1. Detect Architecture
    $arch = if ($env:PROCESSOR_ARCHITEW6432) { $env:PROCESSOR_ARCHITEW6432 } else { $env:PROCESSOR_ARCHITECTURE }
    if ($arch -eq "AMD64") {
        $platform = "windows_amd64"
    } elseif ($arch -eq "ARM64") {
        $platform = "windows_arm64"
    } else {
        Write-Error "Fatal: Unsupported CPU architecture." -ErrorAction Continue
        if ($isSourced) { throw "Fatal: Unsupported CPU architecture." } else { $script:installExitCode = 1; return }
    }

    # 2. Query Manifest (Local or Remote)
    $localMode = $false
    $scriptDir = $null
    if ($hasPath) {
        $scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
    }
    if ([string]::IsNullOrEmpty($scriptDir) -and (Test-Path "Variable:PSScriptRoot")) {
        $scriptDir = $PSScriptRoot
    }
    if ([string]::IsNullOrEmpty($scriptDir)) {
        $scriptDir = Get-Location
    }

    $localManifest = Join-Path $scriptDir "packages\manifests\$platform.json"
    if (Test-Path $localManifest) {
        try {
            $manifestContent = Get-Content -Raw -Path $localManifest
            # Simple regex parser to avoid ConvertFrom-Json dependency/failure issues
            $version = if ($manifestContent -match '"version"\s*:\s*"([^"]+)"') { $Matches[1] } else { "" }
            $url = if ($manifestContent -match '"url"\s*:\s*"([^"]+)"') { $Matches[1] } else { "" }
            $sha512 = if ($manifestContent -match '"sha512"\s*:\s*"([^"]+)"') { $Matches[1] } else { "" }
            
            if ($url -ne "" -and $sha512 -ne "") {
                $archiveFilename = Split-Path -Leaf $url
                $localArchive = Join-Path $scriptDir "packages\binaries\$archiveFilename"
                if (Test-Path $localArchive) {
                    $localMode = $true
                    Write-Host "✓ Local package files found for platform $platform. Installing offline..."
                }
            }
        } catch {
            # Ignore and fallback
        }
    }

    if (-not $localMode) {
        Write-Host "⠋ Querying release repository..."
        try {
            $manifest = Invoke-RestMethod -Uri "$DOWNLOAD_BASE_URL/manifests/$platform.json"
            $version = $manifest.version
            $url = $manifest.url
            $sha512 = $manifest.sha512
        } catch {
            Write-Error "Fatal: Failed to download release manifest from $DOWNLOAD_BASE_URL/manifests/$platform.json. Network or DNS issue?" -ErrorAction Continue
            Write-Error "Error details: $_" -ErrorAction Continue
            if ($isSourced) { throw "Fatal: Failed to download manifest." } else { $script:installExitCode = 1; return }
        }
    }

    Write-Host "✓ Latest available version: $version"

    # 3. Download/Stage Binary & Verify Checksum
    $stagingDir = Join-Path $env:LOCALAPPDATA "antigravity\staging"
    try {
        if (-not (Test-Path $stagingDir)) { New-Item -ItemType Directory -Path $stagingDir | Out-Null }
    } catch {
        Write-Error "Fatal: Failed to create staging directory at $stagingDir. Please check write permissions." -ErrorAction Continue
        Write-Error "Error details: $_" -ErrorAction Continue
        if ($isSourced) { throw "Fatal: Failed to create staging directory." } else { $script:installExitCode = 1; return }
    }

    $isZip = $url.EndsWith(".zip")
    $payloadName = if ($isZip) { "agy.zip" } else { "agy.exe" }
    $localStagingPayload = Join-Path $stagingDir $payloadName
    $script:stagingPayload = $localStagingPayload

    if ($localMode) {
        Write-Host "⠋ Staging local release package..."
        try {
            Copy-Item -Path $localArchive -Destination $localStagingPayload -Force
        } catch {
            Write-Error "Fatal: Failed to copy local archive from $localArchive to $localStagingPayload." -ErrorAction Continue
            Write-Error "Error details: $_" -ErrorAction Continue
            if ($isSourced) { throw "Fatal: Failed to copy local archive." } else { $script:installExitCode = 1; return }
        }
    } else {
        Write-Host "⠋ Downloading release package..."
        $ProgressPreference = 'SilentlyContinue'
        try {
            Invoke-WebRequest -Uri $url -OutFile $localStagingPayload
        } catch {
            Write-Error "Fatal: Failed to download binary from $url. Network or DNS issue?" -ErrorAction Continue
            Write-Error "Error details: $_" -ErrorAction Continue
            if ($isSourced) { throw "Fatal: Failed to download binary." } else { $script:installExitCode = 1; return }
        }
    }
    $hash = $null
    if ($ExecutionContext.SessionState.LanguageMode -ne 'ConstrainedLanguage') {
        try {
            $hash = (Get-FileHash $localStagingPayload -Algorithm SHA512).Hash.ToLower()
        } catch {
            # Ignore and fallback
        }
    }
    if ($null -eq $hash) {
        try {
            $certutilOut = certutil -hashfile $localStagingPayload SHA512
            if ($LASTEXITCODE -eq 0 -and $certutilOut.Count -ge 2) {
                $hash = ($certutilOut[1] -replace '\s').ToLower()
            }
        } catch {
            # Ignore
        }
    }
    if ($null -eq $hash) {
        Write-Error "Fatal: Failed to compute file hash for verification." -ErrorAction Continue
        if ($isSourced) { throw "Fatal: Failed to compute file hash." } else { $script:installExitCode = 1; return }
    }
    if ($hash -ne $sha512.ToLower()) {
        Write-Error "Security Halt: Checksum verification failed. The downloaded file may be corrupted or compromised." -ErrorAction Continue
        if ($isSourced) { throw "Checksum verification failed." } else { $script:installExitCode = 1; return }
    }

    # 4. Place Binary & Unblock
    try {
        if (-not (Test-Path $TARGET_DIR)) { New-Item -ItemType Directory -Path $TARGET_DIR | Out-Null }
        if ($isZip) {
            Write-Host "⠋ Extracting binary from ZIP archive..."
            Expand-Archive -Path $localStagingPayload -DestinationPath $stagingDir -Force
            $extractedBinary = Join-Path $stagingDir "cli_windows_x64.exe"
            Copy-Item -Path $extractedBinary -Destination $binaryPath -Force
            Remove-Item -Path $extractedBinary -Force -ErrorAction SilentlyContinue
        } else {
            Copy-Item -Path $localStagingPayload -Destination $binaryPath -Force
        }
        Unblock-File -Path $binaryPath -ErrorAction SilentlyContinue
    } catch {
        Write-Error "Write Error: Permission denied or failed to write binary to $binaryPath." -ErrorAction Continue
        Write-Error "Please check directory permissions or if the file is locked (e.g. if 'agy.exe' is currently running)." -ErrorAction Continue
        Write-Error "Error details: $_" -ErrorAction Continue
        if ($isSourced) { throw "Fatal: Failed to install binary." } else { $script:installExitCode = 1; return }
    }

    # 5. Go-Native Setup Handoff with Passthrough Flags
    $setupFlags = @()
    if ($CUSTOM_DIR -ne "") {
        $setupFlags += "--dir"
        $setupFlags += $CUSTOM_DIR
    }
    $setupFlags += $passthroughArgs

    # Execute native environment setup (absorb non-fatal soft warning exits)
    try {
        & $binaryPath install $setupFlags
    } catch {
        # Absorb setup warnings/failures to align with Unix '|| true'.
        # The binary is successfully copied and functional on disk.
    }

    $script:installExitCode = 0
    return
}

$script:installExitCode = 0
try {
    Invoke-Install $args
} finally {
    # Guaranteed staging cleanup on success or exit error
    if ($null -ne $stagingPayload -and (Test-Path $stagingPayload)) {
        Remove-Item $stagingPayload -Force
    }
}
$exitCode = $script:installExitCode

if ($exitCode -ne 0) {
    if ($isSourced) {
        throw "Fatal: Installation failed."
    } else {
        exit $exitCode
    }
}

