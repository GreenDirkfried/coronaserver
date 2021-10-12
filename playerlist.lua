coronaserver.playerlist = {}
controls.register_on_press(function(player, key)
	if key == "sneak" then
		local name = player:get_player_name()
		local list = {}
		local players = minetest.get_connected_players()
		for i, p in pairs(players) do
			local n = p:get_player_name()
			local info = minetest.get_player_information(n)
			if info and info.avg_rtt then
				local ping = math.max(1, math.ceil(4 - info.avg_rtt * 4))
				list[#list + 1] = player:hud_add({
					hud_elem_type = "text",
					position = {x = 1, y = 0},
					offset = {x = -50, y = 5 + (i - 1) * 18},
					text = n,
					alignment = {x = -1, y = 1},
					scale = {x = 100, y = 100},
					number = tonumber(coronaserver.get_rank(n).color:gsub("#", ""), 16),
				})
				list[#list + 1] = player:hud_add({
					hud_elem_type = "image",
					position = {x = 1, y = 0},
					offset = {x = -5, y = (i - 1) * 18},
					text = "server_ping_" .. ping .. ".png",
					alignment = {x = -1, y = 1},
					scale = {x = 1.5, y = 1.5},
					number = 0xFFFFFF,
				})
			end
		end
		coronaserver.playerlist[name] = list
	end
end)
controls.register_on_release(function(player, key)
	if key == "sneak" then
		for _, id in pairs(coronaserver.playerlist[player:get_player_name()]) do
			player:hud_remove(id)
		end
	end
end)
