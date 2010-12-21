local tblSharedFolders = {}
tblSharedFolders[1] = "udk/gamemode/core/sharedfiles/"
tblSharedFolders[2] = "udk/gamemode/core/sharedfiles/database/"
tblSharedFolders[3] = "udk/gamemode/core/sharedfiles/database/items/"
tblSharedFolders[4] = "udk/gamemode/core/sharedfiles/database/npcs/"
tblSharedFolders[5] = "udk/gamemode/core/sharedfiles/database/quests/"
tblSharedFolders[6] = "udk/gamemode/core/sharedfiles/database/shops/"
tblSharedFolders[7] = "udk/gamemode/core/sharedfiles/database/skills/"
tblSharedFolders[8] = "udk/gamemode/core/sharedfiles/database/stats/"

local tblClientFolders = {}
tblClientFolders[1] = "udk/gamemode/core/clientfiles/"
tblClientFolders[2] = "udk/gamemode/core/clientfiles/menus/"
tblClientFolders[3] = "udk/gamemode/core/clientfiles/vgui/"
tblClientFolders[4] = "udk/gamemode/core/clientfiles/menutabs/"
tblClientFolders[5] = "udk/gamemode/core/clientfiles/menutabs/helpmenu/"

local tblServerFolders = {}
tblServerFolders[1] = "udk/gamemode/core/serverfiles/"

if SERVER then
	local strPath = "udk/content/materials/gui/"
	for _, file in pairs(file.FindInLua(strPath .. "*")) do
		if string.find(file, ".vmt") or string.find(file, ".vtf") then
			strPath = string.Replace(strPath, "udk/content/", "")
			resource.AddFile(strPath ..file)
		end
	end
	local strPath = "udk/content/materials/icons/"
	for _, file in pairs(file.FindInLua(strPath .. "*")) do
		if string.find(file, ".vmt") or string.find(file, ".vtf") then
			strPath = string.Replace(strPath, "udk/content/", "")
			resource.AddFile(strPath .. file)
		end
	end
	
	local tblTotalFolder = {}
	table.Add(tblTotalFolder, tblSharedFolders)
	table.Add(tblTotalFolder, tblClientFolders)
	table.Add(tblTotalFolder, tblServerFolders)
	for _, path in pairs(tblTotalFolder) do
		for _, file in pairs(file.FindInLua(path .. "*.lua")) do
			if table.HasValue(tblClientFolders, path) or table.HasValue(tblSharedFolders, path) then
				AddCSLuaFile(path .. file)
			end
			if table.HasValue(tblSharedFolders, path) or table.HasValue(tblServerFolders, path)  then
				include(path .. file)
			end
		end
	end
	function resource.AddDir( dir, ext )
		for _, f in pairs( file.Find( "../" .. dir .. "/*" .. (ext or "") ) ) do
			resource.AddFile( dir .. "/" .. f )
		end
	end
	resource.AddDir( "materials/gui", ".vmt" )
	resource.AddDir( "materials/gui", ".vtf" )
	resource.AddDir( "materials/icons", ".vmt" )
	resource.AddDir( "materials/icons", ".vtf" )
	resource.AddDir( "materials/models/Betam01_Soldier", ".vmt" )
	resource.AddDir( "materials/models/Betam01_Soldier", ".vtf" )
	resource.AddFile( "models/Betam01_Soldier.dx80.vtx" )
	resource.AddFile( "models/Betam01_Soldier.dx90.vtx" )
	resource.AddFile( "models/Betam01_Soldier.mdl" )
	resource.AddFile( "models/Betam01_Soldier.phy" )
	resource.AddFile( "models/Betam01_Soldier.sw.vtx" )
	resource.AddFile( "models/Betam01_Soldier.vvd" )
	resource.AddFile( "maps/gm_underdone_v2.1.bsp" )
end

if !SERVER then
	local tblTotalFolder = {}
	table.Add(tblTotalFolder, tblSharedFolders)
	table.Add(tblTotalFolder, tblClientFolders)
	for _, path in pairs(tblTotalFolder) do
		for _, file in pairs(file.FindInLua(path .. "*.lua")) do
			include(path .. file)
		end
	end
end



