local function AddModel(tblAddTable, strModel, vecPostion, angAngle, clrColor, strMaterial, vecScale)
	tblAddTable.Model = tblAddTable.Model or {}
	if type(tblAddTable.Model) != "table" then tblAddTable.Model = {} end
	table.insert(tblAddTable.Model, {Model = strModel, Position = vecPostion, Angle = angAngle, Color = clrColor, Material = strMaterial, Scale = vecScale})
	return tblAddTable
end
local function AddStats(tblAddTable, strSlot, intArmor)
	tblAddTable.Slot = strSlot
	tblAddTable.Armor = intArmor
	return tblAddTable
end
local function AddBuff(tblAddTable, strBuff, intAmount)
	tblAddTable.Buffs[strBuff] = intAmount
	return tblAddTable
end
--Usefull Mats (If you find more working textures add them)
--Models/props_c17/FurnitureMetal002a.vtf
--Models/Gibs/metalgibs/metal_gibs.vtf
--Models/props_building_details/courtyard_template001c_bars.vtf
--Models/props_building_details/courtyard_template001c_bars_dark.vtf
--Models/props_c17/gate_door01a.vtf
--Models/props_c17/gate_door02a.vtf
--Models/props_c17/Metalladder001.vtf
--Models/props_c17/Metalladder002.vtf
--Models/props_c17/Metalladder003.vtf
--Models/props_junk/rock_junk001a.vtf
--Models/props_lab/door_klab01.vtf