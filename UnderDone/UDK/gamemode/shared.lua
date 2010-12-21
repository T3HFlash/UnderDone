-------------------------
---------Generic---------
GM.Name 		= "UDK"
GM.Author 		= "Shell Shocked Gaming & TowerYard Entertainment"
GM.Email 		= "polkmpolkmpolkm@gmail.com"
GM.Website 		= "http://shellshocked.net46.net/"
-----Global Vars---------
GM.MonsterViewDistance = 200
GM.RelationHate = 1
GM.RelationFear = 2
GM.RelationLike = 3
GM.RelationNeutral = 4
--------DataBase---------
Register = {}
GM.DataBase = {}

GM.DataBase.Items = {}
function Register.Item(tblItem) GM.DataBase.Items[tblItem.Name] = tblItem end
function ItemTable(strItem) return GAMEMODE.DataBase.Items[strItem] end

GM.DataBase.Slots = {}
function Register.Slot(tblItem) GM.DataBase.Slots[tblItem.Name] = tblItem end
function SlotTable(strSlot) return GAMEMODE.DataBase.Slots[strSlot] end

GM.DataBase.EquipmentSets = {}
function Register.EquipmentSet(tblEquipmentSet) GM.DataBase.EquipmentSets[tblEquipmentSet.Name] = tblEquipmentSet end
function EquipmentSetTable(strEquipmentSet) return GAMEMODE.DataBase.EquipmentSets[strEquipmentSet] end

GM.DataBase.Stats = {}
local intStatIndex = 1
function Register.Stat(tblItem)
	GM.DataBase.Stats[tblItem.Name] = tblItem
	GM.DataBase.Stats[tblItem.Name].Index = intStatIndex
	intStatIndex = intStatIndex + 1
end
function StatTable(strStat) return GAMEMODE.DataBase.Stats[strStat] end

GM.DataBase.NPCs = {}
function Register.NPC(tblItem) GM.DataBase.NPCs[tblItem.Name] = tblItem end
function NPCTable(strNPC) return GAMEMODE.DataBase.NPCs[strNPC] end

GM.DataBase.Shops = {}
function Register.Shop(tblShop) GM.DataBase.Shops[tblShop.Name] = tblShop end
function ShopTable(strShop) return GAMEMODE.DataBase.Shops[strShop] end

GM.DataBase.Quests = {}
function Register.Quest(tblQuest) GM.DataBase.Quests[tblQuest.Name] = tblQuest end
function QuestTable(strQuest) return GAMEMODE.DataBase.Quests[strQuest] end



