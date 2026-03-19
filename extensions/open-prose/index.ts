import { definePluginEntry, type KlawtyPluginApi } from "./runtime-api.js";

export default definePluginEntry({
  id: "open-prose",
  name: "OpenProse",
  description: "Plugin-shipped prose skills bundle",
  register(_api: KlawtyPluginApi) {
    // OpenProse is delivered via plugin-shipped skills.
  },
});
