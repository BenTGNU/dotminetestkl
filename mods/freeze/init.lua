-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
-- Copyright (c) 2014 PenguinDad
_ = {}

-- Load support for intllib.
local MP = minetest.get_modpath(minetest.get_current_modname())
local S, NS = dofile(MP.."/intllib.lua")

minetest.register_chatcommand("freeze", {
	params = "<name>",
	description = S("Freeze a player"),
	privs = {privs=true},
	func = function(name, param)
		local player = minetest.get_player_by_name(param)
		if player ~= nil and player:is_player() then
			player:set_physics_override(0, 0, 1.5)
			-- Revoke interact from player
--			_[param] = minetest.get_player_privs(param)
--			local c = function(p) return p end
--			local tmp = c(_[param])
--			tmp.interact = nil
--			minetest.set_player_privs(param, tmp)
--			minetest.auth_reload()
--			tmp = nil
			if minetest.settings:get_bool("enable_damage") then
				player:set_hp(1)
			end
			minetest.chat_send_all(S("@1 was frozen by @2.", param, name))
			minetest.log("action", S("@1 was frozen at @2", param, minetest.pos_to_string(vector.round(player:getpos()))))
		end
	end,
})

minetest.register_chatcommand("unfreeze", {
	params = "<name>",
	description = S("Unfreeze a player"),
	privs = {privs=true},
	func = function(name, param)
		local player = minetest.get_player_by_name(param)
		if player ~= nil and player:is_player() then
			if _[param] ~= nil then
				-- Regrant interact
--				minetest.set_player_privs(param, _[param])
--				_[param] = nil
--				minetest.auth_reload()
				player:set_physics_override(1, 1, 1)
				minetest.chat_send_player(param, S("You aren't frozen anymore."))
				minetest.log("action", param .. S("@1 was molten at @2",param, minetest.pos_to_string(vector.round(player:getpos()))))
			end
		end
	end,
})
