local Player = FindMetaTable("Player")

concommand.Add("udk_edit_items_giveitem", function(ply, command, args)
	local tblItemTable = ItemTable(args[1])
	if tblItemTable.Use then
		tblItemTable:Use(ply, tblItemTable)
	end
end)

concommand.Add("udk_edit_items_clearpaperdoll", function(ply, command, args)
	for strSlot, strItem in pairs(ply.Data.Paperdoll or {}) do
		local tblItemTable = ItemTable(strItem)
		if tblItemTable.Use then tblItemTable:Use(ply, tblItemTable) end
	end
end)

function Player:HasSet(strSet)
	if !ValidEntity(self) then return false end
	local tblSetTable = EquipmentSetTable(strSet)
	if !tblSetTable then return false end
	for _, strItem in pairs(tblSetTable.Items or {}) do
		if !table.HasValue(self.Data.Paperdoll or {}, strItem) then return false end
	end
	return true
end

function Player:SetPaperDoll(strSlot, strItem)
	if !self or !self:IsValid() then return false end
	local tblItemTable = ItemTable(strItem) or {}
	self.Data = self.Data or {}
	self.Data.Paperdoll = self.Data.Paperdoll or {}
	if !strItem or self:GetSlot(strSlot) == strItem then
		if tblItemTable.Set && self:HasSet(tblItemTable.Set) then
			local tblSetTable = EquipmentSetTable(tblItemTable.Set)
			self:ApplyBuffTable(tblSetTable.Buffs, -1)
		end
		self.Data.Paperdoll[strSlot] = nil
		self:ApplyBuffTable(tblItemTable.Buffs, -1)
	else
		if self:GetSlot(strSlot) then
			if ItemTable(self:GetSlot(strSlot)).Set && self:HasSet(ItemTable(self:GetSlot(strSlot)).Set) then
				local tblSetTable = EquipmentSetTable(ItemTable(self:GetSlot(strSlot)).Set)
				self:ApplyBuffTable(tblSetTable.Buffs, -1)
			end
			self:ApplyBuffTable(ItemTable(self:GetSlot(strSlot)).Buffs, -1)
		end
		self.Data.Paperdoll[strSlot] = strItem
		if tblItemTable.Set && self:HasSet(tblItemTable.Set) then
			local tblSetTable = EquipmentSetTable(tblItemTable.Set)
			self:ApplyBuffTable(tblSetTable.Buffs)
		end
		self:ApplyBuffTable(tblItemTable.Buffs)
	end
	if SERVER then
		SendUsrMsg("UD_UpdatePapperDoll", player.GetAll(), {self, strSlot, self:GetSlot(strSlot)})
	end
	if CLIENT && GAMEMODE.ItemEditor then
		GAMEMODE.ItemEditor:UpdateSellectors(strSlot)
		print("TESTEST")
	end
end

function Player:GetSlot(strSlot)
	if self.Data && self.Data.Paperdoll && self.Data.Paperdoll[strSlot] then return self.Data.Paperdoll[strSlot] end
	return
end

if CLIENT then
	GM.PapperDollEnts = {}
	function UpdatePapperDollUsrMsg(usrMsg)
		local plyPlayer = usrMsg:ReadEntity()
		if !ValidEntity(plyPlayer) then return end
		local strSlot = usrMsg:ReadString()
		local strItem = usrMsg:ReadString()
		if strItem == "" then strItem = nil end
		plyPlayer:SetPaperDoll(strSlot, strItem)
		plyPlayer:PapperDollBuildSlot(strSlot, strItem)
		if plyPlayer == LocalPlayer() && GAMEMODE.MainMenu then
			GAMEMODE.MainMenu.InventoryTab:LoadInventory()
		end
	end
	usermessage.Hook("UD_UpdatePapperDoll", UpdatePapperDollUsrMsg)
	
	function Player:PapperDollBuildSlot(strSlot, strItem)
		GAMEMODE.PapperDollEnts[self:EntIndex()] = GAMEMODE.PapperDollEnts[self:EntIndex()] or {}
		local tblPlayerTable = GAMEMODE.PapperDollEnts[self:EntIndex()]
		tblPlayerTable = tblPlayerTable or {}
		local entPapperDollEnt = tblPlayerTable[strSlot]
		if entPapperDollEnt && entPapperDollEnt:IsValid() then
			for _, kid in pairs(entPapperDollEnt.Children or {}) do SafeRemoveEntity(kid) end
			SafeRemoveEntity(entPapperDollEnt)
			GAMEMODE.PapperDollEnts[self:EntIndex()][strSlot] = nil
		end
		if strItem && strSlot then
			local tblItemTable = ItemTable(strItem)
			local tblSlotTable = SlotTable(strSlot)
			if tblItemTable && tblSlotTable then
				local entNewPart = GAMEMODE:BuildModel(tblItemTable.Model)
				entNewPart:SetParent(self)
				entNewPart.Item = strItem
				entNewPart.Attachment = tblSlotTable.Attachment
				GAMEMODE.PapperDollEnts[self:EntIndex()][strSlot] = entNewPart
			end
		end
	end
	
	local function DrawPapperDoll()
		if LocalPlayer() && !LocalPlayer().Data then LocalPlayer().Data = {} end
		if LocalPlayer() && LocalPlayer().Data && !LocalPlayer().Data.Paperdoll then LocalPlayer().Data.Paperdoll = {} end
		local plyPlayer = LocalPlayer()
		for intEntID, tblPlayerTable in pairs(GAMEMODE.PapperDollEnts) do
			for strSlot, entTarget in pairs(tblPlayerTable or {}) do
				local boolIsBeingEdited = GAMEMODE.ItemEditorSettings.CurrentEditingSlot && GAMEMODE.ItemEditorSettings.CurrentEditingSlot == strSlot
				local tblItemTable = ItemTable(entTarget.Item)
				if tblItemTable then
					local tblAttachment = plyPlayer:GetAttachment(plyPlayer:LookupAttachment(entTarget.Attachment))
					if !tblAttachment then
						local vecBonePostion, angBoneAngle = plyPlayer:GetBonePosition(plyPlayer:LookupBone(entTarget.Attachment))
						tblAttachment = {Pos = vecBonePostion, Ang = angBoneAngle}
					end
					if tblAttachment then
						local angAddAngle = tblItemTable.Model[1].Angle
						if boolIsBeingEdited && GAMEMODE.ItemEditorSettings.CurrentEditingItemModel == 1 then angAddAngle = GAMEMODE.ItemEditorSettings.CurrentEditingAngle end
						entTarget:SetAngles(tblAttachment.Ang)
						entTarget:SetAngles(entTarget:LocalToWorldAngles(angAddAngle))
						local vecAddVector = tblItemTable.Model[1].Position
						if boolIsBeingEdited && GAMEMODE.ItemEditorSettings.CurrentEditingItemModel == 1 then vecAddVector = GAMEMODE.ItemEditorSettings.CurrentEditingVector end
						entTarget:SetPos(tblAttachment.Pos)
						entTarget:SetPos(entTarget:LocalToWorld(vecAddVector))
						if boolIsBeingEdited && GAMEMODE.ItemEditorSettings.CurrentEditingMat && GAMEMODE.ItemEditorSettings.CurrentEditingItemModel == 1 then
							entTarget:SetMaterial(GAMEMODE.ItemEditorSettings.CurrentEditingMat)
						end
						if boolIsBeingEdited && GAMEMODE.ItemEditorSettings.CurrentEditingScale && GAMEMODE.ItemEditorSettings.CurrentEditingItemModel == 1 then
							entTarget:SetModelScale(GAMEMODE.ItemEditorSettings.CurrentEditingScale)
						end
					end
					for k, kid in pairs(entTarget.Children or {}) do
						if boolIsBeingEdited && GAMEMODE.ItemEditorSettings.CurrentEditingItemModel == k + 1 then
							local vecAddVector = GAMEMODE.ItemEditorSettings.CurrentEditingVector
							local angAddAngle = GAMEMODE.ItemEditorSettings.CurrentEditingAngle
							kid:SetAngles(entTarget:GetAngles())
							kid:SetAngles(kid:LocalToWorldAngles(angAddAngle))
							kid:SetPos(entTarget:GetPos())
							kid:SetPos(kid:LocalToWorld(vecAddVector))
							if GAMEMODE.ItemEditorSettings.CurrentEditingMat then
								kid:SetMaterial(GAMEMODE.ItemEditorSettings.CurrentEditingMat)
							end
							if GAMEMODE.ItemEditorSettings.CurrentEditingScale then
								kid:SetModelScale(GAMEMODE.ItemEditorSettings.CurrentEditingScale)
							end
						end
					end
				end
			end
		end
	end
	hook.Add("Tick", "DrawPapperDoll", DrawPapperDoll)
end

function GM:BuildModel(tblModelTable)
	local tblLoopTable = tblModelTable
	if type(tblModelTable) == "string" then
		tblLoopTable = {}
		tblLoopTable[1] = {Model = tblModelTable, Position = Vector(0, 0, 0), Angle = Angle(0, 0, 0)}
	end
	local entReturnEnt = nil
	local entNewPart = nil
	for key, tblModelInfo in pairs(tblLoopTable) do
		entNewPart = ents.Create("prop_physics")
		if SERVER && (!util.IsValidProp(tblModelInfo.Model) or entReturnEnt) then
			entNewPart:Remove()
			entNewPart = ents.Create("prop_dynamic")
		end
		entNewPart:SetModel(tblModelInfo.Model)
		if entReturnEnt then entNewPart:SetAngles(entReturnEnt:GetAngles()) end
		if entReturnEnt then entNewPart:SetAngles(entNewPart:LocalToWorldAngles(tblModelInfo.Angle)) end
		if !entReturnEnt then entNewPart:SetAngles(tblModelInfo.Angle) end
		if entReturnEnt then entNewPart:SetPos(entReturnEnt:GetPos()) end
		if entReturnEnt then entNewPart:SetPos(entNewPart:LocalToWorld(tblModelInfo.Position)) end
		if !entReturnEnt then entNewPart:SetPos(tblModelInfo.Position) end
		entNewPart:SetParent(entReturnEnt)
		if SERVER then entNewPart:SetCollisionGroup(COLLISION_GROUP_WORLD) end
		if tblModelInfo.Material then entNewPart:SetMaterial(tblModelInfo.Material) end
		if tblModelInfo.Color then entNewPart:SetColor(tblModelInfo.Color.r, tblModelInfo.Color.g, tblModelInfo.Color.b, tblModelInfo.Color.a) end
		if tblModelInfo.Scale then
			if CLIENT then
				entNewPart:SetModelScale(tblModelInfo.Scale)
			else
				entNewPart:SetServerScale(tblModelInfo.Scale)
			end
		end
		entNewPart:Spawn()
		if entReturnEnt then
			entReturnEnt.Children = entReturnEnt.Children or {}
			table.insert(entReturnEnt.Children, entNewPart)
		end
		if !entReturnEnt then entReturnEnt = entNewPart end
	end
	return entReturnEnt
end