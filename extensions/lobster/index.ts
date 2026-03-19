import { definePluginEntry } from "klawty/plugin-sdk/core";
import type { AnyAgentTool, KlawtyPluginApi, KlawtyPluginToolFactory } from "./runtime-api.js";
import { createLobsterTool } from "./src/lobster-tool.js";

export default definePluginEntry({
  id: "lobster",
  name: "Lobster",
  description: "Optional local shell helper tools",
  register(api: KlawtyPluginApi) {
    api.registerTool(
      ((ctx) => {
        if (ctx.sandboxed) {
          return null;
        }
        return createLobsterTool(api) as AnyAgentTool;
      }) as KlawtyPluginToolFactory,
      { optional: true },
    );
  },
});
