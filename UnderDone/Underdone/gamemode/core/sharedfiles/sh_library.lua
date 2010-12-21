local Player = FindMetaTable("Player")

function Player:AddBookToLibrary(strBook)
	if !ValidEntity(self) then return false end
	self.Data.Library = self.Data.Library or {}
	self.Data.Library[strBook] = true
	for _, strRecipe in pairs(ItemTable(strBook).GainRecipes or {}) do
		self:AddRecipe(strRecipe)
	end
	if SERVER then
		if ItemTable(strBook).LibraryLoad then
			ItemTable(strBook):LibraryLoad(self, ItemTable(strBook))
		end
		SendUsrMsg("UD_UpdateLibrary", self, {strBook})
	end
	return true
end

function Player:HasReadBook(strBook)
	if !ValidEntity(self) then return false end
	return (self.Data.Library or {})[strBook]
end

if SERVER then
	function Player:RequestBookStory(strBook)
		if self:HasReadBook(strBook) then
			SendUsrMsg("UD_UpdateCurrentBook", self, {true})
			for i = 0, math.ceil(string.len(ItemTable(strBook).Story) / 150) - 1 do
				SendUsrMsg("UD_UpdateCurrentBook", self, {false, string.sub(ItemTable(strBook).Story, (i * 150) + 1, (i + 1) * 150)})
			end
		end
	end
	concommand.Add("UD_ReadBook", function(ply, command, args) ply:RequestBookStory(args[1]) end)
end

if CLIENT then
	usermessage.Hook("UD_UpdateLibrary", function(usrMsg)
		LocalPlayer():AddBookToLibrary(usrMsg:ReadString())
	end)
	usermessage.Hook("UD_UpdateCurrentBook", function(usrMsg)
		LocalPlayer().CurrentStory = LocalPlayer().CurrentStory or ""
		if !usrMsg:ReadBool() then
			LocalPlayer().CurrentStory = LocalPlayer().CurrentStory .. usrMsg:ReadString()
		else
			LocalPlayer().CurrentStory = ""
		end
		if GAMEMODE.ReadMenu then
			GAMEMODE.ReadMenu:UpdateStory()
		else
			RunConsoleCommand("UD_OpenReadMenu")
		end
	end)
end

