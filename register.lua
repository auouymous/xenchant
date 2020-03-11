local register_material, register_tools = xenchant.register_material, xenchant.register_tools



-- default
register_material("wood", 0.1)
register_material("stone", 0.5)
register_material("steel", 1)
register_material("bronze", 1)
register_material("mese", 1.5)
register_material("diamond", 2)

register_tools("default", {
	materials = "wood, stone, steel, bronze, mese, diamond",
	tools = {
		axe		= {enchants = xenchant.tool_axe},
		pick	= {enchants = xenchant.tool_pick},
		shovel	= {enchants = xenchant.tool_shovel},
		sword	= {enchants = xenchant.tool_sword},
	}
})

-- farming:hoe_* stores max_uses in in the on_use function
-- fire:flint_and_steel stores max_uses in in the on_use function
-- screwdriver:screwdriver stores max_uses in on_use function

-- bows:bow_* stores max_uses in global table
-- mobs_redo mobs:shears stores max_uses in on_use function
-- technic:treetap stores max_uses in on_use function
-- technic wrench:wrench is unbreakable

-- ethereal (crystal)
if minetest.get_modpath("ethereal") ~= nil then
	register_material("crystal", 2.5)

	register_tools("ethereal", {
		materials = "crystal",
		tools = {
			axe		= {enchants = xenchant.tool_axe},
			pick	= {enchants = xenchant.tool_pick},
			shovel	= {enchants = xenchant.tool_shovel},
			sword	= {enchants = xenchant.tool_sword},
		}
	})

	-- ethereal:crystal_gilly_staff stores max_uses in on_use function
	-- ethereal:light_staff stores max_uses in on_use function
	-- ethereal:fishing_rod stores max_uses in on_use function
	-- ethereal:fishing_rod_baited stores max_uses in on_use function
end

-- moreores (mithril)
if minetest.get_modpath("moreores") ~= nil then
	register_material("tin", 1)
	register_material("silver", 1.5)
	register_material("mithril", 2.5)

	register_tools("moreores", {
		materials = "silver, mithril",
		tools = {
			axe		= {enchants = xenchant.tool_axe},
			pick	= {enchants = xenchant.tool_pick},
			shovel	= {enchants = xenchant.tool_shovel},
			sword	= {enchants = xenchant.tool_sword},
		}
	})

	-- moreores:hoe_* stores max_uses in in the on_use function
end

-- lava pick
if minetest.get_modpath("mobs_monster") ~= nil then
	register_tools("mobs", {
		materials = "2.5",
		tools = {
			pick_lava = {enchants = xenchant.tool_pick},
		}
	})
end

-- 3d_armor
if minetest.get_modpath("3d_armor") ~= nil then
	register_material("cactus", 0.2)
	register_material("gold", 1)

	register_tools("3d_armor", {
		materials = "wood, cactus, steel, bronze, diamond, gold, mithril, crystal",
		tools = {
			helmet		= {enchants = xenchant.armor_helmet},
			chestplate	= {enchants = xenchant.armor_chestplate},
			leggings	= {enchants = xenchant.armor_leggings},
			boots		= {enchants = xenchant.armor_boots},
		}
	})
end
if minetest.get_modpath("shields") ~= nil then
	register_material("enhanced_wood", 0.15)
	register_material("enhanced_cactus", 0.25)

	register_tools("shields", {
		materials = "wood, enhanced_wood, cactus, enhanced_cactus, steel, bronze, diamond, gold, mithril, crystal",
		tools = {
			shield = {enchants = xenchant.armor_shield}
		}
	})
end

-- technic_armor
if minetest.get_modpath("technic_armor") ~= nil then
	register_material("lead", 1)
	register_material("brass", 1)
	register_material("cast", 1)
	register_material("carbon", 1)
	register_material("stainless", 1)

	register_tools("technic_armor", {
		materials = "lead, brass, cast, carbon, stainless",
		tools = {
			helmet		= {enchants = xenchant.armor_helmet},
			chestplate	= {enchants = xenchant.armor_chestplate},
			leggings	= {enchants = xenchant.armor_leggings},
			boots		= {enchants = xenchant.armor_boots},
		}
	})

	if minetest.get_modpath("moreores") ~= nil then
		register_tools("technic_armor", {
			materials = "tin, silver",
			tools = {
				helmet		= {enchants = xenchant.armor_helmet},
				chestplate	= {enchants = xenchant.armor_chestplate},
				leggings	= {enchants = xenchant.armor_leggings},
				boots		= {enchants = xenchant.armor_boots},
			}
		})
	end

	if minetest.get_modpath("shields") ~= nil then
		register_tools("technic_armor", {
			materials = "lead, brass, cast, carbon, stainless",
			tools = {
				shield = {enchants = xenchant.armor_shield}
			}
		})

		if minetest.get_modpath("moreores") ~= nil then
			register_tools("technic_armor", {
				materials = "tin, silver",
				tools = {
					shield = {enchants = xenchant.armor_shield}
				}
			})
		end
	end
end

-- hazmat_suit
if minetest.get_modpath("hazmat_suit") ~= nil then
	register_tools("hazmat_suit", {
		materials = "2",
		tools = {
			suit_hazmat = {enchants = xenchant.armor_boots},
		}
	})
end

-- illuna_costumes
if minetest.get_modpath("illuna_costumes") ~= nil then
	register_tools("illuna_costumes", {
		materials = "2.75",
		tools = {
			helmet_of_fighter		= {enchants = xenchant.armor_helmet},
			chestplate_of_fighter	= {enchants = xenchant.armor_chestplate},
			leggings_of_fighter		= {enchants = xenchant.armor_leggings},
			boots_of_fighter		= {enchants = xenchant.armor_boots},
			shield_of_fighter		= {enchants = xenchant.armor_shield},
		}
	})
end
