import { describe, expect, it } from "vitest";
import { resolveIrcInboundTarget } from "./monitor.js";

describe("irc monitor inbound target", () => {
  it("keeps channel target for group messages", () => {
    expect(
      resolveIrcInboundTarget({
        target: "#klawty",
        senderNick: "alice",
      }),
    ).toEqual({
      isGroup: true,
      target: "#klawty",
      rawTarget: "#klawty",
    });
  });

  it("maps DM target to sender nick and preserves raw target", () => {
    expect(
      resolveIrcInboundTarget({
        target: "klawty-bot",
        senderNick: "alice",
      }),
    ).toEqual({
      isGroup: false,
      target: "alice",
      rawTarget: "klawty-bot",
    });
  });

  it("falls back to raw target when sender nick is empty", () => {
    expect(
      resolveIrcInboundTarget({
        target: "klawty-bot",
        senderNick: " ",
      }),
    ).toEqual({
      isGroup: false,
      target: "klawty-bot",
      rawTarget: "klawty-bot",
    });
  });
});
