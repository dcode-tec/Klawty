import { definePluginEntry } from "klawty/plugin-sdk/core";
import { buildElevenLabsSpeechProvider } from "klawty/plugin-sdk/speech";

export default definePluginEntry({
  id: "elevenlabs",
  name: "ElevenLabs Speech",
  description: "Bundled ElevenLabs speech provider",
  register(api) {
    api.registerSpeechProvider(buildElevenLabsSpeechProvider());
  },
});
