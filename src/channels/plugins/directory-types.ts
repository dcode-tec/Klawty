import type { KlawtyConfig } from "../../config/types.js";

export type DirectoryConfigParams = {
  cfg: KlawtyConfig;
  accountId?: string | null;
  query?: string | null;
  limit?: number | null;
};
