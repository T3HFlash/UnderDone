local tblFAQ = {}
PANEL = {}
function PANEL:Init()
	self.HelpList = CreateGenericList(self, 2, false, true)
	self:CreateHelp()
	self:LoadHelp()
end

function PANEL:PerformLayout()
	self.HelpList:SetSize(self:GetWide(), self:GetTall())
end

function PANEL:CreateHelp()
	tblFAQ[1] = {Text = "What is this?", Color = clrWhite}
	tblFAQ[2] = {Text = "This is the Underdone Development Kit or UDK", Color = clrDrakGray}
end

function PANEL:LoadHelp()
	self.HelpList:AddItem(CreateGenericLabel(nil, "MenuLarge", "Welcome to the UDK Help Menu", clrWhite))
	for _, tblTextInfo in pairs(tblFAQ) do
		self.HelpList:AddItem(CreateGenericLabel(nil, nil, tblTextInfo.Text, tblTextInfo.Color))
	end
end
vgui.Register("helptab", PANEL, "Panel")



