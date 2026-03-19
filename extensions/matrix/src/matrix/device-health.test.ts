import { describe, expect, it } from "vitest";
import { isKlawtyManagedMatrixDevice, summarizeMatrixDeviceHealth } from "./device-health.js";

describe("matrix device health", () => {
  it("detects Klawty-managed device names", () => {
    expect(isKlawtyManagedMatrixDevice("Klawty Gateway")).toBe(true);
    expect(isKlawtyManagedMatrixDevice("Klawty Debug")).toBe(true);
    expect(isKlawtyManagedMatrixDevice("Element iPhone")).toBe(false);
    expect(isKlawtyManagedMatrixDevice(null)).toBe(false);
  });

  it("summarizes stale Klawty-managed devices separately from the current device", () => {
    const summary = summarizeMatrixDeviceHealth([
      {
        deviceId: "du314Zpw3A",
        displayName: "Klawty Gateway",
        current: true,
      },
      {
        deviceId: "BritdXC6iL",
        displayName: "Klawty Gateway",
        current: false,
      },
      {
        deviceId: "G6NJU9cTgs",
        displayName: "Klawty Debug",
        current: false,
      },
      {
        deviceId: "phone123",
        displayName: "Element iPhone",
        current: false,
      },
    ]);

    expect(summary.currentDeviceId).toBe("du314Zpw3A");
    expect(summary.currentKlawtyDevices).toEqual([
      expect.objectContaining({ deviceId: "du314Zpw3A" }),
    ]);
    expect(summary.staleKlawtyDevices).toEqual([
      expect.objectContaining({ deviceId: "BritdXC6iL" }),
      expect.objectContaining({ deviceId: "G6NJU9cTgs" }),
    ]);
  });
});
