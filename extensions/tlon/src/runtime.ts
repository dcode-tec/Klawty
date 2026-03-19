import type { PluginRuntime } from "klawty/plugin-sdk/plugin-runtime";
import { createPluginRuntimeStore } from "klawty/plugin-sdk/runtime-store";

const { setRuntime: setTlonRuntime, getRuntime: getTlonRuntime } =
  createPluginRuntimeStore<PluginRuntime>("Tlon runtime not initialized");
export { getTlonRuntime, setTlonRuntime };
