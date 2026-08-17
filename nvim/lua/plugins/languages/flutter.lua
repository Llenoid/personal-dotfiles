return {
	"nvim-flutter/flutter-tools.nvim",
	ft = { "dart" },
	cmd = {
		"FlutterRun",
		"FlutterDevices",
		"FlutterEmulators",
		"FlutterReload",
		"FlutterRestart",
	},
	dependencies = {
		"nvim-lua/plenary.nvim",
		"stevearc/dressing.nvim",
	},
	opts = {},
}
