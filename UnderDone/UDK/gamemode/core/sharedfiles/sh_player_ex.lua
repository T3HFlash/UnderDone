local Player = FindMetaTable("Player")

function Player:IsMelee()
	if ItemTable(self:GetSlot("slot_primaryweapon")) && ItemTable(self:GetSlot("slot_primaryweapon")).HoldType then
		return ItemTable(self:GetSlot("slot_primaryweapon")).HoldType == "melee"
	end
	return
end

function Player:GetActiveAmmoType()
	if ItemTable(self:GetSlot("slot_primaryweapon")) && ItemTable(self:GetSlot("slot_primaryweapon")).AmmoType then
		return ItemTable(self:GetSlot("slot_primaryweapon")).AmmoType
	end
	return
end

function Player:GetMaximumHealth()
	return self:GetStat("stat_maxhealth")
end

function Player:GetMaxWeight()
	return self:GetStat("stat_maxweight")
end

function Player:GetArmorRating()
	local intTotalArmor = 1
	if !self.Data then return end
	for strSlot, strItem in pairs(self.Data.Paperdoll or {}) do
		local tblItemTable = ItemTable(strItem)
		if tblItemTable && tblItemTable.Armor then
			intTotalArmor = intTotalArmor + tblItemTable.Armor
		end
	end
	return intTotalArmor
end

if SERVER then

	function Player:SearchQuestProp(Ent, strModel, strItem, strAmount)
		if Ent:GetModel() == strModel then
			local tblItemTable = ItemTable(strItem)
			if !Ent.IsBeingSearched then
				self:CreateNotification("Searching")
				Ent.IsBeingSearched = true
				self:Freeze( true ) 
				timer.Simple(5, function()
					if self:QuestItem(strItem) then

						self:CreateNotification("Found " .. tblItemTable.PrintName)
						self:AddItem(strItem, strAmount)
					else
						self:CreateNotification("You don't need a " .. tblItemTable.PrintName)
					end
					self:Freeze( false )
					Ent.IsBeingSearched = false
				end)
			end
		end
	end
	
	function Player:SearchWorldProp(Ent, strModel, strItem, strAmount, strModelChanging)	
		if !Ent then return end
		if Ent:GetModel() == strModel then
			if !Ent.IsBeingSearched then
				self:CreateNotification("Searching")
				Ent.IsBeingSearched = true
				self:Freeze( true ) 
				timer.Simple(5, function()
					if math.random(1,10) == 1 then
						local FoundItem = table.Random(strItem)
						local tblItemTable = ItemTable(FoundItem)
						if FoundItem == "money" then strAmount = math.random(1,20) end
						self:CreateNotification("Found x" .. strAmount .. " " .. tblItemTable.PrintName)
						self:AddItem(FoundItem, strAmount)
					else
						self:CreateNotification("Nothing is in here!")
					end
					if strModelChanging then
						Ent:EmitSound( Sound("items/ammocrate_open.wav") )
						Ent:SetModel(strModelChanging)
					else
						self:Freeze( false )
						Ent.IsBeingSearched = false
					end
				end)
				timer.Simple(8, function()
					self:Freeze( false )
					Ent.IsBeingSearched = false
					if strModelChanging then
						Ent:EmitSound( Sound("items/ammocrate_close.wav") )
						Ent:SetModel(strModel)
					end
				end)
			end
		end
	end
	
	local tblComplements = {}
	tblComplements[1] = "Holy_Shit_Your_Cool"
	tblComplements[2] = "Nice_Man!"
	tblComplements[3] = "You_Are_Epic!"
	tblComplements[4] = "I_Wish_I_Was_As_Cool_As_You!"
	tblComplements[5] = "I_Jizzed!"
	tblComplements[6] = "Gratz!"
	tblComplements[7] = "I_Just_Shat_My_Pants!"
	tblComplements[8] = "Call_Me!"
	tblComplements[9] = "You_Should_Model!"
	tblComplements[10] = "God_Damn_I_Love_You!"
	tblComplements[11] = "You_Make_Me_Hot"
	tblComplements[12] = "I_Wish_I_Could_Touch_You"
	tblComplements[13] = "You_Now_With_10%_More_Cowbell"
	tblComplements[14] = "My_Girlfriend_Left_Me_For_You"
	tblComplements[15] = "Lets_Make_Party"
	local tblColors = {}
	tblColors[1] = "purple"
	tblColors[2] = "blue"
	tblColors[3] = "orange"
	tblColors[4] = "red"
	tblColors[5] = "green"
	tblColors[6] = "white"
	function Player:GiveExp(intAmount, boolShowExp)
		local intCurrentExp = self:GetNWInt("exp")
		local intPreExpLevel = self:GetLevel()
		if intCurrentExp + intAmount >= 0 then
			local intTotal = math.Clamp(intCurrentExp + intAmount, toExp(intPreExpLevel), intCurrentExp + intAmount)
			self:SetNWInt("exp", intTotal)
			local intPostExpLevel = self:GetLevel()
			if intPreExpLevel < intPostExpLevel then
				hook.Call("UD_Hook_PlayerLevelUp", GAMEMODE, self, intPostExpLevel - intPreExpLevel)
				self:SetHealth(self:GetMaximumHealth())
			end
		end
	end
	
	function GM:PlayerDeath(victim, weapon, killer)
		if killer:IsNPC() && victim:IsPlayer() then
			if killer.Race == victim.Race then
				killer:AddEntityRelationship(victim, GAMEMODE.RelationLike, 99)
			end
		end
	end
	
	local function PlayerAdjustDamage(entVictim, entInflictor, entAttacker, intAmount, tblDamageInfo)
		if !entVictim:IsPlayer() then return end
		local clrDisplayColor = "red"
		local tblNPCTable = NPCTable(entAttacker:GetNWString("npc"))
		for _,v in pairs(ents.FindInBox( Vector(1046, -157, -126), Vector(1827, -995, 8) )) do
			v.PlayerPvp = true
		end
		if entVictim:IsPlayer() && entAttacker:IsPlayer() then
			if entVictim.PlayerPvp && entAttacker.PlayerPvp  then
				entVictim.PlayerPvp = false
				entAttacker.PlayerPvp = false	
			else
				tblDamageInfo:SetDamage(0)
			end
		end
		if tblNPCTable then
			tblDamageInfo:SetDamage((tblNPCTable.DamagePerLevel or 0) * entAttacker:GetNWInt("level"))
			tblDamageInfo:SetDamage(tblDamageInfo:GetDamage() * (1 / (((entVictim:GetArmorRating() - 1) / 10) + 1)))
			tblDamageInfo:SetDamage(math.Clamp(math.Round(tblDamageInfo:GetDamage() + math.random(-1, 1)), 0, 9999))
			if tblNPCTable.Race == "human" then tblDamageInfo:SetDamage(0) end
		end		
	end
	hook.Add("EntityTakeDamage", "PlayerAdjustDamage", PlayerAdjustDamage)
end