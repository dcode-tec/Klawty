import type { PluginRuntime } from "klawty/plugin-sdk/core";
import { createPluginRuntimeStore } from "klawty/plugin-sdk/runtime-store";

const { setRuntime: setIMessageRuntime, getRuntime: getIMessageRuntime } =
  createPluginRuntimeStore<PluginRuntime>("iMessage runtime not initialized");
export { getIMessageRuntime, setIMessageRuntime };
