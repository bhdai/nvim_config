local M = {}

--- Get highlight properties for a given highlight name
--- @param name string The highlight group name
--- @param fallback? table The fallback highlight properties
--- @return table properties # the highlight group properties
function M.get_hlgroup(name, fallback)
	if vim.fn.hlexists(name) == 1 then
		local group = vim.api.nvim_get_hl(0, { name = name })

		local hl = {
			fg = group.fg == nil and "NONE" or M.parse_hex(group.fg),
			bg = group.bg == nil and "NONE" or M.parse_hex(group.bg),
		}

		return hl
	end
	return fallback or {}
end

--- Remove a buffer by its number without affecting window layout
--- @param buf? number The buffer number to delete
function M.delete_buffer(buf)
	if buf == nil or buf == 0 then
		buf = vim.api.nvim_get_current_buf()
	end
	local win_id = vim.fn.bufwinid(buf)
	local alt_buf = vim.fn.bufnr("#")
	if alt_buf ~= buf and vim.fn.buflisted(buf) == 1 and alt_buf ~= -1 then
		vim.api.nvim_win_set_buf(win_id, alt_buf)
		vim.api.nvim_command("bwipeout " .. buf)
		return
	end

	---@diagnostic disable-next-line: param-type-mismatch
	local has_prev_buf = pcall(vim.cmd, "bprevious")
	if has_prev_buf and buf ~= vim.api.nvim_win_get_buf(win_id) then
		vim.api.nvim_command("bwipeout " .. buf)
		return
	end

	-- if alternate and previous buffers are both unavailable, create a new buffer instead
	local new_buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_win_set_buf(win_id, new_buf)
	vim.api.nvim_command("bwipeout " .. buf)
end

--- Switch to the previous buffer
function M.switch_to_previous_buffer()
	local ok, _ = pcall(function()
		vim.cmd("buffer #")
	end)
	if not ok then
		vim.notify("No other buffer to switch to!", 3, { title = "Warning" })
	end
end

--- Get the number of open buffers
--- @return number
function M.get_buffer_count()
	local count = 0
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if vim.fn.bufname(buf) ~= "" then
			count = count + 1
		end
	end
	return count
end

--- Parse a given integer color to a hex value.
--- @param int_color number
function M.parse_hex(int_color)
	return string.format("#%x", int_color)
end

--- Run a shell command and return the output
--- @param cmd table The command to run in the format { "command", "arg1", "arg2", ... }
--- @param cwd? string The current working directory
--- @return table stdout, number? return_code, table? stderr
function M.get_cmd_output(cmd, cwd)
	if type(cmd) ~= "table" then
		vim.notify("Command must be a table", 3, { title = "Error" })
		return {}
	end

	local command = table.remove(cmd, 1)
	local stderr = {}
	local stdout, ret = require("plenary.job")
		:new({
			command = command,
			args = cmd,
			cwd = cwd,
			on_stderr = function(_, data)
				table.insert(stderr, data)
			end,
		})
		:sync()

	return stdout, ret, stderr
end

--- Write a table of lines to a file
--- @param file string Path to the file
--- @param lines table Table of lines to write to the file
function M.write_to_file(file, lines)
	if not lines or #lines == 0 then
		return
	end
	local buf = io.open(file, "w")
	for _, line in ipairs(lines) do
		if buf ~= nil then
			buf:write(line .. "\n")
		end
	end

	if buf ~= nil then
		buf:close()
	end
end

--- Display a diff between the current buffer and a given file
--- @param file string The file to diff against the current buffer
function M.diff_file(file)
	local pos = vim.fn.getpos(".")
	local current_file = vim.fn.expand("%:p")
	vim.cmd("edit " .. file)
	vim.cmd("vert diffsplit " .. current_file)
	vim.fn.setpos(".", pos)
end

--- Display a diff between a file at a given commit and the current buffer
--- @param commit string The commit hash
--- @param file_path string The file path
function M.diff_file_from_history(commit, file_path)
	local extension = vim.fn.fnamemodify(file_path, ":e") == "" and "" or "." .. vim.fn.fnamemodify(file_path, ":e")
	local temp_file_path = os.tmpname() .. extension

	local cmd = { "git", "show", commit .. ":" .. file_path }
	local out = M.get_cmd_output(cmd)

	M.write_to_file(temp_file_path, out)
	M.diff_file(temp_file_path)
end

--- Open a telescope picker to select a file to diff against the current buffer
--- @param recent? boolean If true, open the recent files picker
function M.telescope_diff_file(recent)
	local picker = require("telescope.builtin").find_files
	if recent then
		picker = require("telescope.builtin").oldfiles
	end

	picker({
		prompt_title = "Select File to Compare",
		attach_mappings = function(prompt_bufnr)
			local actions = require("telescope.actions")
			local action_state = require("telescope.actions.state")

			actions.select_default:replace(function()
				actions.close(prompt_bufnr)
				local selection = action_state.get_selected_entry()
				M.diff_file(selection.value)
			end)
			return true
		end,
	})
end

--- Open a telescope picker to select a commit to diff against the current buffer
function M.telescope_diff_from_history()
	local current_file = vim.fn.fnamemodify(vim.fn.expand("%:p"), ":~:."):gsub("\\", "/")
	require("telescope.builtin").git_commits({
		git_command = { "git", "log", "--pretty=oneline", "--abbrev-commit", "--follow", "--", current_file },
		attach_mappings = function(prompt_bufnr)
			local actions = require("telescope.actions")
			local action_state = require("telescope.actions.state")

			actions.select_default:replace(function()
				actions.close(prompt_bufnr)
				local selection = action_state.get_selected_entry()
				M.diff_file_from_history(selection.value, current_file)
			end)
			return true
		end,
	})
end

--- Run current file inside toggleterm
function M.run_shell_script()
	local script = vim.fn.expand("%:p")
	require("toggleterm").exec(script)
end

function M.base64(data)
	data = tostring(data)
	local bit = require("bit")
	local b64chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
	local b64, len = "", #data
	local rshift, lshift, bor = bit.rshift, bit.lshift, bit.bor

	for i = 1, len, 3 do
		local a, b, c = data:byte(i, i + 2)
		b = b or 0
		c = c or 0

		local buffer = bor(lshift(a, 16), lshift(b, 8), c)
		for j = 0, 3 do
			local index = rshift(buffer, (3 - j) * 6) % 64
			b64 = b64 .. b64chars:sub(index + 1, index + 1)
		end
	end

	local padding = (3 - len % 3) % 3
	b64 = b64:sub(1, -1 - padding) .. ("="):rep(padding)

	return b64
end

function M.set_user_var(key, value)
	io.write(string.format("\027]1337;SetUserVar=%s=%s\a", key, M.base64(value)))
end

function M.wezterm()
	local nav = {
		h = "Left",
		j = "Down",
		k = "Up",
		l = "Right",
	}

	local function navigate(dir)
		return function()
			local win = vim.api.nvim_get_current_win()
			vim.cmd.wincmd(dir)
			local pane = vim.env.WEZTERM_PANE
			if vim.system and pane and win == vim.api.nvim_get_current_win() then
				local pane_dir = nav[dir]
				vim.system({ "wezterm", "cli", "activate-pane-direction", pane_dir }, { text = true }, function(p)
					if p.code ~= 0 then
						vim.notify(
							"Failed to move to pane " .. pane_dir .. "\n" .. p.stderr,
							vim.log.levels.ERROR,
							{ title = "Wezterm" }
						)
					end
				end)
			end
		end
	end

	M.set_user_var("IS_NVIM", true)

	-- Move to window using the movement keys
	for key, dir in pairs(nav) do
		vim.keymap.set("n", "<" .. dir .. ">", navigate(key), { desc = "Go to " .. dir .. " window" })
		vim.keymap.set("n", "<C-" .. key .. ">", navigate(key), { desc = "Go to " .. dir .. " window" })
	end

	vim.api.nvim_create_autocmd("VimLeave", {
		callback = function()
			M.set_user_var("IS_NVIM", "")
		end,
	})
end

function M.get_project_root()
	-- Possible root indicators
	local indicators = { ".git", "Makefile", "package.json", "Cargo.toml", "pyproject.toml" }

	local current_file = vim.fn.expand("%:p")
	local current_dir = vim.fn.fnamemodify(current_file, ":h")
	local root = current_dir

	-- Traverse up the directory tree
	while root ~= "/" do
		for _, indicator in ipairs(indicators) do
			if
				vim.fn.filereadable(root .. "/" .. indicator) == 1
				or vim.fn.isdirectory(root .. "/" .. indicator) == 1
			then
				return root
			end
		end
		root = vim.fn.fnamemodify(root, ":h")
	end

	-- If no root found, return the current working directory
	return vim.fn.getcwd()
end

function M.get_root()
	---@type string?
	local path = vim.api.nvim_buf_get_name(0)
	path = path ~= "" and vim.loop.fs_realpath(path) or nil
	---@type string[]
	local roots = {}
	if path then
		for _, client in pairs(vim.lsp.get_active_clients({ bufnr = 0 })) do
			local workspace = client.config.workspace_folders
			local paths = workspace
					and vim.tbl_map(function(ws)
						return vim.uri_to_fname(ws.uri)
					end, workspace)
				or client.config.root_dir and { client.config.root_dir }
				or {}
			for _, p in ipairs(paths) do
				local r = vim.loop.fs_realpath(p)
				if path:find(r, 1, true) then
					roots[#roots + 1] = r
				end
			end
		end
	end
	table.sort(roots, function(a, b)
		return #a > #b
	end)
	---@type string?
	local root = roots[1]
	if not root then
		path = path and vim.fs.dirname(path) or vim.loop.cwd()
		---@type string?
		root = vim.fs.find({ ".git", "lua" }, { path = path, upward = true })[1]
		root = root and vim.fs.dirname(root) or vim.loop.cwd()
	end
	---@cast root string
	return root
end

---@param opts? lsp.Client.filter
function M.get_clients(opts)
	local ret = {} ---@type vim.lsp.Client[]
	if vim.lsp.get_clients then
		ret = vim.lsp.get_clients(opts)
	else
		---@diagnostic disable-next-line: deprecated
		ret = vim.lsp.get_active_clients(opts)
		if opts and opts.method then
			---@param client vim.lsp.Client
			ret = vim.tbl_filter(function(client)
				return client.supports_method(opts.method, { bufnr = opts.bufnr })
			end, ret)
		end
	end
	return opts and opts.filter and vim.tbl_filter(opts.filter, ret) or ret
end

function M.colorize()
	vim.wo.number = false
	vim.wo.relativenumber = false
	vim.wo.statuscolumn = ""
	vim.wo.signcolumn = "no"
	vim.opt.listchars = { space = " " }

	local buf = vim.api.nvim_get_current_buf()

	local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
	while #lines > 0 and vim.trim(lines[#lines]) == "" do
		lines[#lines] = nil
	end
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, {})

	vim.b[buf].minianimate_disable = true

	vim.api.nvim_chan_send(vim.api.nvim_open_term(buf, {}), table.concat(lines, "\r\n"))
	vim.keymap.set("n", "q", "<cmd>qa!<cr>", { silent = true, buffer = buf })
	vim.api.nvim_create_autocmd("TextChanged", { buffer = buf, command = "normal! G$" })
	vim.api.nvim_create_autocmd("TermEnter", { buffer = buf, command = "stopinsert" })

	vim.defer_fn(function()
		vim.b[buf].minianimate_disable = false
	end, 2000)
end

return M
