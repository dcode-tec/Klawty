import { beforeEach, describe, expect, it, vi } from "vitest";

const installPluginFromNpmSpecMock = vi.fn();
const installPluginFromMarketplaceMock = vi.fn();
const resolveBundledPluginSourcesMock = vi.fn();

vi.mock("./install.js", () => ({
  installPluginFromNpmSpec: (...args: unknown[]) => installPluginFromNpmSpecMock(...args),
  resolvePluginInstallDir: (pluginId: string) => `/tmp/${pluginId}`,
  PLUGIN_INSTALL_ERROR_CODE: {
    NPM_PACKAGE_NOT_FOUND: "npm_package_not_found",
  },
}));

vi.mock("./marketplace.js", () => ({
  installPluginFromMarketplace: (...args: unknown[]) => installPluginFromMarketplaceMock(...args),
}));

vi.mock("./bundled-sources.js", () => ({
  resolveBundledPluginSources: (...args: unknown[]) => resolveBundledPluginSourcesMock(...args),
}));

const { syncPluginsForUpdateChannel, updateNpmInstalledPlugins } = await import("./update.js");

describe("updateNpmInstalledPlugins", () => {
  beforeEach(() => {
    installPluginFromNpmSpecMock.mockReset();
    installPluginFromMarketplaceMock.mockReset();
    resolveBundledPluginSourcesMock.mockReset();
  });

  it("skips integrity drift checks for unpinned npm specs during dry-run updates", async () => {
    installPluginFromNpmSpecMock.mockResolvedValue({
      ok: true,
      pluginId: "opik-klawty",
      targetDir: "/tmp/opik-klawty",
      version: "0.2.6",
      extensions: ["index.ts"],
    });

    await updateNpmInstalledPlugins({
      config: {
        plugins: {
          installs: {
            "opik-klawty": {
              source: "npm",
              spec: "@opik/opik-klawty",
              integrity: "sha512-old",
              installPath: "/tmp/opik-klawty",
            },
          },
        },
      },
      pluginIds: ["opik-klawty"],
      dryRun: true,
    });

    expect(installPluginFromNpmSpecMock).toHaveBeenCalledWith(
      expect.objectContaining({
        spec: "@opik/opik-klawty",
        expectedIntegrity: undefined,
      }),
    );
  });

  it("keeps integrity drift checks for exact-version npm specs during dry-run updates", async () => {
    installPluginFromNpmSpecMock.mockResolvedValue({
      ok: true,
      pluginId: "opik-klawty",
      targetDir: "/tmp/opik-klawty",
      version: "0.2.6",
      extensions: ["index.ts"],
    });

    await updateNpmInstalledPlugins({
      config: {
        plugins: {
          installs: {
            "opik-klawty": {
              source: "npm",
              spec: "@opik/opik-klawty@0.2.5",
              integrity: "sha512-old",
              installPath: "/tmp/opik-klawty",
            },
          },
        },
      },
      pluginIds: ["opik-klawty"],
      dryRun: true,
    });

    expect(installPluginFromNpmSpecMock).toHaveBeenCalledWith(
      expect.objectContaining({
        spec: "@opik/opik-klawty@0.2.5",
        expectedIntegrity: "sha512-old",
      }),
    );
  });

  it("formats package-not-found updates with a stable message", async () => {
    installPluginFromNpmSpecMock.mockResolvedValue({
      ok: false,
      code: "npm_package_not_found",
      error: "Package not found on npm: @klawty/missing.",
    });

    const result = await updateNpmInstalledPlugins({
      config: {
        plugins: {
          installs: {
            missing: {
              source: "npm",
              spec: "@klawty/missing",
              installPath: "/tmp/missing",
            },
          },
        },
      },
      pluginIds: ["missing"],
      dryRun: true,
    });

    expect(result.outcomes).toEqual([
      {
        pluginId: "missing",
        status: "error",
        message: "Failed to check missing: npm package not found for @klawty/missing.",
      },
    ]);
  });

  it("falls back to raw installer error for unknown error codes", async () => {
    installPluginFromNpmSpecMock.mockResolvedValue({
      ok: false,
      code: "invalid_npm_spec",
      error: "unsupported npm spec: github:evil/evil",
    });

    const result = await updateNpmInstalledPlugins({
      config: {
        plugins: {
          installs: {
            bad: {
              source: "npm",
              spec: "github:evil/evil",
              installPath: "/tmp/bad",
            },
          },
        },
      },
      pluginIds: ["bad"],
      dryRun: true,
    });

    expect(result.outcomes).toEqual([
      {
        pluginId: "bad",
        status: "error",
        message: "Failed to check bad: unsupported npm spec: github:evil/evil",
      },
    ]);
  });

  it("migrates legacy unscoped install keys when a scoped npm package updates", async () => {
    installPluginFromNpmSpecMock.mockResolvedValue({
      ok: true,
      pluginId: "@klawty/voice-call",
      targetDir: "/tmp/klawty-voice-call",
      version: "0.0.2",
      extensions: ["index.ts"],
    });

    const result = await updateNpmInstalledPlugins({
      config: {
        plugins: {
          allow: ["voice-call"],
          deny: ["voice-call"],
          slots: { memory: "voice-call" },
          entries: {
            "voice-call": {
              enabled: false,
              hooks: { allowPromptInjection: false },
            },
          },
          installs: {
            "voice-call": {
              source: "npm",
              spec: "@klawty/voice-call",
              installPath: "/tmp/voice-call",
            },
          },
        },
      },
      pluginIds: ["voice-call"],
    });

    expect(installPluginFromNpmSpecMock).toHaveBeenCalledWith(
      expect.objectContaining({
        spec: "@klawty/voice-call",
        expectedPluginId: "voice-call",
      }),
    );
    expect(result.config.plugins?.allow).toEqual(["@klawty/voice-call"]);
    expect(result.config.plugins?.deny).toEqual(["@klawty/voice-call"]);
    expect(result.config.plugins?.slots?.memory).toBe("@klawty/voice-call");
    expect(result.config.plugins?.entries?.["@klawty/voice-call"]).toEqual({
      enabled: false,
      hooks: { allowPromptInjection: false },
    });
    expect(result.config.plugins?.entries?.["voice-call"]).toBeUndefined();
    expect(result.config.plugins?.installs?.["@klawty/voice-call"]).toMatchObject({
      source: "npm",
      spec: "@klawty/voice-call",
      installPath: "/tmp/klawty-voice-call",
      version: "0.0.2",
    });
    expect(result.config.plugins?.installs?.["voice-call"]).toBeUndefined();
  });

  it("checks marketplace installs during dry-run updates", async () => {
    installPluginFromMarketplaceMock.mockResolvedValue({
      ok: true,
      pluginId: "claude-bundle",
      targetDir: "/tmp/claude-bundle",
      version: "1.2.0",
      extensions: ["index.ts"],
      marketplaceSource: "vincentkoc/claude-marketplace",
      marketplacePlugin: "claude-bundle",
    });

    const result = await updateNpmInstalledPlugins({
      config: {
        plugins: {
          installs: {
            "claude-bundle": {
              source: "marketplace",
              marketplaceSource: "vincentkoc/claude-marketplace",
              marketplacePlugin: "claude-bundle",
              installPath: "/tmp/claude-bundle",
            },
          },
        },
      },
      pluginIds: ["claude-bundle"],
      dryRun: true,
    });

    expect(installPluginFromMarketplaceMock).toHaveBeenCalledWith(
      expect.objectContaining({
        marketplace: "vincentkoc/claude-marketplace",
        plugin: "claude-bundle",
        expectedPluginId: "claude-bundle",
        dryRun: true,
      }),
    );
    expect(result.outcomes).toEqual([
      {
        pluginId: "claude-bundle",
        status: "updated",
        currentVersion: undefined,
        nextVersion: "1.2.0",
        message: "Would update claude-bundle: unknown -> 1.2.0.",
      },
    ]);
  });

  it("updates marketplace installs and preserves source metadata", async () => {
    installPluginFromMarketplaceMock.mockResolvedValue({
      ok: true,
      pluginId: "claude-bundle",
      targetDir: "/tmp/claude-bundle",
      version: "1.3.0",
      extensions: ["index.ts"],
      marketplaceName: "Vincent's Claude Plugins",
      marketplaceSource: "vincentkoc/claude-marketplace",
      marketplacePlugin: "claude-bundle",
    });

    const result = await updateNpmInstalledPlugins({
      config: {
        plugins: {
          installs: {
            "claude-bundle": {
              source: "marketplace",
              marketplaceName: "Vincent's Claude Plugins",
              marketplaceSource: "vincentkoc/claude-marketplace",
              marketplacePlugin: "claude-bundle",
              installPath: "/tmp/claude-bundle",
            },
          },
        },
      },
      pluginIds: ["claude-bundle"],
    });

    expect(result.changed).toBe(true);
    expect(result.config.plugins?.installs?.["claude-bundle"]).toMatchObject({
      source: "marketplace",
      installPath: "/tmp/claude-bundle",
      version: "1.3.0",
      marketplaceName: "Vincent's Claude Plugins",
      marketplaceSource: "vincentkoc/claude-marketplace",
      marketplacePlugin: "claude-bundle",
    });
  });
});

describe("syncPluginsForUpdateChannel", () => {
  beforeEach(() => {
    installPluginFromNpmSpecMock.mockReset();
    resolveBundledPluginSourcesMock.mockReset();
  });

  it("keeps bundled path installs on beta without reinstalling from npm", async () => {
    resolveBundledPluginSourcesMock.mockReturnValue(
      new Map([
        [
          "feishu",
          {
            pluginId: "feishu",
            localPath: "/app/extensions/feishu",
            npmSpec: "@klawty/feishu",
          },
        ],
      ]),
    );

    const result = await syncPluginsForUpdateChannel({
      channel: "beta",
      config: {
        plugins: {
          load: { paths: ["/app/extensions/feishu"] },
          installs: {
            feishu: {
              source: "path",
              sourcePath: "/app/extensions/feishu",
              installPath: "/app/extensions/feishu",
              spec: "@klawty/feishu",
            },
          },
        },
      },
    });

    expect(installPluginFromNpmSpecMock).not.toHaveBeenCalled();
    expect(result.changed).toBe(false);
    expect(result.summary.switchedToNpm).toEqual([]);
    expect(result.config.plugins?.load?.paths).toEqual(["/app/extensions/feishu"]);
    expect(result.config.plugins?.installs?.feishu?.source).toBe("path");
  });

  it("repairs bundled install metadata when the load path is re-added", async () => {
    resolveBundledPluginSourcesMock.mockReturnValue(
      new Map([
        [
          "feishu",
          {
            pluginId: "feishu",
            localPath: "/app/extensions/feishu",
            npmSpec: "@klawty/feishu",
          },
        ],
      ]),
    );

    const result = await syncPluginsForUpdateChannel({
      channel: "beta",
      config: {
        plugins: {
          load: { paths: [] },
          installs: {
            feishu: {
              source: "path",
              sourcePath: "/app/extensions/feishu",
              installPath: "/tmp/old-feishu",
              spec: "@klawty/feishu",
            },
          },
        },
      },
    });

    expect(result.changed).toBe(true);
    expect(result.config.plugins?.load?.paths).toEqual(["/app/extensions/feishu"]);
    expect(result.config.plugins?.installs?.feishu).toMatchObject({
      source: "path",
      sourcePath: "/app/extensions/feishu",
      installPath: "/app/extensions/feishu",
      spec: "@klawty/feishu",
    });
    expect(installPluginFromNpmSpecMock).not.toHaveBeenCalled();
  });

  it("forwards an explicit env to bundled plugin source resolution", async () => {
    resolveBundledPluginSourcesMock.mockReturnValue(new Map());
    const env = { KLAWTY_HOME: "/srv/klawty-home" } as NodeJS.ProcessEnv;

    await syncPluginsForUpdateChannel({
      channel: "beta",
      config: {},
      workspaceDir: "/workspace",
      env,
    });

    expect(resolveBundledPluginSourcesMock).toHaveBeenCalledWith({
      workspaceDir: "/workspace",
      env,
    });
  });

  it("uses the provided env when matching bundled load and install paths", async () => {
    const bundledHome = "/tmp/klawty-home";
    resolveBundledPluginSourcesMock.mockReturnValue(
      new Map([
        [
          "feishu",
          {
            pluginId: "feishu",
            localPath: `${bundledHome}/plugins/feishu`,
            npmSpec: "@klawty/feishu",
          },
        ],
      ]),
    );

    const previousHome = process.env.HOME;
    process.env.HOME = "/tmp/process-home";
    try {
      const result = await syncPluginsForUpdateChannel({
        channel: "beta",
        env: {
          ...process.env,
          KLAWTY_HOME: bundledHome,
          HOME: "/tmp/ignored-home",
        },
        config: {
          plugins: {
            load: { paths: ["~/plugins/feishu"] },
            installs: {
              feishu: {
                source: "path",
                sourcePath: "~/plugins/feishu",
                installPath: "~/plugins/feishu",
                spec: "@klawty/feishu",
              },
            },
          },
        },
      });

      expect(result.changed).toBe(false);
      expect(result.config.plugins?.load?.paths).toEqual(["~/plugins/feishu"]);
      expect(result.config.plugins?.installs?.feishu).toMatchObject({
        source: "path",
        sourcePath: "~/plugins/feishu",
        installPath: "~/plugins/feishu",
      });
    } finally {
      if (previousHome === undefined) {
        delete process.env.HOME;
      } else {
        process.env.HOME = previousHome;
      }
    }
  });
});
