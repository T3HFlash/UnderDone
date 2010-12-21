require("glon")
require("gatekeeper")
require("db")
AddCSLuaFile("shared.lua")
AddCSLuaFile("core/sh_resource.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")
include("core/sharedfiles/database/items/sh_items_base.lua")
include("core/sh_resource.lua")

function GM:PlayerInitialSpawn(ply)
end

function GM:PlayerAuthed(ply, SteamID, UniqueID)

end

function GM:PlayerSpawn(ply)
	hook.Call("PlayerLoadout", GAMEMODE, ply)
	hook.Call("PlayerSetModel", GAMEMODE, ply)
end

function GM:PlayerLoadout(ply)
	if !ply.Data or !ply.Data.Paperdoll then return end
	local strPrimaryWeapon = ply.Data.Paperdoll["slot_primaryweapon"]
	if !strPrimaryWeapon then return end
	local tblItemTable = GAMEMODE.DataBase.Items[strPrimaryWeapon]
	if !tblItemTable then return end
	ply:Give("weapon_primaryweapon")
	ply:GetWeapon("weapon_primaryweapon"):SetWeapon(tblItemTable)
	return true
end

local function ShowHelpMenu(ply)
	ply:ConCommand("UD_OpenHelp")
end
hook.Add("ShowHelp", "ShowHelpMenu", ShowHelpMenu)