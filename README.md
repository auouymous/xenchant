Minetest XEnchant
==========

Fork of xdecor's enchantment table.

Configurable enchantments in config-SAMPLE.lua.

Supports default tools
, ethereal crystal tools
, moreores silver and mithril tools
, mobs_monster lava pick
, 3d_armor
, shields
, technic_armor
, and hazmat_suit.

Randomly selects up to three enchantments, re-insert item to get another selection.
Scrambling enchantment names can be enabled with `xenchant_random_enchants = true`.

Enchantment levels.
High level enchantments can't be applied to low-level materials.
Requires 8 bookshelves per level, configurable with `xenchant_bookshelves_per_level = 8`.
Level 0 doesn't require bookshelves, level 1 requires 8, level 2 requires 16, ...

Enchanment and material costs.
Each enchantment specifies a base mese cost.
Each material multiplies the mese cost of the enchantment.
Cost is displayed in tooltip before enchanting.
