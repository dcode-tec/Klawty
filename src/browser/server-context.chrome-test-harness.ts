import { vi } from "vitest";
import { installChromeUserDataDirHooks } from "./chrome-user-data-dir.test-harness.js";

const chromeUserDataDir = { dir: "/tmp/klawty" };
installChromeUserDataDirHooks(chromeUserDataDir);

vi.mock("./chrome.js", () => ({
  isChromeCdpReady: vi.fn(async () => true),
  isChromeReachable: vi.fn(async () => true),
  launchKlawtyChrome: vi.fn(async () => {
    throw new Error("unexpected launch");
  }),
  resolveKlawtyUserDataDir: vi.fn(() => chromeUserDataDir.dir),
  stopKlawtyChrome: vi.fn(async () => {}),
}));
