import { describe, expect, it } from "vitest";
import { shortenText } from "./text-format.js";

describe("shortenText", () => {
  it("returns original text when it fits", () => {
    expect(shortenText("klawty", 16)).toBe("klawty");
  });

  it("truncates and appends ellipsis when over limit", () => {
    expect(shortenText("klawty-status-output", 10)).toBe("klawty-…");
  });

  it("counts multi-byte characters correctly", () => {
    expect(shortenText("hello🙂world", 7)).toBe("hello🙂…");
  });
});
