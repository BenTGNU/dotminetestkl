-- intllib support
local S
if (minetest.get_modpath("intllib")) then
	S = intllib.Getter()
else
  S = function ( s ) return s end
end

minetest.register_node("supplemental:sticky", {
	description = S("sticky stone brick"),
	tiles = {"default_stone_brick.png^supplemental_splat.png",
		"default_stone_brick.png", "default_stone_brick.png", "default_stone_brick.png",
		"default_stone_brick.png", "default_stone_brick.png"},
	groups = {creative_breakable=1, disable_jump=1},
	sounds = default.node_sound_stone_defaults()
})

minetest.register_node("supplemental:bouncy", {
	description = S("bouncy block"),
	tiles = {"supplemental_bouncy.png"},
	groups = {creative_breakable=1, bouncy=70, fall_damage_add_percent=-100},
	sounds = default.node_sound_stone_defaults()
})



minetest.register_node("supplemental:conglomerate", {
	description = S("conglomerate"),
	tiles = {"supplemental_conglomerate.png" },
	groups = {cracky=3},
	drop = { items = {
			{ items={"supplemental:rock"} },
			{ items={"supplemental:rock"}, rarity = 5 },
			{ items={"supplemental:rock"}, rarity = 5 },
			{ items={"supplemental:rock"}, rarity = 5 },
			{ items={"supplemental:rock"}, rarity = 5 },
		}
	},
	sounds = default.node_sound_stone_defaults()
})

minetest.register_node("supplemental:frame",{
	description = S("picture frame"),
	drawtype = "signlike",
	selection_box = { type = "wallmounted" },
	walkable = false,
	tiles = {"supplemental_frame.png"},
	inventory_image = "supplemental_frame.png",
	wield_image = "supplemental_frame.png",
	paramtype = "light",
	paramtype2 = "wallmounted",
	sunlight_propagates = true,
	groups = { creative_breakable=1, attached_node=1 },
	legacy_wallmounted = true,
	sounds = default.node_sound_defaults(),
})

minetest.register_node("supplemental:spikes", {
	description = S("short spikes"),
	tiles = {"supplemental_spikes_small.png"},
	inventory_image = "supplemental_spikes_small.png",
	wield_image = "supplemental_spikes_small.png",
	sunlight_propagates = true,
	paramtype = "light",
	walkable = false,
	drawtype = "plantlike",
	groups = { creative_breakable = 1 },
	damage_per_second = 1,
	collision_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.5, 0.5, 0.1, 0.5}
	},
	selection_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.5, 0.5, 0.1, 0.5}
	}
})

minetest.register_node("supplemental:spikes_large", {
	description = S("long spikes"),
	tiles = {"supplemental_spikes_large.png"},
	inventory_image = "supplemental_spikes_large.png",
	wield_image = "supplemental_spikes_large.png",
	sunlight_propagates = true,
	paramtype = "light",
	walkable = false,
	drawtype = "plantlike",
	groups = { creative_breakable = 1 },
	damage_per_second = 2
})

-- TODO: Remove the loudspeaker node when there is a more user-friendly means
-- to control the music.
local set_loudspeaker_infotext = function(pos)
	local meta = minetest.get_meta(pos)
	meta:set_string("infotext", S("loudspeaker (rightclick to toggle music)"))
end

minetest.register_node("supplemental:loudspeaker", {
	description = S("loudspeaker"),
	tiles = {"supplemental_loudspeaker.png"},
	groups = { creative_breakable = 1 },
	sounds = default.node_sound_wood_defaults(),
	on_construct = set_loudspeaker_infotext,
	on_rightclick = function(pos, node, clicker)
		if mpd.playing then
			mpd.stop_song()
			clicker:set_attribute("play_music", "0")
		else
			mpd.next_song()
			clicker:set_attribute("play_music", "1")
		end
	end,

})

minetest.register_abm({
	nodenames = { "supplemental:loudspeaker" },
	interval = 5,
	chance = 1,
	action = set_loudspeaker_infotext,
})

minetest.register_craftitem("supplemental:rock", {
	description = S("piece of rock"),
	inventory_image = "supplemental_rock.png",
})

minetest.register_craftitem("supplemental:wheat", {
	description = S("wheat"),
	inventory_image = "supplemental_wheat.png",
})

minetest.register_craftitem("supplemental:flour", {
	description = S("flour"),
	inventory_image = "supplemental_flour.png",
})
-- Crafting example #2
minetest.register_craft({
	type = "shapeless",
	output = "supplemental:flour",
	recipe = {"supplemental:wheat", "supplemental:wheat", "supplemental:wheat", "supplemental:wheat"}
})

-- Items for crafting examples #1, #4 and #5
minetest.register_craftitem("supplemental:paper_white", {
	description = S("white sheet of paper"),
	inventory_image = "default_paper.png",
	groups = { paper = 1 },
})
minetest.register_craftitem("supplemental:paper_orange", {
	description = S("orange sheet of paper"),
	inventory_image = "supplemental_paper_orange.png",
	groups = { paper = 1 },
})
minetest.register_craftitem("supplemental:paper_purple", {
	description = S("purple sheet of paper"),
	inventory_image = "supplemental_paper_purple.png",
	groups = { paper = 1 },
})
minetest.register_craftitem("supplemental:paper_green", {
	description = S("green sheet of paper"),
	inventory_image = "supplemental_paper_green.png",
	groups = { paper = 1 },
})
-- Crafting example #4
minetest.register_craft({
	output = "default:book",
	recipe = {
		{"group:paper"},
		{"group:paper"},
		{"group:paper"}
	}
})


-- 8 viscosity example liquids
for v=0,7 do
	local alpha = 120 + v*15

	minetest.register_node("supplemental:liquid"..v, {
		description = string.format(S("flowing test liquid %i"), v),
		inventory_image = minetest.inventorycube("supplemental_testliquid"..v..".png"),
		drawtype = "flowingliquid",
		tiles = {"supplemental_testliquid"..v..".png"},
		special_tiles = {
			{
				name="supplemental_testliquid"..v..".png",
				backface_culling=false,
			},
			{
				name="supplemental_testliquid"..v..".png",
				backface_culling=true,
			},

		},
		alpha = alpha,
		paramtype = "light",
		paramtype2 = "flowingliquid",
		walkable = false,
		pointable = false,
		diggable = false,
		buildable_to = true,
		drop = "",
		drowning = 1,
		liquidtype = "flowing",
		liquid_alternative_flowing = "supplemental:liquid"..v,
		liquid_alternative_source = "supplemental:liquidsource"..v,
		liquid_viscosity = v,
		groups = {not_in_creative_inventory = 1},
		sounds = default.node_sound_water_defaults(),
	})

	minetest.register_node("supplemental:liquidsource"..v, {
		description = string.format(S("test liquid source %i"), v),
		inventory_image = minetest.inventorycube("supplemental_testliquid"..v..".png"),
		drawtype = "liquid",
		special_tiles = {
			{
				name="supplemental_testliquid"..v..".png",
				backface_culling=false,
			},
		},
		tiles = {"supplemental_testliquid"..v..".png",},
		alpha = alpha,
		paramtype = "light",
		walkable = false,
		pointable = false,
		diggable = false,
		buildable_to = true,
		drop = "",
		drowning = 1,
		liquidtype = "source",
		liquid_alternative_flowing = "supplemental:liquid"..v,
		liquid_alternative_source = "supplemental:liquidsource"..v,
		liquid_viscosity = v,
		groups = {},
		sounds = default.node_sound_water_defaults(),
	})
end
