function GM:StartEvent(strEvent)
	local tblEventTable = EventTable(strEvent)
	for index, tblNPCAttack in pairs(tblEventTable.NPCAttack or {}) do
		if !tblNPCAttack then return end
		timer.Simple(tblNPCAttack.Spawntime, function() GAMEMODE:TimerSpawnNPC(tblNPCAttack) end)
	end
end

function GM:TimerSpawnNPC(tblNPCAttack)
	if !tblNPCAttack then return end
	local tblSpawnTable = {Postion = tblNPCAttack.Spawnpos, Level =  tblNPCAttack.Level or (tblNPCAttack.AmountSpawned or 1) }
	if (tblNPCAttack.AmountSpawned or 0) < tblNPCAttack.Amount then
		local NPC = self:CreateNPC(tblNPCAttack.Class, tblSpawnTable)
		tblNPCAttack.AmountSpawned = (tblNPCAttack.AmountSpawned or 0) + 1
		NPC:AttackPos(tblNPCAttack.Attackpos)
		NPC.DontReturn = true
		timer.Simple(tblNPCAttack.Spawntime, function() GAMEMODE:TimerSpawnNPC(tblNPCAttack) end)
	end
end

function GM:TickUpdater()
	if (!GAMEMODE.NextUpdate) then GAMEMODE.NextUpdate = CurTime() end
	if (CurTime() > GAMEMODE.NextUpdate) then
		GAMEMODE.NextUpdate = CurTime() + 1
		GAMEMODE:TimeChecker()
	end
end
hook.Add("Tick", "TickUpdater", function() GAMEMODE:TickUpdater() end)

function GM:TimeChecker()
	for _,Event in pairs(GAMEMODE.DataBase.Events or {}) do
		if !Event.Time.w && !Event.Time.H then return end
		if os.date("%w") == Event.Time.w && os.date("%H") == Event.Time.Start then
			if os.date("%M") >= "50" && os.date("%S") == "00" then
				local CountDown = 10 -(tonumber(os.date("%M")) - 50)
				GAMEMODE:NotificateAll("Event " ..Event.PrintName.. " will begin in ".. CountDown .." Minutes")
			end
		end
		if os.date("%w") == Event.Time.w && os.date("%H") == Event.Time.H && os.date("%M") < Event.Duration then
			if GAMEMODE.EventHasStarted then return end
			GAMEMODE.EventHasStarted = true
			GAMEMODE:NotificateAll("Event " ..Event.PrintName.. " Has Begun!")
			GAMEMODE:StartEvent(Event.Name)
		end
		if os.date("%w") == Event.Time.w && os.date("%H") == Event.Time.H then
			if GAMEMODE.EventHasStarted  && os.date("%M") >= Event.Duration then
				GAMEMODE:EndEvent(Event)
			end
		end
	end
end

function GM:EndEvent(Event)
	for _,ply in pairs(player.GetAll()) do
		ply:ChatPrint("Event has ended!")
	end
	GAMEMODE.EventHasStarted = false
end
