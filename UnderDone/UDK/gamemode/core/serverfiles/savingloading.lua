local Player = FindMetaTable("Player")

function Player:NewGame()
	self:SetNWInt("exp", 0)
	self.Loaded = true
	self:SetNWBool("Loaded", true)
	print("New Game")
end

function Player:LoadGame()
	self.Data = {}
	self.Race = "human"
	for name, stat in pairs(GAMEMODE.DataBase.Stats) do self:SetStat(name, stat.Default) end
	local strSteamID = string.Replace(self:SteamID(), ":", "!")
	if strSteamID != "STEAM_ID_PENDING" then
		self:NewGame()
		hook.Call("UD_Hook_PlayerLoad", GAMEMODE, self)
		for _, ply in pairs(player.GetAll()) do
			if ply != self && ply.Data && ply.Data.Paperdoll then
				for slot, item in pairs(ply.Data.Paperdoll) do
					SendUsrMsg("UD_UpdatePapperDoll", self, {ply, slot, item})
				end
			end
		end
	end
	return
end