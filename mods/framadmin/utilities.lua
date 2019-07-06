local S = framadmin.intllib

--- UNKNOW BLOCKS CLEANER ---
----------------------------

local old_nodes = {
"farming_plus:banana_leaves",
"farming_plus:banana_sapling",
"farming_plus:banana",
"farming_plus:carrot_1",
"farming_plus:carrot_2",
"farming_plus:carrot_3",
"farming_plus:carrot",
"farming_plus:cocoa_leaves",
"farming_plus:cocoa",
"farming_plus:orange",
"farming_plus:orange_1",
"farming_plus:orange_2",
"farming_plus:orange_3",
"farming_plus:potato",
"farming_plus:potato_1",
"farming_plus:potato_2",
"farming:big_pumpkin",
"farming:pumpkin",
"farming:pumpkin_1",
"farming:pumpkin_2",
"farming:pumpkin_face",
"farming:pumpkin_face_light",
"farming:scarecrow",
"farming:scarecrow_bottom",
"farming:scarecrow_light",
"farming_plus:rhubarb",
"farming_plus:rhubarb_1",
"farming_plus:rhubarb_2",
"farming_plus:strawberry",
"farming_plus:strawberry_1",
"farming_plus:strawberry_2",
"farming_plus:strawberry_3",
"farming_plus:tomato",
"farming_plus:tomato_1",
"farming_plus:tomato_2",
"farming_plus:tomato_3",
"farming:weed",
"rubber:rubber_leaves",
"rubber:rubber_tree_full",
"farming_plus:cocoa_sapling",
"torches:floor",
"torches:wall",
 }

local old_entities = {}

for _,node_name in ipairs(old_nodes) do
    minetest.register_node(":"..node_name, {
        groups = {old=1},
    })
end

minetest.register_abm({
    nodenames = {"group:old"},
    interval = 1,
    chance = 1,
    action = function(pos, node)
        minetest.env:remove_node(pos)
    end,
})

for _,entity_name in ipairs(old_entities) do
    minetest.register_entity(":"..entity_name, {
        on_activate = function(self, staticdata)
            self.object:remove()
        end,
    })
end


--- CHATLOG ---
---------------

-- Helper function for loading optional values
local function getValid(value, default)
    local v = minetest.settings:get(value)
    return (v == nil and default or v)
end

-- Default values
local defaultFile = 'chatlog.%Y-%m-%d.log'
local defaultDate = '%X'
local defaultLine = '[%date%] <%name%> %message%\n'

-- Read values from minetest.conf or set default values
chatlogFilename = getValid('chatlog_logfile_name', defaultFile)
chatlogDateString = getValid('chatlog_date_string', defaultDate)
chatlogLineFormat = getValid('chatlog_line_format', defaultLine)

function chatlogWriteLine(name, message)
    local logfileName = os.date(chatlogFilename)
    local line = chatlogLineFormat
    line = line:gsub('%%date%%', os.date(chatlogDateString))
    line = line:gsub('%%name%%', name)
    line = line:gsub('%%message%%', message)
    local f = io.open(minetest.get_worldpath()..'/chatlog/'..logfileName, 'a')
    f:write(line)
    f:close()
end

minetest.register_on_chat_message(chatlogWriteLine)

--- LAVA AND CART RESTRICTIONS ---
----------------------------------

minetest.register_privilege("lava", S("Can use lava."))

minetest.register_privilege("carts", S("Can use carts."))
minetest.register_privilege("railroad", S("Can use carts everywhere."))

-- Lava
local old_lava_bucket_place = minetest.registered_items["bucket:bucket_lava"].on_place

minetest.override_item("bucket:bucket_lava", {
	on_place = function(itemstack, placer, pointed_thing)
		if not minetest.check_player_privs(placer:get_player_name(),
				{lava = true}) then
			return itemstack
		else
			return old_lava_bucket_place(itemstack, placer, pointed_thing)
		end
	end,
})

minetest.override_item("default:lava_source", {
	after_place_node = function(pos, placer, itemstack, pointed_thing)
		if not minetest.check_player_privs(placer:get_player_name(),
				{lava = true}) then
			minetest.remove_node(pos)
		end
	end,
})

-- Carts
minetest.override_item("carts:rail", {
	after_place_node = function(pos, placer, itemstack, pointed_thing)
		if not minetest.check_player_privs(placer:get_player_name(), {railroad = true}) then
			if not minetest.check_player_privs(placer:get_player_name(), {carts = true}) then
				minetest.remove_node(pos)
			end
		end
	end,
})

minetest.override_item("carts:brakerail", {
	after_place_node = function(pos, placer, itemstack, pointed_thing)
		if not minetest.check_player_privs(placer:get_player_name(), {railroad = true}) then
			if not minetest.check_player_privs(placer:get_player_name(), {carts = true}) then
				minetest.remove_node(pos)
			end
		end
	end,
})

minetest.override_item("carts:powerrail", {
	after_place_node = function(pos, placer, itemstack, pointed_thing)
		if not minetest.check_player_privs(placer:get_player_name(), {railroad = true}) then
			if not minetest.check_player_privs(placer:get_player_name(), {carts = true}) then
				minetest.remove_node(pos)
			end
		end
	end,
})
