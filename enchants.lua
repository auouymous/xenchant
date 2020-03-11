local ceil = math.ceil
local help, action, colorize, to_percent = xenchant.help, xenchant.action, xenchant.colorize, xenchant.to_percent



-- Efficiency
help.fast = "Your tool digs faster"
action.fast = function(e, caps)
	local orig_caps = caps.original_groupcaps[caps.group]
	local orig_sum = 0
	local new_sum = 0
	for i, time in pairs(orig_caps.times) do
		orig_sum = orig_sum + time
		caps.groupcaps[caps.group].times[i] = time * e.multiplier + e.offset
		new_sum = new_sum + caps.groupcaps[caps.group].times[i]
	end
	return colorize("#74ff49", e.name, to_percent(orig_sum / #orig_caps.times, new_sum / #orig_caps.times))
end

-- Sharpness
help.sharp = "Your weapon inflicts more damage"
action.sharp = function(e, caps)
	local orig = caps.fleshy
	caps.fleshy = orig * e.multiplier + e.offset
	return colorize("#ffff00", e.name, to_percent(orig, caps.fleshy))
end

-- Durability
help.durable = "Your tool or armor lasts longer"
action.durable = function(e, caps)
	if caps.groups and caps.groups.armor_use then
		local orig = caps.groups.armor_use
		caps.groups.armor_use = ceil(orig * e.multiplier + e.offset)
		return colorize("#00baff", e.name, to_percent(orig, caps.groups.armor_use))
	else
		local orig = caps.original_groupcaps[caps.group].uses
		caps.groupcaps[caps.group].uses = ceil(orig * e.multiplier + e.offset)
		return colorize("#00baff", e.name, to_percent(orig, caps.groupcaps[caps.group].uses))
	end
end

-- Protection
help.protect = "Your armor protects you from more damage"
action.protect = function(e, caps)
	if caps.armor_groups then
		local orig = caps.armor_groups.fleshy
		caps.armor_groups.fleshy = ceil(orig * e.multiplier + e.offset)
		return colorize("#bbbbbb", e.name, to_percent(orig, caps.armor_groups.fleshy))
	else
		local part = xenchant.get_armor_part(caps.groups)
		local orig = caps.groups[part]
		caps.groups[part] = ceil(orig * e.multiplier + e.offset)
		return colorize("#bbbbbb", e.name, to_percent(orig, caps.groups[part]))
	end
end

-- Healing
help.heal = "Your armor heals more damage you take"
action.heal = function(e, caps)
	caps.groups.armor_heal = ceil((caps.groups.armor_heal or 1) * e.multiplier + e.offset)
	return colorize("#ff0000", e.name, caps.groups.armor_heal)
end

-- Water Breathing
help.water = "Your armor protects against suffocation"
action.water = function(e, caps) -- ignore multiplier
	caps.groups.armor_water = (caps.groups.armor_water or 0) + e.offset
	return colorize("#bbbbbb", e.name, caps.groups.armor_water)
end

-- Fire Resistance
help.fire = "Your armor protects against fire"
action.fire = function(e, caps) -- ignore multiplier
	caps.groups.armor_fire = (caps.groups.armor_fire or 0) + e.offset
	return colorize("#bbbbbb", e.name, caps.groups.armor_fire)
end

-- Radiation Resistance
help.radiation = "Your armor protects against radiation"
action.radiation = function(e, caps) -- ignore multiplier
	caps.groups.armor_radiation = (caps.groups.armor_radiation or 0) + e.offset
	return colorize("#bbbbbb", e.name, caps.groups.armor_radiation)
end

-- Jump Boost
help.jump = "You jump higher"
action.jump = function(e, caps) -- multiplier is gravity offset
	caps.groups.physics_jump = (caps.groups.physics_jump or 0) + e.offset
	caps.groups.physics_gravity = (caps.groups.physics_gravity or 0) + e.multiplier
	return colorize("#bbbbbb", e.name, (caps.groups.physics_jump+1).."x + "..(caps.groups.physics_gravity))
end

-- Speed Boost
help.speed = "You walk faster"
action.speed = function(e, caps) -- ignore multiplier
	caps.groups.physics_speed = (caps.groups.physics_speed or 0) + e.offset
	return colorize("#bbbbbb", e.name, (caps.groups.physics_speed+1).."x")
end
