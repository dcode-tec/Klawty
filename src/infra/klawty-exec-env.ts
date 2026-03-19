export const KLAWTY_CLI_ENV_VAR = "KLAWTY_CLI";
export const KLAWTY_CLI_ENV_VALUE = "1";

export function markKlawtyExecEnv<T extends Record<string, string | undefined>>(env: T): T {
  return {
    ...env,
    [KLAWTY_CLI_ENV_VAR]: KLAWTY_CLI_ENV_VALUE,
  };
}

export function ensureKlawtyExecMarkerOnProcess(
  env: NodeJS.ProcessEnv = process.env,
): NodeJS.ProcessEnv {
  env[KLAWTY_CLI_ENV_VAR] = KLAWTY_CLI_ENV_VALUE;
  return env;
}
