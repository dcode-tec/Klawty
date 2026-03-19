import { describe, expect, it } from "vitest";
import { normalizePackageTagInput } from "./package-tag.js";

describe("normalizePackageTagInput", () => {
  const packageNames = ["klawty", "@klawty/plugin"] as const;

  it("returns null for blank inputs", () => {
    expect(normalizePackageTagInput(undefined, packageNames)).toBeNull();
    expect(normalizePackageTagInput("   ", packageNames)).toBeNull();
  });

  it("strips known package-name prefixes before returning the tag", () => {
    expect(normalizePackageTagInput("klawty@beta", packageNames)).toBe("beta");
    expect(normalizePackageTagInput("@klawty/plugin@2026.2.24", packageNames)).toBe("2026.2.24");
    expect(normalizePackageTagInput("klawty@   ", packageNames)).toBeNull();
  });

  it("treats exact known package names as an empty tag", () => {
    expect(normalizePackageTagInput("klawty", packageNames)).toBeNull();
    expect(normalizePackageTagInput(" @klawty/plugin ", packageNames)).toBeNull();
  });

  it("returns trimmed raw values when no package prefix matches", () => {
    expect(normalizePackageTagInput(" latest ", packageNames)).toBe("latest");
    expect(normalizePackageTagInput("@other/plugin@beta", packageNames)).toBe("@other/plugin@beta");
    expect(normalizePackageTagInput("klawtyer@beta", packageNames)).toBe("klawtyer@beta");
  });
});
