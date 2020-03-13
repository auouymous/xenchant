Minetest XEnchant
==========

Fork of xdecor's enchantment table.
If xdecor is installed, place its enchantment table in crafting grid to upgrade to an xenchant table.
If not installed, it uses same recipe as xdecor, unless mobs_monster is not installed, then it uses an extra obsidian in place of the lava orb.

Configurable enchantments in config-SAMPLE.lua.

Supports default tools,
ethereal crystal tools,
moreores silver and mithril tools,
mobs_monster lava pick,
3d_armor,
shields,
technic_armor,
and hazmat_suit.

Randomly selects up to three enchantments, re-insert item to get another selection.
Scrambling enchantment names can be enabled with `xenchant_random_enchants = true`.
If there is an issue with the random symbols not rendering, disable them with `xenchant_random_ascii = true`.

Enchantment levels.
High level enchantments can't be applied to low-level materials.
Requires 8 bookshelves per level, configurable with `xenchant_bookshelves_per_level = 8`.
Level 0 doesn't require bookshelves, level 1 requires 8, level 2 requires 16, ...

Enchanment and material costs.
Each enchantment specifies a base mese cost.
Each material multiplies the mese cost of the enchantment.
Cost is displayed in tooltip before enchanting.
Cheap materials use mese fragments instead of mese, can be disabled with `xenchant_no_mese_fragments = true`.

There is a chance to have the enchanting cost decreased, unless `xenchant_no_discounted_enchants = true`.
The chance increases as material cost decreases, 9 of 10 wood and stone enchants are free, and 1 in 810 mithril enchants will be discounted by 1 mese.
Allowing for cheap armor and tools to be enchanted without wasting a lot of mese on them.
