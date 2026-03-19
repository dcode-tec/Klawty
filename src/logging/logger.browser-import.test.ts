import { afterEach, describe, expect, it, vi } from "vitest";

type LoggerModule = typeof import("./logger.js");

const originalGetBuiltinModule = (
  process as NodeJS.Process & { getBuiltinModule?: (id: string) => unknown }
).getBuiltinModule;

async function importBrowserSafeLogger(params?: {
  resolvePreferredKlawtyTmpDir?: ReturnType<typeof vi.fn>;
}): Promise<{
  module: LoggerModule;
  resolvePreferredKlawtyTmpDir: ReturnType<typeof vi.fn>;
}> {
  vi.resetModules();
  const resolvePreferredKlawtyTmpDir =
    params?.resolvePreferredKlawtyTmpDir ??
    vi.fn(() => {
      throw new Error("resolvePreferredKlawtyTmpDir should not run during browser-safe import");
    });

  vi.doMock("../infra/tmp-klawty-dir.js", async () => {
    const actual = await vi.importActual<typeof import("../infra/tmp-klawty-dir.js")>(
      "../infra/tmp-klawty-dir.js",
    );
    return {
      ...actual,
      resolvePreferredKlawtyTmpDir,
    };
  });

  Object.defineProperty(process, "getBuiltinModule", {
    configurable: true,
    value: undefined,
  });

  const module = await import("./logger.js");
  return { module, resolvePreferredKlawtyTmpDir };
}

describe("logging/logger browser-safe import", () => {
  afterEach(() => {
    vi.resetModules();
    vi.doUnmock("../infra/tmp-klawty-dir.js");
    Object.defineProperty(process, "getBuiltinModule", {
      configurable: true,
      value: originalGetBuiltinModule,
    });
  });

  it("does not resolve the preferred temp dir at import time when node fs is unavailable", async () => {
    const { module, resolvePreferredKlawtyTmpDir } = await importBrowserSafeLogger();

    expect(resolvePreferredKlawtyTmpDir).not.toHaveBeenCalled();
    expect(module.DEFAULT_LOG_DIR).toBe("/tmp/klawty");
    expect(module.DEFAULT_LOG_FILE).toBe("/tmp/klawty/klawty.log");
  });

  it("disables file logging when imported in a browser-like environment", async () => {
    const { module, resolvePreferredKlawtyTmpDir } = await importBrowserSafeLogger();

    expect(module.getResolvedLoggerSettings()).toMatchObject({
      level: "silent",
      file: "/tmp/klawty/klawty.log",
    });
    expect(module.isFileLogLevelEnabled("info")).toBe(false);
    expect(() => module.getLogger().info("browser-safe")).not.toThrow();
    expect(resolvePreferredKlawtyTmpDir).not.toHaveBeenCalled();
  });
});
