import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { existsSync, readFileSync } from "node:fs";
import { join } from "node:path";

export default function (pi: ExtensionAPI) {
  pi.on("before_agent_start", async (event) => {
    const file = join(event.systemPromptOptions.cwd, "AGENTS.local.md");

    if (!existsSync(file)) return;

    const content = readFileSync(file, "utf-8").trim();
    if (!content) return;

    return {
      systemPrompt:
        event.systemPrompt +
        `\n\n# Local project instructions from ${file}\n\n${content}`,
    };
  });
}
