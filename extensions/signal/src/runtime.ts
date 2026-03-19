import type { PluginRuntime } from "klawty/plugin-sdk/core";
import { createPluginRuntimeStore } from "klawty/plugin-sdk/runtime-store";

const { setRuntime: setSignalRuntime, getRuntime: getSignalRuntime } =
  createPluginRuntimeStore<PluginRuntime>("Signal runtime not initialized");
export { getSignalRuntime, setSignalRuntime };
