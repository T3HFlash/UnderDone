local Quest = {}
Quest.Name = "quest_killcombinethumper"
Quest.PrintName = "Kill Combine Thumper"
Quest.Story = "Those combine thumpers are disturbing my work and i can't carry on like this can you do something about it?"
Quest.Level = 5
Quest.Kill = {}
Quest.Kill["combine_thumper"] = 5
Quest.GainedExp = 50
Quest.GainedItems = {}
Quest.GainedItems["money"] = 100
Register.Quest(Quest)

local Quest = {}
Quest.Name = "quest_killcombine"
Quest.PrintName = "My poor Satalite!"
Quest.Story = "Those damned Combine keep making use of my Satalite array equipment as target practice! I cant work with swiss cheese! Please help me! Kill those horrible things!"
Quest.QuestNeeded = "quest_killcombinethumper"
Quest.Level = 6
Quest.Kill = {}
Quest.Kill ["combine_smg"] = 15
Quest.GainedExp = 100
Quest.GainedItems = {}
Quest.GainedItems["money"] = 160
Register.Quest(Quest)

local Quest = {}
Quest.Name = "quest_monkeybusiness"
Quest.PrintName = "Monkey Business"
Quest.Story = "Fokes round here dont get much exotic fruit no more, not since the cleansing ... If you can get me some ripe banana I'd give you a hook I found in a zombie"
Quest.Level = 8
Quest.ObtainItems = {}
Quest.ObtainItems["item_bananna"] = 10
Quest.GainedExp = 65
Quest.GainedItems = {}
Quest.GainedItems["weapon_melee_meathook"] = 1
Register.Quest(Quest)

local Quest = {}
Quest.Name = "quest_toolwrench"
Quest.PrintName = "I need Tools!"
Quest.Story = "My research cannot continue without the proper equipment. I hear those reched Combine are utilising Tool Wrenches to maintain their Thumpers. Collect one of these for me! It would be very much appreciated."
Quest.Level = 8
Quest.ObtainItems = {}
Quest.ObtainItems["weapon_melee_wrench"] = 1
Quest.GainedExp = 110
Quest.GainedItems = {}
Quest.GainedItems["money"] = 200
Register.Quest(Quest)

local Quest = {}
Quest.Name = "quest_killantlionboss"
Quest.PrintName = "Kill Antlionboss"
Quest.Story = "People say there is an Antlion boss some were. If you can kill it ill give you somethign to make it worth you while"
Quest.Level = 9
Quest.TeamAllowed = 2
Quest.Kill = {}
Quest.Kill["antlionguard"] = 1
Quest.GainedExp = 200
Quest.GainedItems = {}
Quest.GainedItems["money"] = 200
Register.Quest(Quest)