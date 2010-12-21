local function TickDistanceRetreat()
	for _, npc in pairs(ents.FindByClass("npc_*")) do
		if ValidEntity(npc) then
			local tblNPCTable = NPCTable(npc:GetNWString("npc"))
			if tblNPCTable && tblNPCTable.DistanceRetreat then
				if npc:GetPos():Distance(npc.Position) > tblNPCTable.DistanceRetreat then
					if !npc.HasTask then
						npc:ReturnSpawn()
						npc.HasTask = true
						timer.Simple(20, function()
							if ValidEntity(npc) && npc.HasTask then
								npc:Idle()
								npc.HasTask = false
							end
						end)
					end
					if npc && npc:IsValid()&& npc.HasTask then
						if npc:GetPos():Distance(npc.Position) < (tblNPCTable.DistanceRetreat * 0.8) then
							npc:Idle()
							npc.HasTask = false
						end
						if npc:IsBlocked() then
							npc:SetPos(npc.Position)
						end
					end
				end
			end
		end
	end
end
hook.Add("Tick", "TickDistanceRetreat", TickDistanceRetreat)
	
function GM:OnNPCKilled(npcTarget, entKiller, weapon)
	if npcTarget:GetClass() == "npc_zombie" then GAMEMODE:RemoveAll("npc_headcrab") end
	if !entKiller:IsPlayer() && npcTarget.LastPlayerAttacker then entKiller = npcTarget.LastPlayerAttacker end
	if npcTarget:GetNWInt("level") > 0 && entKiller && entKiller:IsValid() && entKiller:IsPlayer() then
		local tblNPCTable = NPCTable(npcTarget:GetNWString("npc"))
		if #(entKiller.Squad or {}) > 1 then
			local intTotalExp = math.Round((npcTarget:GetMaxHealth() * (npcTarget:GetLevel() / entKiller:GetAverageSquadLevel())) / (#(entKiller.Squad or {}) + 15))
			local intPerPlayer = math.Round(intTotalExp / #entKiller.Squad)
			for _, ply in pairs(entKiller.Squad) do
				if ValidEntity(ply) then
					ply:GiveExp(intPerPlayer, true)
				end
			end
		else
			entKiller:GiveExp(math.Round((npcTarget:GetMaxHealth() * (npcTarget:GetLevel() / entKiller:GetLevel())) / 10), true)
		end
		for strItem, tblInfo in pairs(tblNPCTable.Drops or {}) do
			local tblItemTable = ItemTable(strItem)
			--Check Level of player and of npc
			if (entKiller:GetLevel() + 5) >= (tblItemTable.Level or 1) && npcTarget:GetLevel() >= (tblInfo.MinLevel or 0) then
				if !tblItemTable.QuestItem then
					if tblInfo.Chance && math.random(1, (100 / (tblInfo.Chance or 1))) == 1 then
						local intAmount = math.random(tblInfo.Min or 1, tblInfo.Max or tblInfo.Min or 1)
						local entLoot = CreateWorldItem(strItem, intAmount, npcTarget:GetPos() + Vector(0, 0, 30))
						entLoot:SetOwner(entKiller)
						local phyLootPhys = entLoot:GetPhysicsObject()
						if !ValidEntity(phyLootPhys) && ValidEntity(entLoot.Grip) then phyLootPhys = entLoot.Grip:GetPhysicsObject() end
						phyLootPhys:Wake()
						phyLootPhys:ApplyForceCenter(Vector(math.random(-100, 100), math.random(-100, 100), math.random(350, 400)))
					end
				end
			end
		end
	end
end

local function NPCAdjustDamage(entVictim, entInflictor, entAttacker, intAmount, tblDamageInfo)
	if !ValidEntity(entVictim) or !NPCTable(entVictim:GetNWString("npc")) then return end
	local tblNPCTable = NPCTable(entVictim:GetNWString("npc"))
	local boolInvincible = tblNPCTable.Invincible or entAttacker.Race == tblNPCTable.Race
	if entAttacker:IsPlayer() && !boolInvincible then
		local clrDisplayColor = "white"
		tblDamageInfo:SetDamage(math.Round(tblDamageInfo:GetDamage() * (1 / entVictim:GetNWInt("level"))))		
		if math.random(1, 20) == 1 then
			tblDamageInfo:SetDamage(math.Round(tblDamageInfo:GetDamage() * 2))
			clrDisplayColor = "blue"
		end
		if entVictim:Health() < 2 && entVictim:IsBuilding() then
			local tblNPCTable = NPCTable(entVictim:GetNWString("npc"))
			if !tblNPCTable then return end
			entAttacker:AddQuestKill(entVictim:GetNWString("npc"))
		end
		if entVictim:Health() < 2 then
			entVictim:Remove()
		end
		tblDamageInfo:SetDamage(math.Round(tblDamageInfo:GetDamage() + math.random(-1, 1)))
		tblDamageInfo:SetDamage(math.Clamp(tblDamageInfo:GetDamage(), 0, tblDamageInfo:GetDamage()))
		entVictim.FirstPlayerAttacker = entVictim.FirstPlayerAttacker || entAttacker
		entVictim.LastPlayerAttacker = entAttacker
		entVictim:SetHealth(entVictim:Health() - tblDamageInfo:GetDamage())
		entVictim:SetNWInt("Health", entVictim:Health())
		tblDamageInfo:SetDamage(0)
	end
	if boolInvincible then tblDamageInfo:SetDamage(0) end
end
hook.Add("EntityTakeDamage", "NPCAdjustDamage", NPCAdjustDamage)
function GM:ScaleNPCDamage(entVictim, strHitGroup, tblDamageInfo) tblDamageInfo:ScaleDamage(1) end
