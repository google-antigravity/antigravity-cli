# Antigravity CLI

**Idiomas / Languages:** [English](./README.md) · [中文](./README-ZH.md) · [Español](./README-ES.md) · [Français](./README-FR.md) · [Português](./README-PT.md) · [Русский](./README-RU.md) · [Deutsch](./README-DE.md)

Antigravity CLI comprende tu base de código, realiza ediciones con tu permiso y ejecuta comandos, directamente desde tu terminal.

- **Documentación oficial**: [antigravity.google/docs/cli-overview](https://antigravity.google/docs/cli-overview)
- **Sitio web oficial**: [antigravity.google/product/antigravity-cli](https://antigravity.google/product/antigravity-cli)

![Antigravity CLI Demo](agy-cli-demo.gif)

---

Antigravity CLI lleva las capacidades principales de Antigravity 2.0 (razonamiento en varios pasos, edición de múltiples archivos, llamadas a herramientas e historial persistente) directamente a tu terminal. Está optimizado para flujos de trabajo basados en teclado y sesiones SSH remotas con un consumo mínimo de recursos.

---

## Funciones principales

| Función | Antigravity CLI | Antigravity 2.0 |
| :--- | :--- | :--- |
| **Enfoque principal** | Velocidad, eficiencia con teclado, bajo consumo | Integralidad, orquestación visual, gestión de proyectos |
| **Interfaz** | Interfaz de usuario de terminal (TUI) | Aplicación GUI completa |
| **Flujos de trabajo** | Sesiones SSH/remotas, teclado primero | Espacios de trabajo locales, orquestación intensiva |
| **Motor de agentes** | Motor de agentes central compartido | Motor de agentes central compartido |

---

## Integración

- **Motor de agentes compartido**: Ambas interfaces funcionan con el mismo motor de agentes central. Las mejoras se aplican automáticamente a ambas.
- **Configuración compartida**: Preferencias y permisos se sincronizan bidireccionalmente.
- **Exportación de sesiones**: Exporta sesiones de terminal a la GUI de Antigravity 2.0 para continuar trabajando.

---

## Instalación

### macOS / Linux
```bash
curl -fsSL https://antigravity.google/cli/install.sh | bash
```

### Windows PowerShell
```powershell
irm https://antigravity.google/cli/install.ps1 | iex
```

### Windows CMD
```cmd
curl -fsSL https://antigravity.google/cli/install.cmd -o install.cmd && install.cmd && del install.cmd
```

---

## Autenticación

La CLI se autentica mediante el llavero del sistema, con fallback a Google Sign-In si no existe una sesión activa.

- **Local**: Abre automáticamente tu navegador predeterminado.
- **Remoto / SSH**: Detecta sesiones SSH e imprime una URL de autorización para completar el inicio de sesión localmente.
- **Cerrar sesión**: Ejecuta `/logout` para borrar las credenciales guardadas.

> [!NOTE]
> Para acceso empresarial, conecta tu proyecto GCP durante el onboarding. Consulta la página Enterprise para más detalles.

---

## Términos de servicio y uso de datos

> [!WARNING]
> Se sabe que los agentes de codificación con IA tienen ciertos riesgos de seguridad, incluida la ejecución autónoma de código, la exfiltración de datos, la inyección de prompts y los riesgos de la cadena de suministro. Asegúrate de supervisar y verificar todas las acciones realizadas por el agente.

Al usar Antigravity CLI, aceptas ayudar a mejorar el producto permitiendo que Google recopile y use tus datos de interacción, sujetos a los Términos de servicio de Google y la Política de privacidad de Google. Puedes optar por no participar en cualquier momento desde tu configuración.

### Enlaces legales y de privacidad

- **Términos de servicio**: [antigravity.google/terms](https://antigravity.google/terms)
- **Política de privacidad**: [policies.google.com/privacy](https://policies.google.com/privacy)
