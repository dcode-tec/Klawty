import { describe, expect, it } from "vitest";
import { formatBackupCreateSummary, type BackupCreateResult } from "./backup-create.js";

function makeResult(overrides: Partial<BackupCreateResult> = {}): BackupCreateResult {
  return {
    createdAt: "2026-01-01T00:00:00.000Z",
    archiveRoot: "klawty-backup-2026-01-01",
    archivePath: "/tmp/klawty-backup.tar.gz",
    dryRun: false,
    includeWorkspace: true,
    onlyConfig: false,
    verified: false,
    assets: [],
    skipped: [],
    ...overrides,
  };
}

describe("formatBackupCreateSummary", () => {
  it("formats created archives with included and skipped paths", () => {
    const lines = formatBackupCreateSummary(
      makeResult({
        verified: true,
        assets: [
          {
            kind: "state",
            sourcePath: "/state",
            archivePath: "archive/state",
            displayPath: "~/.klawty",
          },
        ],
        skipped: [
          {
            kind: "workspace",
            sourcePath: "/workspace",
            displayPath: "~/Projects/klawty",
            reason: "covered",
            coveredBy: "~/.klawty",
          },
        ],
      }),
    );

    expect(lines).toEqual([
      "Backup archive: /tmp/klawty-backup.tar.gz",
      "Included 1 path:",
      "- state: ~/.klawty",
      "Skipped 1 path:",
      "- workspace: ~/Projects/klawty (covered by ~/.klawty)",
      "Created /tmp/klawty-backup.tar.gz",
      "Archive verification: passed",
    ]);
  });

  it("formats dry runs and pluralized counts", () => {
    const lines = formatBackupCreateSummary(
      makeResult({
        dryRun: true,
        assets: [
          {
            kind: "config",
            sourcePath: "/config",
            archivePath: "archive/config",
            displayPath: "~/.klawty/config.json",
          },
          {
            kind: "credentials",
            sourcePath: "/oauth",
            archivePath: "archive/oauth",
            displayPath: "~/.klawty/oauth",
          },
        ],
      }),
    );

    expect(lines).toEqual([
      "Backup archive: /tmp/klawty-backup.tar.gz",
      "Included 2 paths:",
      "- config: ~/.klawty/config.json",
      "- credentials: ~/.klawty/oauth",
      "Dry run only; archive was not written.",
    ]);
  });
});
