# DexCLI connects to ShadowOS desktops via the ADE protocol

DexCLI (L3, currently a stub agent-swarm orchestrator with no ADE/MCP code) will drive ShadowOS desktops by speaking ADE's existing protocol, making DexCLI a **Harness** in the sense already defined in `CONTEXT.md` — the same role Claude Desktop or Codex CLI play. This was a real choice: DexCLI could have stayed desktop-agnostic (terminal-only agent swarm engine, no relationship to ShadowOS). Decided 2026-08-06 during a grilling session; neither side has implementation yet, so this records intent ahead of code.
