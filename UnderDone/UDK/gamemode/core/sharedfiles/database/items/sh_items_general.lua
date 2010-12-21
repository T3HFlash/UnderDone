local Item = QuickCreateItemTable(BaseItem, "money", "Money", "It will bring you happy", "icons/item_cash")
Item.Model = "models/props/cs_assault/Money.mdl"
Item.Stackable = true
Register.Item(Item)

local Item = QuickCreateItemTable(BaseItem, "wood", "Wood", "Its wood?", "icons/item_wood")
Item.Model = "models/Gibs/wood_gib01d.mdl"
Item.SellPrice = 7
Item.Weight = 1
Register.Item(Item)

local Item = QuickCreateItemTable(BaseItem, "weapon_melee_wrench", "Wrench", "Tool used for making things", "icons/tool_wrench")
Item.Model = "models/props_c17/tools_wrench01a.mdl"
Item.SellPrice = 250
Item.Weight = 1
Register.Item(Item)

local Item = QuickCreateItemTable(BaseItem, "item_trade_pliers", "Pliers", "Would be usefull for making things", "icons/tool_wrench")
Item.Model = "models/props_c17/tools_pliers01a.mdl"
Item.SellPrice = 500
Item.Weight = 1
Register.Item(Item)

local Item = QuickCreateItemTable(BaseItem, "item_trade_antlionblood", "Antlion Blood", "Its yellow, and kida smells like resberries", "icons/Quest_ZombieBlood")
Item.Model = "models/props_junk/glassjug01.mdl"
Item.SellPrice = 460
Item.Weight = 1
Register.Item(Item)

local Item = QuickCreateItemTable(BaseItem, "item_grenade", "Grenade", "Use to throw.", "icons/Quest_ZombieBlood")
Item.Model = "models/props_junk/glassjug01.mdl"
Item.Stackable = true
Item.SellPrice = 40
Item.Weight = 1
function Item:Use(usr, itemtable)
	if !ValidEntity(usr) or usr:Health() <= 0 then return end
	if (usr.NextNade or CurTime()) > CurTime() then return end
	usr:RestartGesture(ACT_ITEM_THROW)
	local entNade = ents.Create("npc_grenade_frag")
	timer.Simple(1, function()
		if ValidEntity(entNade) && ValidEntity(usr) then
			local vecNadePos = usr:EyePos() + (usr:GetAimVector() * 14)
			local intNadeDur = 3
			entNade:SetOwner(usr)
			entNade:Fire("SetTimer", intNadeDur)
			entNade.OverrideDamge = 50
			entNade:SetPos(vecNadePos)
			entNade:SetAngles(usr:EyeAngles())
			entNade:Spawn()
			entNade:GetPhysicsObject():ApplyForceCenter(usr:GetAimVector():GetNormalized() * 600)
		end
	end)
	usr.NextNade = CurTime() + 2
	usr:AddItem(itemtable.Name, -1)
end
Register.Item(Item)
