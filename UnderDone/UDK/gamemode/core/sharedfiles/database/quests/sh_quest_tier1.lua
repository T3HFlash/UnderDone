local Quest = {}
Quest.Name = "quest_killzombies"
Quest.PrintName = "Kill zombie"
Quest.Story = "Zombies a always attacking newcommers here. Say, tell you what, you kill a couple of them things and I will give you some cash for it."
Quest.TurnInStory = "Nice job, I like the way you handled those zombies lets do this more often."
Quest.Level = 1
Quest.Kill = {}
Quest.Kill["zombie"] = 8
Quest.GainedExp = 50
Quest.GainedItems = {}
Quest.GainedItems["money"] = 70
Register.Quest(Quest)

local Quest = {}
Quest.Name = "quest_killantlion"
Quest.PrintName = "Kill Antlion"
Quest.Story = "Dem antlions are estn meh flowers, kill em all please, before they get to the vegtable garden."
Quest.Level = 1
Quest.Kill = {}
Quest.Kill["antlion"] = 5
Quest.GainedExp = 45
Quest.GainedItems = {}
Quest.GainedItems["money"] = 80
Register.Quest(Quest)

local Quest = {}
Quest.Name = "quest_killheadcrab"
Quest.PrintName = "Freakin' head humpers!"
Quest.Story = "Always in my hair every single day! I'm so sick of it, please destroy at least 15 of them."
Quest.Level = 3
Quest.Kill = {}
Quest.Kill["headcrab"] = 15
Quest.GainedExp = 70
Quest.GainedItems = {}
Quest.GainedItems["money"] = 130
Register.Quest(Quest)

local Quest = {}
Quest.Name = "quest_beer"
Quest.PrintName = "Obtain Beer"
Quest.Story = "I need something to quench my first, go find me some beer steal one from a beer crate if you have to."
Quest.Level = 1
Quest.ObtainItems = {}
Quest.ObtainItems["quest_beer"] = 1
Quest.GainedExp = 45
Quest.GainedItems = {}
Quest.GainedItems["money"] = 80
Register.Quest(Quest)

local Quest = {}
Quest.Name = "quest_fortification"
Quest.PrintName = "Fortification"
Quest.Story = "We need to build some more fortifactions for the base. Go out and get us some wood. You can find it in boxes around the map."
Quest.Level = 1
Quest.ObtainItems = {}
Quest.ObtainItems["wood"] = 10
Quest.GainedExp = 55
Quest.GainedItems = {}
Quest.GainedItems["money"] = 30
Quest.GainedItems["item_healthkit"] = 2
Register.Quest(Quest)

local Quest = {}
Quest.Name = "quest_zombieblood"
Quest.PrintName = "Obtain Zombie Blood"
Quest.Story = "The virus is spread and we need a anti virus! Obtain some blood so we can examine it and cure this virus."
Quest.Level = 3
Quest.ObtainItems = {}
Quest.ObtainItems["quest_zombieblood"] = 10
Quest.GainedExp = 70
Quest.GainedItems = {}
Quest.GainedItems["money"] = 120
Quest.GainedItems["item_antivirus"] = 1
Register.Quest(Quest)

--Community made quests
local Quest = {}
Quest.Name = "quest_killbreen"
Quest.PrintName = "Kill Dr. Breen"
Quest.Story = "Dr. Breen is a pain in the ass for us rebels.  Kill him slowly so he suffers a terrible death in our hands."
Quest.Level = 22
Quest.Kill = {}
Quest.Kill["breen"] = 1
Quest.GainedExp = 300
Quest.GainedItems = {}
Quest.GainedItems["money"] = 2000
Register.Quest(Quest)

local Quest = {}
Quest.Name = "quest_killelite"
Quest.PrintName = "Kill Combine Elites"
Quest.Story = "These elite soldiers of the Combine are blocking our way to destroying Dr. Breen.  Kill these legendary soldiers and you will be rewarded."
Quest.Level = 20
Quest.Kill = {}
Quest.Kill["combine_elite"] = 2
Quest.GainedExp = 250
Quest.GainedItems = {}
Quest.GainedItems["money"] = 1000
Register.Quest(Quest)
