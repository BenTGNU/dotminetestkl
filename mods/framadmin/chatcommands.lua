local S = framadmin.intllib

local old_spawn = {x=-60, y=21, z=-119}
local mairie = {x=-66, y=29, z=-66}

players = {}

-- Commandes

minetest.register_chatcommand("quiz", {
	params = "[player_name]",
	description = S("Sends player to the quiz or yourself if run without arguments"),
	privs = {kick = true},
	func = function(player_name, param)
			local quiz_point = minetest.settings:get("spawnpoint_no_interact")
		if #param == 0 then
			local player = minetest.get_player_by_name(player_name)
			player:setpos(minetest.string_to_pos(quiz_point))

		elseif players[player_name] and param and players[param] then
			local player = minetest.get_player_by_name(param)
			player:setpos(minetest.string_to_pos(quiz_point))
			minetest.chat_send_player(player_name, S("Teleporting %s to quiz"):format(param))
		else
			minetest.chat_send_player(player_name, S("Player %s could not be found"):format(param))
		end
		return
	end
})

minetest.register_chatcommand("who", {
	description = S("List players on the server"),
	params = "",
	privs = {},
	func = function(name, param)
		local playerstring = ""
		for i, player in ipairs(minetest.get_connected_players()) do
			local name = player:get_player_name()
			local lname = ""
			lname = name
			if i < #minetest.get_connected_players() then
				playerstring = playerstring..lname..", "
			else
				playerstring = playerstring..lname
			end
		end
		minetest.chat_send_player(name, playerstring)
	end
})

minetest.register_chatcommand(S("townhall"), {
	description = S("Sends you to the townhall"),
	privs = {interact = true},
	func = function(name)
		local player = minetest.get_player_by_name(name)
		player:setpos(mairie)
	end
})

minetest.register_chatcommand(S("town"), {
	description = S("Sends you to the town"),
	privs = {interact = true},
	func = function(name)
		local player = minetest.get_player_by_name(name)
		player:setpos(old_spawn)
	end
})

--register command aliases:
--introduce some short names for commands you use often
framadmin_rca=function(name, from)
   if minetest.chatcommands[from] then
      minetest.register_chatcommand(name, minetest.chatcommands[from])
   end
end
minetest.after(0,function()
framadmin_rca("tp", "teleport")
framadmin_rca("?", "whatisthis")
framadmin_rca("check", "rollback_check")
end)
