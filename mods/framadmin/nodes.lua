local S = framadmin.intllib

-- Blocs

minetest.register_node("framadmin:info", {
	description = S("Info block"),
	tiles = {"info_top_bot.png","info_top_bot.png","info.png","info.png","info.png","info.png"},
	drawtype = "normal",
	paramtype = "light",
	paramtype2 = "facedir",
	legacy_wallmounted = true,
	walkable = true,
	sunlight_propagates = true,
	inventory_image = minetest.inventorycube("info.png"),
--	wield_image = "info.png",
	light_source = 5,
	groups = {snappy = 3,not_in_creative_inventory = 1},
	on_construct = function(pos, placer)
		local meta = minetest.get_meta(pos)
		meta:set_string("formspec", "field[text;"..S("Enter zone name")..";${text}]")
		meta:set_string("infotext", S("Right-click to define zone name"))
		meta:set_string("text", S("My zone"))

	end,
	on_receive_fields = function(pos, formname, fields, player)
		local meta = minetest.get_meta(pos)
		if fields.text == nil or fields.text == "" then
		return false
		else
		meta:set_string("text", fields.text)
		meta:set_string("infotext", S("Welcome to %s zone !"):format(fields.text))
		end
	end,
})
