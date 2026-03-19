import { listSkillCommandsForAgents as listSkillCommandsForAgentsImpl } from "klawty/plugin-sdk/reply-runtime";

type ListSkillCommandsForAgents =
  typeof import("klawty/plugin-sdk/reply-runtime").listSkillCommandsForAgents;

export function listSkillCommandsForAgents(
  ...args: Parameters<ListSkillCommandsForAgents>
): ReturnType<ListSkillCommandsForAgents> {
  return listSkillCommandsForAgentsImpl(...args);
}
