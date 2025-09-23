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

function M.get_root(opts)
	opts = opts or {}
	-- define the order of detectors
	opts.detectors = opts.detectors or { "lsp", "pattern" }
	opts.patterns = opts.patterns or { ".git", "lua" }

	local path = vim.api.nvim_buf_get_name(0)
	path = path ~= "" and vim.loop.fs_realpath(path) or nil

	for _, detector in ipairs(opts.detectors) do
		if detector == "lsp" and path then
			local roots = {}
			for _, client in pairs(vim.lsp.get_clients({ bufnr = 0 })) do
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
			if #roots > 0 then
				table.sort(roots, function(a, b)
					return #a > #b
				end)
				return roots[1]
			end
		elseif detector == "pattern" then
			local search_path = path and vim.fs.dirname(path) or vim.loop.cwd()
			local found_marker = vim.fs.find(opts.patterns, { path = search_path, upward = true })[1]
			if found_marker then
				return vim.fs.dirname(found_marker)
			end
		elseif detector == "cwd" then
			return vim.loop.cwd()
		end
	end
	return nil
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

function M.cowboy()
	---@type table?
	local ok = true
	for _, key in ipairs({ "h", "j", "k", "l", "+", "-" }) do
		local count = 0
		local timer = assert(vim.uv.new_timer())
		local map = key
		vim.keymap.set("n", key, function()
			if vim.v.count > 0 then
				count = 0
			end
			if count >= 10 and vim.bo.buftype ~= "nofile" and vim.bo.filetype ~= "help" then
				ok = pcall(vim.notify, "Hold it Cowboy!", vim.log.levels.WARN, {
					icon = "🤠",
					id = "cowboy",
					keep = function()
						return count >= 10
					end,
				})
				if not ok then
					return map
				end
			else
				count = count + 1
				timer:start(2000, 0, function()
					count = 0
				end)
				return map
			end
		end, { expr = true, silent = true })
	end
end

return M
