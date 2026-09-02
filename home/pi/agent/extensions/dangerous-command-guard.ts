import type { ExtensionAPI, ExtensionContext } from "@earendil-works/pi-coding-agent";

type DangerousRule = {
	name: string;
	pattern: RegExp;
	description: string;
};

const dangerousRules: DangerousRule[] = [
	{
		name: "recursive-remove",
		pattern: /(^|[;&|()\s])rm\s+(?:-[A-Za-z]*[rR][A-Za-z]*[fF]?|-[A-Za-z]*[fF][A-Za-z]*[rR]|--recursive|--no-preserve-root)\b/,
		description: "Recursive file deletion with rm",
	},
	{
		name: "sudo",
		pattern: /(^|[;&|()\s])sudo\b/,
		description: "Command execution with sudo privileges",
	},
	{
		name: "disk-format-or-write",
		pattern: /(^|[;&|()\s])(mkfs(?:\.[\w-]+)?|fdisk|parted|diskutil|dd)\b|>\s*\/dev\/(?:sd|hd|vd|nvme|disk)\w+/,
		description: "Command that may modify disks or partitions",
	},
	{
		name: "permission-wide-open",
		pattern: /(^|[;&|()\s])chmod\s+(?:-[A-Za-z]+\s+)*777\b/,
		description: "chmod command that sets permissions to 777",
	},
	{
		name: "ownership-change",
		pattern: /(^|[;&|()\s])chown\b.*\s(?:\/|\.\.|~|\*)/,
		description: "chown command that may broadly change ownership",
	},
	{
		name: "git-destructive",
		pattern: /(^|[;&|()\s])git\s+(?:reset\s+--hard|clean\s+-[A-Za-z]*[dfx][A-Za-z]*)\b/,
		description: "Git command that may remove uncommitted changes or untracked files",
	},
	{
		name: "container-prune",
		pattern: /(^|[;&|()\s])(?:docker|podman)\s+(?:system\s+prune|volume\s+prune|image\s+prune|container\s+prune)\b/,
		description: "Command that bulk-removes container-related resources",
	},
	{
		name: "cluster-delete",
		pattern: /(^|[;&|()\s])kubectl\s+delete\b/,
		description: "kubectl command that deletes Kubernetes resources",
	},
	{
		name: "service-power",
		pattern: /(^|[;&|()\s])(shutdown|reboot|halt|poweroff|systemctl\s+(?:stop|restart|disable))\b/,
		description: "Command that stops services or restarts the system",
	},
	{
		name: "network-script-exec",
		pattern: /(curl|wget)\b[^;&|]*\|\s*(?:sudo\s+)?(?:sh|bash)\b/,
		description: "Command that directly executes a script fetched from the network",
	},
];

function findDangerousRules(command: string): DangerousRule[] {
	return dangerousRules.filter((rule) => rule.pattern.test(command));
}

async function confirmDangerousCommand(command: string, descriptions: string[], ctx: ExtensionContext) {
	const reasonText = descriptions.map((description) => `・${description}`).join("\n");
	const message = `The following command may be dangerous.\n\n${reasonText}\n\nCommand:\n${command}\n\nDo you want to allow it?`;

	if (!ctx.hasUI) {
		return false;
	}

	return ctx.ui.confirm("Dangerous Command Confirmation", message);
}

export default function (pi: ExtensionAPI) {
	pi.on("tool_call", async (event, ctx) => {
		if (event.toolName !== "bash") return undefined;

		const command = typeof event.input.command === "string" ? event.input.command : "";
		const matchedRules = findDangerousRules(command);
		if (matchedRules.length === 0) return undefined;

		const allowed = await confirmDangerousCommand(
			command,
			matchedRules.map((rule) => rule.description),
			ctx,
		);

		if (!allowed) {
			return { block: true, reason: "The user rejected execution of the dangerous command." };
		}

		return undefined;
	});
}
