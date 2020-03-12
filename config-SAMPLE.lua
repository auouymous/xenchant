-- copy this file to config.lua



-- there needs to be multiple enchants with same cost for each item
-- otherwise cost value can be used to determine an enchant when xenchant_random_enchants is enabled

xenchant.register_enchant("fast", "Efficiency", xenchant.help.fast, 1, -0.1, xenchant.action.fast, 0, 1)
xenchant.register_enchant("fast2", "Efficiency II", xenchant.help.fast, 1, -0.2, xenchant.action.fast, 2, 3)

xenchant.register_enchant("sharp", "Sharpness", xenchant.help.sharp, 1, 1, xenchant.action.sharp, 0, 1)
xenchant.register_enchant("sharp2", "Sharpness II", xenchant.help.sharp, 1, 2, xenchant.action.sharp, 2, 3)

xenchant.register_enchant("durable", "Durability", xenchant.help.durable, 1.5, 0, xenchant.action.durable, 0, 1)
xenchant.register_enchant("durable2", "Durability II", xenchant.help.durable, 2, 0, xenchant.action.durable, 2, 3)

xenchant.register_enchant("protect", "Protection", xenchant.help.protect, 1.1, 0, xenchant.action.protect, 0, 1)

xenchant.register_enchant("heal", "Healing", xenchant.help.heal, 1.1, 0, xenchant.action.heal, 1, 3)

xenchant.register_enchant("water", "Water Breathing", xenchant.help.water, 1, 1, xenchant.action.water, 2, 15)

xenchant.register_enchant("fire", "Fire Resistance", xenchant.help.fire, 1, 1, xenchant.action.fire, 2, 5)

xenchant.register_enchant("radiation", "Radiation Resistance", xenchant.help.radiation, 1, 1, xenchant.action.radiation, 1, 5)

xenchant.register_enchant("jump", "Jump Boost", xenchant.help.jump, 0, 0.5, xenchant.action.jump, 1, 5)
xenchant.register_enchant("jump2", "Jump Boost II", xenchant.help.jump, -0.75, 0.5, xenchant.action.jump, 2, 15)

xenchant.register_enchant("speed", "Speed Boost", xenchant.help.speed, 1, 1, xenchant.action.speed, 1, 5)
xenchant.register_enchant("speed2", "Speed Boost II", xenchant.help.speed, 1, 2, xenchant.action.speed, 2, 15)



-- enchantments for tools
xenchant.tool_common	= "durable, durable2"
xenchant.tool_axe		= xenchant.tool_common .. ", fast, fast2"
xenchant.tool_pick		= xenchant.tool_common .. ", fast, fast2"
xenchant.tool_shovel	= xenchant.tool_common .. ", fast, fast2"
xenchant.tool_sword		= xenchant.tool_common .. ", sharp, sharp2"
xenchant.tool_hoe		= xenchant.tool_common

-- enchantments for armor
xenchant.armor_common		= "durable, durable2, protect, heal, fire, radiation"
xenchant.armor_helmet		= xenchant.armor_common .. ", water"
xenchant.armor_chestplate	= xenchant.armor_common .. ""
xenchant.armor_leggings		= xenchant.armor_common .. ""
xenchant.armor_boots		= xenchant.armor_common .. ", jump, jump2, speed, speed2"
xenchant.armor_shield		= xenchant.armor_common .. ""
