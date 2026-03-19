---
summary: "Install Klawty — installer script, npm/pnpm, from source, Docker, and more"
read_when:
  - You need an install method other than the Getting Started quickstart
  - You want to deploy to a cloud platform
  - You need to update, migrate, or uninstall
title: "Install"
---

# Install

Already followed [Getting Started](/start/getting-started)? You're all set — this page is for alternative install methods, platform-specific instructions, and maintenance.

## System requirements

- **[Node 24 (recommended)](/install/node)** (Node 22 LTS, currently `22.16+`, is still supported for compatibility; the [installer script](#install-methods) will install Node 24 if missing)
- macOS, Linux, or Windows
- `pnpm` only if you build from source

<Note>
On Windows, we strongly recommend running Klawty under [WSL2](https://learn.microsoft.com/en-us/windows/wsl/install).
</Note>

## Install methods

<Tip>
The **installer script** is the recommended way to install Klawty. It handles Node detection, installation, and onboarding in one step.
</Tip>

<Warning>
For VPS/cloud hosts, avoid third-party "1-click" marketplace images when possible. Prefer a clean base OS image (for example Ubuntu LTS), then install Klawty yourself with the installer script.
</Warning>

<AccordionGroup>
  <Accordion title="Installer script" icon="rocket" defaultOpen>
    Downloads the CLI, installs it globally via npm, and launches onboarding.

    <Tabs>
      <Tab title="macOS / Linux / WSL2">
        ```bash
        curl -fsSL https://klawty.ai/install.sh | bash
        ```
      </Tab>
      <Tab title="Windows (PowerShell)">
        ```powershell
        iwr -useb https://klawty.ai/install.ps1 | iex
        ```
      </Tab>
    </Tabs>

    That's it — the script handles Node detection, installation, and onboarding.

    To skip onboarding and just install the binary:

    <Tabs>
      <Tab title="macOS / Linux / WSL2">
        ```bash
        curl -fsSL https://klawty.ai/install.sh | bash -s -- --no-onboard
        ```
      </Tab>
      <Tab title="Windows (PowerShell)">
        ```powershell
        & ([scriptblock]::Create((iwr -useb https://klawty.ai/install.ps1))) -NoOnboard
        ```
      </Tab>
    </Tabs>

    For all flags, env vars, and CI/automation options, see [Installer internals](/install/installer).

  </Accordion>

  <Accordion title="npm / pnpm" icon="package">
    If you already manage Node yourself, we recommend Node 24. Klawty still supports Node 22 LTS, currently `22.16+`, for compatibility:

    <Tabs>
      <Tab title="npm">
        ```bash
        npm install -g klawty@latest
        klawty onboard --install-daemon
        ```

        <Accordion title="sharp build errors?">
          If you have libvips installed globally (common on macOS via Homebrew) and `sharp` fails, force prebuilt binaries:

          ```bash
          SHARP_IGNORE_GLOBAL_LIBVIPS=1 npm install -g klawty@latest
          ```

          If you see `sharp: Please add node-gyp to your dependencies`, either install build tooling (macOS: Xcode CLT + `npm install -g node-gyp`) or use the env var above.
        </Accordion>
      </Tab>
      <Tab title="pnpm">
        ```bash
        pnpm add -g klawty@latest
        pnpm approve-builds -g        # approve klawty, node-llama-cpp, sharp, etc.
        klawty onboard --install-daemon
        ```

        <Note>
        pnpm requires explicit approval for packages with build scripts. After the first install shows the "Ignored build scripts" warning, run `pnpm approve-builds -g` and select the listed packages.
        </Note>
      </Tab>
    </Tabs>

    Want the current GitHub `main` head with a package-manager install?

    ```bash
    npm install -g github:klawty/klawty#main
    ```

    ```bash
    pnpm add -g github:klawty/klawty#main
    ```

  </Accordion>

  <Accordion title="From source" icon="github">
    For contributors or anyone who wants to run from a local checkout.

    <Steps>
      <Step title="Clone and build">
        Clone the [Klawty repo](https://github.com/klawty/klawty) and build:

        ```bash
        git clone https://github.com/klawty/klawty.git
        cd klawty
        pnpm install
        pnpm ui:build
        pnpm build
        ```
      </Step>
      <Step title="Link the CLI">
        Make the `klawty` command available globally:

        ```bash
        pnpm link --global
        ```

        Alternatively, skip the link and run commands via `pnpm klawty ...` from inside the repo.
      </Step>
      <Step title="Run onboarding">
        ```bash
        klawty onboard --install-daemon
        ```
      </Step>
    </Steps>

    For deeper development workflows, see [Setup](/start/setup).

  </Accordion>
</AccordionGroup>

## Other install methods

<CardGroup cols={2}>
  <Card title="Docker" href="/install/docker" icon="container">
    Containerized or headless deployments.
  </Card>
  <Card title="Podman" href="/install/podman" icon="container">
    Rootless container: run `setup-podman.sh` once, then the launch script.
  </Card>
  <Card title="Nix" href="/install/nix" icon="snowflake">
    Declarative install via Nix.
  </Card>
  <Card title="Ansible" href="/install/ansible" icon="server">
    Automated fleet provisioning.
  </Card>
  <Card title="Bun" href="/install/bun" icon="zap">
    CLI-only usage via the Bun runtime.
  </Card>
</CardGroup>

## After install

Verify everything is working:

```bash
klawty doctor         # check for config issues
klawty status         # gateway status
klawty dashboard      # open the browser UI
```

If you need custom runtime paths, use:

- `KLAWTY_HOME` for home-directory based internal paths
- `KLAWTY_STATE_DIR` for mutable state location
- `KLAWTY_CONFIG_PATH` for config file location

See [Environment vars](/help/environment) for precedence and full details.

## Troubleshooting: `klawty` not found

<Accordion title="PATH diagnosis and fix">
  Quick diagnosis:

```bash
node -v
npm -v
npm prefix -g
echo "$PATH"
```

If `$(npm prefix -g)/bin` (macOS/Linux) or `$(npm prefix -g)` (Windows) is **not** in your `$PATH`, your shell can't find global npm binaries (including `klawty`).

Fix — add it to your shell startup file (`~/.zshrc` or `~/.bashrc`):

```bash
export PATH="$(npm prefix -g)/bin:$PATH"
```

On Windows, add the output of `npm prefix -g` to your PATH.

Then open a new terminal (or `rehash` in zsh / `hash -r` in bash).
</Accordion>

## Update / uninstall

<CardGroup cols={3}>
  <Card title="Updating" href="/install/updating" icon="refresh-cw">
    Keep Klawty up to date.
  </Card>
  <Card title="Migrating" href="/install/migrating" icon="arrow-right">
    Move to a new machine.
  </Card>
  <Card title="Uninstall" href="/install/uninstall" icon="trash-2">
    Remove Klawty completely.
  </Card>
</CardGroup>
