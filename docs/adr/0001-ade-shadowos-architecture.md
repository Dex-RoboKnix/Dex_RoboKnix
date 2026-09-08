# ADR 0001: ADE as Native Desktop Shell hosting ShadowOS Web UI

- **Status**: superseded by [ADR 0006](0006-shadowos-is-the-container-ade-is-the-harness.md)
- **Date**: 2026-07-27
- **Superseded**: 2026-07-31

> **Superseded.** ADR-0006 reverses this ADR's layer map: ShadowOS (L2) is the
> desktop container and ADE (L3) is the harness layer inside it. This ADR's
> *engineering* conclusion survives — there is still exactly one desktop runtime,
> one Tauri binary — but the naming of which layer is which is reversed. Read
> ADR-0006 before relying on anything below.

## Context
The master specification previously described ShadowOS as an L2 browser desktop OS and ADE as an L3 application sitting on top of it. Meanwhile, the actual ADE repository implements a native desktop shell using Tauri, SolidJS, and Rust. Having two separate desktop runtimes (a web browser desktop and a Tauri desktop) creates duplicate maintenance overhead and architectural ambiguity.

## Decision
We decide that **ADE (Tauri/SolidJS/Rust)** is the single native desktop container and shell for DexRoboKnix. **ShadowOS** web components (UI windows, apps, desktop environment) are integrated directly inside ADE's webview UI layer.

## Consequences
- Single unified desktop runtime for local desktop execution.
- Direct access from ShadowOS web components to Tauri Rust IPC, native file system capabilities, system tray, and terminal bindings.
- Web-only standalone ShadowOS deployment remains possible by running the web frontend without the Tauri native shell wrapper.
