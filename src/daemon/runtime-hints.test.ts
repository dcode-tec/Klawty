import { describe, expect, it } from "vitest";
import { buildPlatformRuntimeLogHints, buildPlatformServiceStartHints } from "./runtime-hints.js";

describe("buildPlatformRuntimeLogHints", () => {
  it("renders launchd log hints on darwin", () => {
    expect(
      buildPlatformRuntimeLogHints({
        platform: "darwin",
        env: {
          KLAWTY_STATE_DIR: "/tmp/klawty-state",
          KLAWTY_LOG_PREFIX: "gateway",
        },
        systemdServiceName: "klawty-gateway",
        windowsTaskName: "Klawty Gateway",
      }),
    ).toEqual([
      "Launchd stdout (if installed): /tmp/klawty-state/logs/gateway.log",
      "Launchd stderr (if installed): /tmp/klawty-state/logs/gateway.err.log",
    ]);
  });

  it("renders systemd and windows hints by platform", () => {
    expect(
      buildPlatformRuntimeLogHints({
        platform: "linux",
        systemdServiceName: "klawty-gateway",
        windowsTaskName: "Klawty Gateway",
      }),
    ).toEqual(["Logs: journalctl --user -u klawty-gateway.service -n 200 --no-pager"]);
    expect(
      buildPlatformRuntimeLogHints({
        platform: "win32",
        systemdServiceName: "klawty-gateway",
        windowsTaskName: "Klawty Gateway",
      }),
    ).toEqual(['Logs: schtasks /Query /TN "Klawty Gateway" /V /FO LIST']);
  });
});

describe("buildPlatformServiceStartHints", () => {
  it("builds platform-specific service start hints", () => {
    expect(
      buildPlatformServiceStartHints({
        platform: "darwin",
        installCommand: "klawty gateway install",
        startCommand: "klawty gateway",
        launchAgentPlistPath: "~/Library/LaunchAgents/com.klawty.gateway.plist",
        systemdServiceName: "klawty-gateway",
        windowsTaskName: "Klawty Gateway",
      }),
    ).toEqual([
      "klawty gateway install",
      "klawty gateway",
      "launchctl bootstrap gui/$UID ~/Library/LaunchAgents/com.klawty.gateway.plist",
    ]);
    expect(
      buildPlatformServiceStartHints({
        platform: "linux",
        installCommand: "klawty gateway install",
        startCommand: "klawty gateway",
        launchAgentPlistPath: "~/Library/LaunchAgents/com.klawty.gateway.plist",
        systemdServiceName: "klawty-gateway",
        windowsTaskName: "Klawty Gateway",
      }),
    ).toEqual([
      "klawty gateway install",
      "klawty gateway",
      "systemctl --user start klawty-gateway.service",
    ]);
  });
});
