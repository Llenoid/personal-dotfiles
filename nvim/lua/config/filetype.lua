vim.filetype.add({
	pattern = {
		-- Matches docker-compose.yml, docker-compose.prod.yaml, etc.
		["docker%-compose.*%.ya?ml"] = "yaml.docker-compose",
		-- Matches compose.yml, compose.staging.yaml, etc.
		["compose.*%.ya?ml"] = "yaml.docker-compose",
	},
})
