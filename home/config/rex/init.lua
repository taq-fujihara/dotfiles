local leader_key = "ctrl+f"

local function leader(key, action, args)
	rex.bind(leader_key .. ">" .. key, action, args)
end

leader(leader_key, "pane.send_key", { key = leader_key })

leader("p", "client.palette.toggle")
rex.bind("ctrl+shift+p", "client.palette.toggle")

rex.bind("ctrl+shift+c", "pane.copy")
rex.bind("ctrl+shift+v", "pane.paste")

rex.bind("shift+enter", "accept_autocomplete_and_execute")

rex.bind("shift+space", "pane.send_key", { key = "f20" })

-- Sessions

leader("w", "session.switch")
leader("shift+w", "session.new")

-- Tabs

leader("n", "client.tab.new")

rex.bind("ctrl+shift+,", "client.tab.previous")
rex.bind("ctrl+shift+.", "client.tab.next")

leader("shift+h", "client.tab.move.backward")
leader("shift+l", "client.tab.move.forward")

leader("t", "client.tab.rename")

-- leader("h", "client.tab.previous")
-- leader("l", "client.tab.next")

-- Panes

rex.bind("ctrl+shift+h", "pane.focus", { direction = "left" })
rex.bind("ctrl+shift+j", "pane.focus", { direction = "down" })
rex.bind("ctrl+shift+k", "pane.focus", { direction = "up" })
rex.bind("ctrl+shift+l", "pane.focus", { direction = "right" })

rex.bind("ctrl+down", "pane.resize", { direction = "down", amount = 3 })
rex.bind("ctrl+up", "pane.resize", { direction = "up", amount = 3 })
rex.bind("ctrl+left", "pane.resize", { direction = "left", amount = 5 })
rex.bind("ctrl+right", "pane.resize", { direction = "right", amount = 5 })

leader("=", "pane.balance")
leader("z", "pane.zoom")

leader("shift+\\", "pane.split", { direction = "right" })
leader("-", "pane.split", { direction = "down" })

--

rex.action({
	name = "accept_autocomplete_and_execute",
	title = "Accept Autocomplete and Execute",
	run = function()
		rex.client.queue("pane.send_key", { key = "right" })
		rex.client.queue("pane.send_key", { key = "enter" })
	end,
})

local function panes(ctx)
	local view = checked(rex.session.view({}))
	for _, window in ipairs(view.windows or {}) do
		for _, layer in ipairs(window.layers or {}) do
			for _, block in ipairs(layer.blocks or {}) do
				if block.block_id == ctx.block_id then
					return layer.blocks
				end
			end
		end
	end
	error("Focused pane not found", 0)
end

rex.action({
	name = "rotate_panes",
	title = "Rotate Panes in Layout Order",
	run = function(ctx)
		local blocks = panes(ctx)
		for i = 2, #blocks do
			checked(rex.session.swap_blocks({
				block_id = blocks[1].block_id,
				other_block_id = blocks[i].block_id,
			}))
		end
	end,
})
leader("r", "rotate_panes")

-- rex.action({
-- 	name = "swap_pane_by_index",
-- 	title = "Swap Pane by Layout Index",
-- 	args = { index = "integer" },
-- 	run = function(ctx, args)
-- 		local target = panes(ctx)[args.index]
-- 		if not target then
-- 			error("No pane at this index", 0)
-- 		end
-- 		if target.block_id == ctx.block_id then
-- 			return
-- 		end
--
-- 		checked(rex.session.swap_blocks({
-- 			block_id = ctx.block_id,
-- 			other_block_id = target.block_id,
-- 		}))
-- 	end,
-- })
-- rex.mode("swap", { exclusive = true })
-- leader("shift+s", "client.mode.enter", { name = "swap", once = true })
-- for i = 1, 9 do
-- 	rex.bind("swap/" .. i, "swap_pane_by_index", { index = i })
-- end

local function checked(result, err)
	if err then
		error(err, 0)
	end
	return result
end
