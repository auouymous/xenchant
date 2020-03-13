xenchant = {}
local MP = minetest.get_modpath("xenchant").."/"
--collectgarbage("collect") ; local _memory_usage_ = collectgarbage("count")*1024 ; local _start_time_ = os.clock()  

local abs, ceil, floor, random = math.abs, math.ceil, math.floor, math.random
local string_sub, string_upper = string.sub, string.upper
local table_concat, table_copy, table_insert = table.concat, table.copy, table.insert
local reg_tools = minetest.registered_tools

xenchant.enable_mese_fragments = not minetest.settings:get_bool("xenchant_no_mese_fragments")
xenchant.enable_discounted_enchants = not minetest.settings:get_bool("xenchant_no_discounted_enchants")
xenchant.enable_random_enchants = minetest.settings:get_bool("xenchant_random_enchants")
xenchant.enable_random_ascii = minetest.settings:get_bool("xenchant_random_ascii") -- use ascii
xenchant.bookshelves_per_level = tonumber(minetest.settings:get("xenchant_bookshelves_per_level")) or 8
if xenchant.bookshelves_per_level <= 0 then xenchant.bookshelves_per_level = 1 end



-- enchantments

xenchant.enchants = {}
xenchant.help = {}
xenchant.action = {}

function xenchant.register_enchant(key, name, help, multiplier, offset, action, level, cost)
	xenchant.enchants[key] = {
		name = name,
		help = help,
		offset = offset,
		multiplier = multiplier,
		action = action,
		level = level,
		cost = cost,
	}
end

function xenchant.to_percent(orig_value, final_value)
	return "+" .. abs(ceil(((final_value - orig_value) / orig_value) * 100)) .. "%"
end

function xenchant.colorize(color, enchantment, value)
	return minetest.colorize and minetest.colorize(color,
			"\n" .. enchantment .. " ("..value..")") or
			"\n" .. enchantment .. " ("..value..")"
end

local armor_parts = { "armor_head", "armor_torso", "armor_legs", "armor_feet", "armor_shield" }

function xenchant.get_armor_part(groups)
	for _,v in ipairs(armor_parts) do
		if groups[v] ~= nil then return v end
	end
	return nil
end

dofile(MP.."enchants.lua")
dofile(MP.."config.lua")



-- material cost determines allowed enchantment level: 0=<1.0, 1=<2.0, 2=<3.0, ...

local materials = {}

function xenchant.register_material(name, cost)
	materials[name] = cost
end



-- allowed tools
-- tools[name][0] = material cost
-- tools[name] = list of enchants

local tools = {}
local nr_tools = 0
local nr_armors = 0

local function cap(S) return
	S:gsub("^%l", string_upper)
end

function xenchant.register_tools(mod, def)
	for tool in pairs(def.tools) do
		local mod_tool, cap_tool = mod .. "_" .. tool, cap(tool)

		for material in def.materials:gmatch("[%w_]+") do
			local _material, cap_material = "", ""
			if tonumber(material) then
				material = tonumber(material)
			else
				_material = "_" .. material
				cap_material = cap(material)
			end
			local enchanted_description = "Enchanted " .. cap_material .. " " .. cap_tool .. " "
			local toolname = mod .. ":" .. tool .. _material
			local original_tool = reg_tools[toolname]

			if original_tool then
				-- else no such tool
				local original_toolcaps = original_tool.tool_capabilities
				local enchants = def.tools[tool].enchants

				local mod_tool_material
				if _material ~= "" then
					tools[toolname] = { [0] = materials[material] }
					mod_tool_material = mod_tool .. _material
				else
					tools[toolname] = { [0] = material }
					mod_tool_material = mod_tool
				end
				local material_level = floor(tools[toolname][0])

				for enchant in enchants:gmatch("[%w_]+") do
					local e = xenchant.enchants[enchant]
					if e ~= nil and e.level <= material_level then
						-- else no such enchant or tool material doesn't support this enchant

						table_insert(tools[toolname], enchant)

						if original_toolcaps then
							local original_groupcaps = original_toolcaps.groupcaps
							local groupcaps = table_copy(original_groupcaps)
							local caps = {
								fleshy = original_toolcaps.damage_groups.fleshy,
								original_groupcaps = original_groupcaps,
								groupcaps = groupcaps,
								group = next(original_groupcaps),
							}

							local tooltip = e.action(e, caps)

							minetest.register_tool("xenchant:" .. mod_tool_material .. "_" .. enchant, {
								description = enchanted_description .. tooltip,
								inventory_image = original_tool.inventory_image .. "^[colorize:violet:50",
								wield_image = original_tool.wield_image,
								groups = {not_in_creative_inventory = 1},
								tool_capabilities = {
									groupcaps = groupcaps, damage_groups = {fleshy = caps.fleshy},
									full_punch_interval = original_toolcaps.full_punch_interval,
									max_drop_level = original_toolcaps.max_drop_level
								},
							})

							nr_tools = nr_tools + 1
						elseif original_tool.groups and original_tool.groups.armor_use then
							if original_tool.armor_groups ~= nil then
								local caps = {
									groups = table_copy(original_tool.groups),
									damage_groups = table_copy(original_tool.damage_groups),
									armor_groups = table_copy(original_tool.armor_groups),
								}
								caps.groups.not_in_creative_inventory = 1

								local e = xenchant.enchants[enchant]
								local tooltip = e.action(e, caps)

								armor:register_armor("xenchant:" .. mod_tool_material .. "_" .. enchant, {
									description = enchanted_description .. tooltip,
									inventory_image = original_tool.inventory_image .. "^[colorize:violet:50",
									texture = mod_tool_material .. ".png",
									preview = mod_tool_material .. "_preview.png",
									groups = caps.groups,
									armor_groups = caps.armor_groups,
									damage_groups = caps.damage_groups,
								})
							else
								local caps = {
									groups = table_copy(original_tool.groups),
								}
								caps.groups.not_in_creative_inventory = 1

								local e = xenchant.enchants[enchant]
								local tooltip = e.action(e, caps)

								armor:register_armor("xenchant:" .. mod_tool_material .. "_" .. enchant, {
									description = enchanted_description .. tooltip,
									inventory_image = original_tool.inventory_image .. "^[colorize:violet:50",
									texture = mod_tool_material .. ".png",
									preview = mod_tool_material .. "_preview.png",
									groups = caps.groups,
								})
							end

							nr_armors = nr_armors + 1
						else
							print("[XEnchant] Invalid tool: " .. mod .. ":" .. tool .. _material)
							print(dump(original_tool))
						end
					end
				end
			end
		end
	end
end

dofile(MP.."register.lua")



-- node

local enchant_buttons = {
	"3.9,0.85;4,0.92;bg_btn.png;",
	"3.9,1.77;4,1.12;bg_btn.png;",
	"3.9,2.9;4,0.92;bg_btn.png;",
}

function xenchant.formspec(pos, buttons)
	local meta = minetest.get_meta(pos)
	local formspec = [[ size[9,9;]
			bgcolor[#080808BB;true]
			background[0,0;9,9;ench_ui.png]
			list[context;tool;0.9,2.9;1,1;]
			list[context;mese;2,2.9;1,1;]
			list[current_player;main;0.5,4.5;8,4;]
			listring[current_player;main]
			listring[context;tool]
			listring[current_player;main]
			listring[context;mese]
			image[2,2.9;1,1;mese_layout.png]
			]] ..
			default.gui_slots .. default.get_hotbar_bg(0.5,4.5)

	formspec = formspec .. (buttons or "")
	meta:set_string("formspec", formspec)
end

local random_chars
if xenchant.enable_random_enchants then
	if xenchant.enable_random_ascii then
		-- ascii characters
		random_chars = " abcdefgh ijklmnopq rstuvwxyz ABCDEFGH IJKLMNOPQ RSTUVWXYZ ~`!@#$%^ &*-_=+\\| :',./<>? "
	else
		-- three byte utf-8 symbols
		random_chars = " - ─│┌┐└┘├┤┬┴┼ - ═║╒╓╔╕╖╗╘╙ - ╚╛╜╝╞╟╠╡╢╣ - ╤╥╦╧╨╩╪╫╬ - "
	end
end

function xenchant.get_mese_cost(enchant_cost, material_cost)
	local cost = enchant_cost * material_cost
	if cost <= 0.9 and xenchant.enable_mese_fragments then
		return { cost = ceil(cost * 10),	name = "mese fragment",	item = "default:mese_crystal_fragment" }
	else
		return { cost = ceil(cost),			name = "mese",			item = "default:mese_crystal" }
	end
end

function xenchant.on_put(pos, listname, _, stack)
	if listname == "tool" then
		local stackname = stack:get_name()
		local material_cost = tools[stackname][0]

		-- randomize enchants
		local random_enchants = {}
		for _,v in ipairs(tools[stackname]) do
			local pos = random(1, #random_enchants+1)
			table_insert(random_enchants, pos, v)
		end
		-- get top three enchants
		local buttons = ""
		local i = 1
		local r
		if xenchant.enable_random_enchants then
			r = {"","","","","","","","","","","","","","",""}
		end
		local meta = minetest.get_meta(pos)
		local books = meta:get_int("books")
		for _,v in ipairs(random_enchants) do
			local e = xenchant.enchants[v]
			if (e.level * xenchant.bookshelves_per_level) <= books then
				local mc = xenchant.get_mese_cost(e.cost, material_cost)
				local e_name, e_help = e.name, e.help
				if xenchant.enable_random_enchants then
					if xenchant.enable_random_ascii then
						for i = 1,15 do
							local ii = random(1, #random_chars)
							r[i] = string_sub(random_chars, ii, ii)
						end
					else
						for i = 1,15 do
							local ii = 1 + 3 * random(0, #random_chars/3-1)
							r[i] = string_sub(random_chars, ii, ii+2)
						end
					end
					e_name = table_concat(r)
					e_help = e_name
				end
				buttons = buttons .. "image_button[" .. enchant_buttons[i] .. v .. ";" .. e_name .. "]tooltip[".. v .. ";" .. e_help .. " (" .. mc.cost .. " " .. mc.name .. ")]"
				if i == 3 then break else i = i + 1 end
			end
		end

		xenchant.formspec(pos, buttons)
	end
end

function xenchant.fields(pos, _, fields, sender)
	if not next(fields) or fields.quit then return end
	local inv = minetest.get_meta(pos):get_inventory()
	local tool = inv:get_stack("tool", 1)
	local mese = inv:get_stack("mese", 1)
	local orig_wear = tool:get_wear()
	local enchant = next(fields)

	local enchanted_tool = "xenchant:" .. tool:get_name():gsub(":", "_", 1) .. "_" .. enchant

	if reg_tools[enchanted_tool] then
		local e = xenchant.enchants[enchant]
		local material_cost = tools[tool:get_name()][0]
		if e.level <= floor(material_cost) then
			local mc = xenchant.get_mese_cost(e.cost, material_cost)

			if mese:get_count() >= mc.cost and mese:get_name() == mc.item then
				minetest.sound_play("xdecor_enchanting", {
					to_player = sender:get_player_name(),
					gain = 0.8
				})

				-- materials less than 0.09486 are always free
				if xenchant.enable_discounted_enchants and random(1, ceil(material_cost * material_cost * 1000)) < 10 then
					mc.cost = mc.cost - 1
					minetest.chat_send_player(sender:get_player_name(), "Enchantment discounted by 1 " .. mc.name .. "!")
				end

				tool:replace(enchanted_tool)
				tool:add_wear(orig_wear)
				if mc.cost > 0 then
					mese:take_item(mc.cost)
					inv:set_stack("mese", 1, mese)
				end
				inv:set_stack("tool", 1, tool)

				minetest.chat_send_player(sender:get_player_name(), enchanted_tool .. " used " .. mc.cost .. " " .. mc.name .. " to add the " .. e.name .. " enchantment.")
			else
				minetest.chat_send_player(sender:get_player_name(), enchanted_tool .. " requires " .. mc.cost .. " " .. mc.name .. " to add the " .. e.name .. " enchantment.")
			end
		end
	end
end

function xenchant.dig(pos)
	local inv = minetest.get_meta(pos):get_inventory()
	return inv:is_empty("tool") and inv:is_empty("mese")
end

local function allowed(tool)
	local enchanted_tool = "xenchant:" .. tool

	for item in pairs(reg_tools) do
		if item:find(enchanted_tool) then
			return true
		end
	end
end

function xenchant.put(_, listname, _, stack)
	local stackname = stack:get_name()
	if listname == "mese" and stackname == "default:mese_crystal" then
		return stack:get_count()
	elseif listname == "mese" and stackname == "default:mese_crystal_fragment" and xenchant.enable_mese_fragments then
		return stack:get_count()
	elseif listname == "tool" and allowed(stackname:gsub(":", "_", 1)) then
		return 1
	end

	return 0
end

function xenchant.on_take(pos, listname)
	if listname == "tool" then
		xenchant.formspec(pos)
	end
end

function xenchant.construct(pos)
	local meta = minetest.get_meta(pos)
	meta:set_string("infotext", "Enchantment Table II")
	xenchant.formspec(pos)

	meta:set_int("books", 0)

	local inv = meta:get_inventory()
	inv:set_size("tool", 1)
	inv:set_size("mese", 1)

	minetest.add_entity({x = pos.x, y = pos.y + 0.85, z = pos.z}, "xenchant:book_open")
	local timer = minetest.get_node_timer(pos)
	timer:start(0.5)
end

function xenchant.destruct(pos)
	for _, obj in pairs(minetest.get_objects_inside_radius(pos, 0.9)) do
		if obj and obj:get_luaentity() and obj:get_luaentity().name == "xenchant:book_open" then
			obj:remove()
			break
		end
	end
end

function xenchant.timer(pos)
	local num = #minetest.get_objects_inside_radius(pos, 0.9)
	if num == 0 then
		minetest.add_entity({x = pos.x, y = pos.y + 0.85, z = pos.z}, "xenchant:book_open")
	end

	local minp = {x = pos.x - 2, y = pos.y,     z = pos.z - 2}
	local maxp = {x = pos.x + 2, y = pos.y + 1, z = pos.z + 2}

	local bookshelves = minetest.find_nodes_in_area(minp, maxp, "default:bookshelf")
	local meta = minetest.get_meta(pos)
	meta:set_int("books", #bookshelves)
	meta:set_string("infotext", "Enchantment Table II (level "..floor(#bookshelves / xenchant.bookshelves_per_level)..")")

	if #bookshelves == 0 then return true end

	local bookshelf_pos = bookshelves[random(1, #bookshelves)]
	local x = pos.x - bookshelf_pos.x
	local y = bookshelf_pos.y - pos.y
	local z = pos.z - bookshelf_pos.z

	if tostring(x .. z):find(2) then
		minetest.add_particle({
			pos = bookshelf_pos,
			velocity = {x = x, y = 2 - y, z = z},
			acceleration = {x = 0, y = -2.2, z = 0},
			expirationtime = 1,
			size = 1.5,
			glow = 5,
			texture = "xdecor_glyph" .. random(1,18) .. ".png"
		})
	end

	return true
end

minetest.register_node("xenchant:enchantment_table", {
	description = "Enchantment Table II",
	tiles = {
		"xdecor_enchantment_top.png",  "xdecor_enchantment_bottom.png",
		"xdecor_enchantment_side.png", "xdecor_enchantment_side.png",
		"xdecor_enchantment_side.png", "xdecor_enchantment_side.png"
	},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	light_source = 6,

	groups = {cracky = 1, level = 1},
	sounds = default.node_sound_stone_defaults(),

	on_rotate = (screwdriver or {}).rotate_simple,
	can_dig = xenchant.dig,
	on_timer = xenchant.timer,
	on_construct = xenchant.construct,
	on_destruct = xenchant.destruct,
	on_receive_fields = xenchant.fields,
	on_metadata_inventory_put = xenchant.on_put,
	on_metadata_inventory_take = xenchant.on_take,
	allow_metadata_inventory_put = xenchant.put,
	allow_metadata_inventory_move = function()
		return 0
	end,
})

minetest.register_entity("xenchant:book_open", {
	visual = "sprite",
	visual_size = {x=0.75, y=0.75},
	collisionbox = {0},
	physical = false,
	textures = {"xdecor_book_open.png"},
	on_activate = function(self)
		local pos = self.object:get_pos()
		local pos_under = {x = pos.x, y = pos.y - 1, z = pos.z}

		if minetest.get_node(pos_under).name ~= "xenchant:enchantment_table" then
			self.object:remove()
		end
	end
})



if minetest.get_modpath("xdecor") ~= nil then
	-- upgrade from xdecor's enchantment table
	minetest.register_craft({
		output = "xenchant:enchantment_table",
		recipe = {
			{"xdecor:enchantment_table"}
		}
	})
elseif minetest.get_modpath("mobs_monster") ~= nil then
	-- use same recipe as xdecor
	minetest.register_craft({
		output = "xenchant:enchantment_table",
		recipe = {
			{"", "default:book", ""},
			{"default:diamond", "mobs:lava_orb", "default:diamond"},
			{"default:obsidian", "default:obsidian", "default:obsidian"}
		}
	})
else
	-- use obsidian instead of lava_orb
	minetest.register_craft({
		output = "xenchant:enchantment_table",
		recipe = {
			{"", "default:book", ""},
			{"default:diamond", "default:obsidian", "default:diamond"},
			{"default:obsidian", "default:obsidian", "default:obsidian"}
		}
	})
end



--collectgarbage("collect") ; print("[XEnchant] memory usage = "..(collectgarbage("count")*1024 - _memory_usage_)..", load time = "..(os.clock()-_start_time_))  
print("[MOD] XEnchant loaded "..nr_tools.." enchanted tools and "..nr_armors.." enchanted armors")
