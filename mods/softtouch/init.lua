softtouch = {}

-- Intllib
-- Load support for intllib.
local MP = minetest.get_modpath(minetest.get_current_modname())
local S, NS = dofile(MP.."/intllib.lua")

softtouch.intllib = S

minetest.register_tool("softtouch:feather", {
	description = S("softtouch feather (for easy punch activation in creative)"),
	inventory_image = "softtouch_feather.png",
	tool_capabilities = {
		full_punch_interval = 3.2,
		max_drop_level=0,
		groupcaps={
			cracky = {times={[1]=3.00, [2]=3.00, [3]=3.00}, uses=10, maxlevel=3},
			crumbly = {times={[1]=3.00, [2]=3.00, [3]=3.00}, uses=10, maxlevel=3},
			choppy = {times={[1]=3.00, [2]=3.00, [3]=3.00}, uses=10, maxlevel=3},
			snappy = {times={[1]=3.00, [2]=3.00, [3]=3.00}, uses=10, maxlevel=3},
			oddly_breakable_by_hand = {times={[1]=3.00, [2]=3.00, [3]=3.00}, uses=10, maxlevel=3},
		},
	},
})