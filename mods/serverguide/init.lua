-------------
-- OPTIONS --

-- Use text from files
local use_text_files = true
-- Should the script look for english file before using strings if file not found in user langage
local prefer_english_file_to_text = true
-- Add to inventory option
-- 	set to 'true' to add to new player inventory
--  set to 'false to not add
--	set to 'minetest.settings:get_bool("give_initial_stuff")' to make it depend on the give inital stuff option
local add_to_inventory = false
-------------

-- Load support for intllib.
local MP = minetest.get_modpath(minetest.get_current_modname())
local S, NS = dofile(MP.."/intllib.lua")

-- Server guide title
local serverguide_Book_title=S("The server guide")
-- Tabs title
local serverguide_Tab_1=S("Server")
local serverguide_Tab_2=S("Rules")
local serverguide_Tab_3=S("Rulers")
local serverguide_Tab_4=S("Commands")
local serverguide_Tab_5=S("Help")


serverguide_Tab_Text = {}
serverguide_Tab_Text[1]=S("Server info\n Type /guide to see this")
serverguide_Tab_Text[2]=S("Server Rules \nNo ask for privs or admin stuff \nNo swearing or bad names (like God, fuc...)\nNo griefing\nNo bad stealing or steal people's usernames\nNo hacking\nDon't mess up with moderators or admins")
serverguide_Tab_Text[3]=S("Rulers info (moderator or admins)")
serverguide_Tab_Text[4]=S("Commands:\nSet your home with /sethome say /home to teleport back \nSee who are online /status")
serverguide_Tab_Text[5]=S("Help info\nHelp you self\n Only call a moderator or admin if you\n get problems that you cant fix it by own")



-- look for text files to use text files if present
if use_text_files then 
	
	-- Text files folder
	local MOD_NAME = minetest.get_current_modname()
	-- Path to the text files
	-- Use minetest.get_worldpath() to use world specific messages
	local rep = minetest.get_worldpath(MOD_NAME)
	
	-- Define langage (code from intllib mod)
	local LANG = minetest.settings:get("language")
	if not (LANG and (LANG ~= "")) then LANG = os.getenv("LANG") end
	if not (LANG and (LANG ~= "")) then LANG = "en" end
	LANG = LANG:sub(1, 2)

	-- look for the files
	for i=1,5,1  do
	
		-- look in world rep
		local wrep = minetest.get_worldpath(MOD_NAME)
		local wpath = wrep.."/serverguide_tab_"..i.."_"..LANG..".txt"
		local file = io.open(wpath,"r")
		
		-- file not found
		-- look in mod rep
		if not file then 
			-- Define file to write
			local output = io.open(wpath,"w")
		
			-- look in locale rep
			local lrep = minetest.get_modpath(MOD_NAME)
			local lpath = lrep.."/serverguide_tab_"..i.."_"..LANG..".txt"
			local lfile = io.open(lpath,"r")

			local lpath = lrep.."/locale/"..LANG.."/serverguide_tab_"..i..".txt"
			local lfile = io.open(lpath,"r")
			-- locale not found look for english version
			if not lfile and prefer_english_file_to_text then 
				lpath = lrep.."/locale/en/serverguide_tab_"..i..".txt"
				lfile = io.open(lpath,"r")
			end
			
			-- Something was found write to world rep file
			if lfile then
				-- write file content to the one in worldpath
				local content = lfile:read("*all")
				output:write(content)
				io.close(output)
				io.close(lfile)
				-- Open file in world rep
				file = io.open(wpath,"r")
			end	
		end 			
	
		-- if input file exist
		if file then 
			lines = {}
			-- read the file
			for line in file:lines() do 
				lines[#lines + 1] = line
			end
			-- set tab content
			serverguide_Tab_Text[i] = table.concat(lines,"\n")
			io.close(file)
		end	
	end	
end



local function serverguide_guide(user,text_to_show)
local text=""
if text_to_show==1 then text=serverguide_Tab_Text[1] end
if text_to_show==2 then text=serverguide_Tab_Text[2] end
if text_to_show==3 then text=serverguide_Tab_Text[3] end
if text_to_show==4 then text=serverguide_Tab_Text[4] end
if text_to_show==5 then text=serverguide_Tab_Text[5] end

local form="size[8.5,9]" ..default.gui_bg..default.gui_bg_img..
	"button[0,0;1.5,1;tab1;" .. serverguide_Tab_1 .. "]" ..
	"button[1.5,0;1.5,1;tab2;" .. serverguide_Tab_2 .. "]" ..
	"button[3,0;1.5,1;tab3;" .. serverguide_Tab_3 .. "]" ..
	"button[4.5,0;1.5,1;tab4;" .. serverguide_Tab_4 .. "]" ..
	"button[6,0;1.5,1;tab5;" .. serverguide_Tab_5 .. "]" ..
	"button_exit[7.5,0; 1,1;tab6;X]" ..
	"textarea[0.3,1.1;8,7.5;;"..minetest.formspec_escape(text)..";]"
minetest.show_formspec(user:get_player_name(), "serverguide",form)
end

minetest.register_on_player_receive_fields(function(player, form, pressed)
	if form=="serverguide" then
	if pressed.tab1 then serverguide_guide(player,1) end
	if pressed.tab2 then serverguide_guide(player,2) end
	if pressed.tab3 then serverguide_guide(player,3) end
	if pressed.tab4 then serverguide_guide(player,4) end
	if pressed.tab5 then serverguide_guide(player,5) end
	end
end)


minetest.register_craftitem("serverguide:book", {
	description = serverguide_Book_title,
	inventory_image = "default_book.png^[colorize:#ffff00:100",
	-- Can be stored in bookshelves
	groups = {book=1},
	on_use = function(itemstack, user, pointed_thing)
	serverguide_guide(user,1)
	return itemstack
	end,
on_place = function(itemstack, placer, pointed_thing)
	local pos = pointed_thing.under
	local node = minetest.get_node_or_nil(pos)
	local def = node and minetest.registered_nodes[node.name]
	if not def or not def.buildable_to then
		pos = pointed_thing.above
		node = minetest.get_node_or_nil(pos)
		def = node and minetest.registered_nodes[node.name]
		if not def or not def.buildable_to then return itemstack end
	end
	if minetest.is_protected(pos, placer:get_player_name()) then return itemstack end
	local fdir = minetest.dir_to_facedir(placer:get_look_dir())
	minetest.set_node(pos, {name = "serverguide:guide",param2 = fdir,})
	itemstack:take_item()
	return itemstack
end
})
minetest.register_alias("guide", "serverguide:book")
minetest.register_craft({output = "serverguide:book",recipe = {{"default:stick","default:stick"},}})


minetest.register_node("serverguide:guide", {
	description = serverguide_Book_title,
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	is_ground_content = false,
	drop="serverguide:book",
	node_box = {
		type = "fixed",
		fixed = {0.35,-0.3,0.45,-0.35,-0.5,-0.45},
	},
	tiles = {
	"default_gold_block.png^default_book.png",
	"default_gold_block.png",
	"default_gold_block.png",
	"default_gold_block.png",
	"default_gold_block.png",
	"default_gold_block.png",},
	groups = {cracky=1,oddly_breakable_by_hand=3},
	sounds=default.node_sound_wood_defaults(),
on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("infotext", serverguide_Book_title)
end,
on_rightclick = function(pos, node, clicker)
	serverguide_guide(clicker,1)
end

})


minetest.register_on_newplayer(function(player) 
	if add_to_inventory then
		player:get_inventory():add_item("main", "serverguide:book")
	end
end)


minetest.register_chatcommand("guide", {
	params = "",
	description = serverguide_Book_title,
	func = function(name, param)
		serverguide_guide(minetest.get_player_by_name(name),1)
		return true
	end
})
