local Player = FindMetaTable("Player")

function Player:UpdateInvites(plyInviter, intAddRemove)
	if !ValidEntity(self) then return false end
	self.Invites = self.Invites or {}
	self.Invites[plyInviter] = intAddRemove
	if SERVER then
		SendUsrMsg("UD_UpdateInvites", self, {plyInviter, intAddRemove})
	end
	if CLIENT && intAddRemove == 1 then
		GAMEMODE:OpenInvitePromt(plyInviter)
	end
end

function Player:UpdateSquadTable()
	if !ValidEntity(self) then return false end
	self.Squad = {}
	if self:GetNWEntity("SquadLeader"):GetNWEntity("SquadLeader") == self:GetNWEntity("SquadLeader") then
		for _, plyPlayer in pairs(player.GetAll()) do
			if plyPlayer:GetNWEntity("SquadLeader") == self:GetNWEntity("SquadLeader") && ValidEntity(plyPlayer:GetNWEntity("SquadLeader")) then
				table.insert(self.Squad, plyPlayer)
			end
		end
	else
		if SERVER then self:SetNWEntity("SquadLeader", self) end
	end
	if SERVER then
		SendUsrMsg("UD_UpdateSquadTable", self, {})
	end
end

function Player:IsInSquad(plyTarget)
	if !ValidEntity(self) || !ValidEntity(plyTarget) then return false end
	return table.HasValue(self.Squad or {}, plyTarget)
end

function Player:GetAverageSquadLevel()
	if !ValidEntity(self) || !self.Squad then return 1 end
	local intTotalLevel = 0
	for _, ply in pairs(self.Squad or {}) do
		if ply:GetLevel() > intTotalLevel then
			intTotalLevel = ply:GetLevel()
		end
	end
	return intTotalLevel --/ #(self.Squad or {})
end

if CLIENT then
	function GM:OpenInvitePromt(plyInviter)
		GAMEMODE:DisplayPromt("none", plyInviter:Nick() .. " wants you to join a party!", function()
			RunConsoleCommand("UD_AcceptInvite", plyInviter:EntIndex())
		end)
	end
	usermessage.Hook("UD_UpdateInvites", function(usrMsg)
		LocalPlayer():UpdateInvites(usrMsg:ReadEntity(), usrMsg:ReadLong())
	end)
	usermessage.Hook("UD_UpdateSquadTable", function(usrMsg)
		LocalPlayer():UpdateSquadTable()
	end)
end
