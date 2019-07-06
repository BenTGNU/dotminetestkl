framadmin = {}

-- Load support for intllib.
local MP = minetest.get_modpath(minetest.get_current_modname())
local S, NS = dofile(MP.."/intllib.lua")

framadmin.intllib = S

dofile(minetest.get_modpath("framadmin").."/chatcommands.lua")
dofile(minetest.get_modpath("framadmin").."/nodes.lua")
dofile(minetest.get_modpath("framadmin").."/crafts.lua")
dofile(minetest.get_modpath("framadmin").."/utilities.lua")
