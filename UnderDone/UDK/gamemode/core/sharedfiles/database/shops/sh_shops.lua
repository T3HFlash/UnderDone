local Shop = {}
Shop.Name = "shop_general"
Shop.PrintName = "Shop General"
Shop.Inventory = {}
Shop.Inventory["item_canspoilingmeat"] = {}
Shop.Inventory["item_orange"] = {}
--Shop.Inventory["item_bananna"] = {}
--Shop.Inventory["item_banannabunch"] = {}
Shop.Inventory["item_smallammo_small"] = {}
Shop.Inventory["item_rifleammo_small"] = {}
Shop.Inventory["item_buckshotammo_small"] = {}
Shop.Inventory["item_healthkit"] = {}
Shop.Inventory["item_antivirus"] = {}
Register.Shop(Shop)

local Shop = {}
Shop.Name = "shop_armor"
Shop.PrintName = "Armor Shop"
Shop.Inventory = {}
Shop.Inventory["armor_helm_chefshat"] = {}
Shop.Inventory["armor_helm_junkhelmet"] = {}
Shop.Inventory["armor_helm_scannergoggles"] = {}
Shop.Inventory["armor_belt_leather"] = {}
Shop.Inventory["armor_chest_junkarmor"] = {}
Shop.Inventory["armor_sheild_cog"] = {}
Shop.Inventory["armor_sheild_saw"] = {}
Register.Shop(Shop)


local Shop = {}
Shop.Name = "shop_weapons"
Shop.PrintName = "Arms Dealer"
Shop.Inventory = {}
Shop.Inventory["weapon_ranged_junkpistol"] = {}
Shop.Inventory["weapon_ranged_junksmg"] = {}
Shop.Inventory["weapon_ranged_junkrifle"] = {}
Shop.Inventory["weapon_ranged_drumshotgun"] = {}
Shop.Inventory["weapon_ranged_heavymacgun"] = {}
Shop.Inventory["weapon_melee_cleaver"] = {}
Shop.Inventory["weapon_melee_leadpipe"] = {}
Shop.Inventory["weapon_melee_knife"] = {}
Shop.Inventory["weapon_melee_circularsaw"] = {}
Shop.Inventory["weapon_melee_dualaxe"] = {}
Register.Shop(Shop)

--Testing shop
--[[
local Shop = {}
Shop.Name = "shop_weapons"
Shop.PrintName = "Arms Dealer"
Shop.Inventory = {}
Shop.Inventory["weapon_ranged_junkpistol"] = {Price = 1}
Shop.Inventory["weapon_ranged_junksmg"] = {Price = 1}
Shop.Inventory["weapon_ranged_junkrifle"] = {Price = 1}
Shop.Inventory["weapon_ranged_heavymacgun"] = {Price = 1}
Shop.Inventory["weapon_melee_cleaver"] = {Price = 1}
Shop.Inventory["weapon_melee_leadpipe"] = {Price = 1}
Shop.Inventory["weapon_melee_knife"] = {Price = 1}
Shop.Inventory["weapon_melee_circularsaw"] = {Price = 1}
Shop.Inventory["weapon_melee_dualaxe"] = {Price = 1}
Shop.Inventory["weapon_melee_anttalon"] = {Price = 1}
Shop.Inventory["weapon_melee_emptool"] = {Price = 1}
Shop.Inventory["armor_chest_antlion"] = {Price = 1}
Shop.Inventory["armor_shoulder_antlion"] = {Price = 1}
Shop.Inventory["armor_helm_antlionhelm"] = {Price = 1}
Shop.Inventory["armor_helm_cyborg"] = {Price = 1}
Shop.Inventory["armor_chest_cyborg"] = {Price = 1}
Shop.Inventory["armor_shoulder_cyborg"] = {Price = 1}
Shop.Inventory["armor_shield_imprvsaw"] = {Price = 1}
Shop.Inventory["armor_helm_bones"] = {Price = 1}
Shop.Inventory["armor_shield_antlionshell"] = {Price = 1}
Shop.Inventory["armor_belt_antlion"] = {Price = 1}
Register.Shop(Shop)]]