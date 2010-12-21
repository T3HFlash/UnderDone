--Dont mess with this stuff its just for compatability
SWEP.WorldModel	= "models/weapons/w_pistol.mdl"
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
------------------------------------------------------

function SWEP:Initialize()
end

function SWEP:OnRemove()
	if SERVER then
		if self.WeaponTable && self.WeaponTable.AmmoType != "none" then
			self.Owner:GiveAmmo(self:Clip1(), self.WeaponTable.AmmoType)
		end
	end
end

function SWEP:SetWeapon(tblWeapon)
	if tblWeapon then
		self.WeaponTable = tblWeapon
		self:SetNWString("item", self.WeaponTable.Name)
		self:SetWeaponHoldType(self.WeaponTable.HoldType)
		return true
	end
	return false
end

function SWEP:Think()
	if self.Item != self:GetNWString("item") then
		self.Item = self:GetNWString("item")
		self.WeaponTable = GAMEMODE.DataBase.Items[self.Item] or {}
		if self.WeaponTable.AmmoType && self.WeaponTable.AmmoType != "none" then
			self:SetClip1(0)
			self:Reload()
		end
	end
end

function SWEP:Reload()
	if self:GetNWBool("reloading") == true then return false end
	local strAmmoType = self.WeaponTable.AmmoType
	local intClipSize = self.WeaponTable.ClipSize
	local intCurrentAmmo = self.Owner:GetAmmoCount(strAmmoType)
	if strAmmoType != "none" && self:Clip1() < self.WeaponTable.ClipSize && intCurrentAmmo > 0 then
		self:SetNWBool("reloading", true)
		self:SetNextPrimaryFire(CurTime() + 1.5)
		if SERVER then GAMEMODE:SetPlayerAnimation(self.Owner, PLAYER_RELOAD) end
		if (SinglePlayer() && SERVER) or (!SinglePlayer() && CLIENT) then
			if self.WeaponTable.ReloadSound then self:EmitSound(self.WeaponTable.ReloadSound) end
		end
		timer.Simple(1.5, function()
			if !self or !self.Owner or !self.Owner:Alive() then return end
			self.Owner:RemoveAmmo(self.WeaponTable.ClipSize - self:Clip1(), self.WeaponTable.AmmoType)
			self:SetClip1(math.Clamp(self.WeaponTable.ClipSize, 0, self:Clip1() + intCurrentAmmo))
			self:SetNWBool("reloading", false)
		end)
	end
end

function SWEP:PrimaryAttack()
	if self:Clip1() != 0 then
		self:WeaponAttack()
	else
		self:Reload()
	end
end

function SWEP:SecondaryAttack()
	local IsSniper = self.WeaponTable.HoldType == "crossbow"
	if IsSniper then
		if (!Zoomed) then
			Zoomed = true
			if SERVER then
				self.Owner:SetFOV( 45, 0.3 )
			end
		else 
			Zoomed = false
			if SERVER then
				self.Owner:SetFOV( 0, 0.3 )
			end
		end
	end
end

function SWEP:WeaponAttack()
	if SERVER then 
		self.Owner:RestartGesture(self.Owner:Weapon_TranslateActivity(ACT_HL2MP_GESTURE_RANGE_ATTACK))
	end
	if self.WeaponTable then
		local isMelee = self.WeaponTable.HoldType == "melee"
		local intRange = self.Owner:GetEyeTrace().HitPos:Distance(self.Owner:GetEyeTrace().StartPos)
		local intMaxRange = 4000
		if isMelee then intMaxRange = 70 end
		local tblBullet = {}
		tblBullet.Src 		= self.Owner:GetShootPos()
		tblBullet.Dir 		= self.Owner:GetAimVector()
		tblBullet.Force		= (self.WeaponTable.Power or 3) / 2
		tblBullet.Spread 	= Vector(self.WeaponTable.Accuracy, self.WeaponTable.Accuracy, 0)
		tblBullet.Num 		= self.WeaponTable.NumOfBullets
		tblBullet.Damage	= self:GetDamage(self.WeaponTable.Power or 3)
		tblBullet.Tracer	= 2
		if isMelee then tblBullet.Tracer = 0 end
		tblBullet.AmmoType	= self.WeaponTable.AmmoType
		if isMelee then tblBullet.AmmoType = "pistol" end
		tblBullet.Callback = function(plyShooter, trcTrace, tblDamageInfo)
			--if tblDamageInfo:GetDamagePosition():Distance(self.Owner:GetPos()) > intMaxRange then tblDamageInfo:SetDamage(0) return false, false end
			self:BulletCallBack(plyShooter, trcTrace, tblDamageInfo)
		end
		if intRange <= intMaxRange then
			self.Owner:FireBullets(tblBullet)
		end
		if SERVER && !isMelee then
			self:SetClip1(self:Clip1() - 1)
		end
		local intFireRate = self:GetFireRate(self.WeaponTable.FireRate)
		if CLIENT && !isMelee && CurTime() >= (self.NextBulletEffect or 0) then
			self.Owner:MuzzleFlash()
			local strEffect = "ShellEject"
			if self.WeaponTable.AmmoType == "buckshot" then strEffect = "ShotgunShellEject" end
			local effectdata = EffectData()
			effectdata:SetOrigin(GAMEMODE.PapperDollEnts[self.Owner:EntIndex()]["slot_primaryweapon"]:GetPos())
			effectdata:SetAngle(GAMEMODE.PapperDollEnts[self.Owner:EntIndex()]["slot_primaryweapon"]:GetAngles() + Angle(0, 90, 0))
			effectdata:SetEntity(self)
			effectdata:SetMagnitude(1)
			effectdata:SetScale(1)
			util.Effect(strEffect, effectdata)
			self.NextBulletEffect = CurTime() + (1 / intFireRate)
		end
		if SERVER then
			self.Owner:SlowDown((1 / intFireRate))
		end
		if (SinglePlayer() && SERVER) or (!SinglePlayer() && CLIENT) then
			self:EmitSound(self.WeaponTable.Sound)
		end
		self:SetNextPrimaryFire(CurTime() + (1 / intFireRate))
	end
end

function SWEP:BulletCallBack(plyShooter, trcTrace, tblDamageInfo)

end

function SWEP:GetDamage(intDamage)
	return intDamage
end

function SWEP:GetFireRate(intFireRate)
	for strStat, tblStatTable in pairs(GAMEMODE.DataBase.Stats) do
		if self.Owner:GetStat(strStat) && tblStatTable.FireRateMod then
			intFireRate = tblStatTable:FireRateMod(self.Owner, self.Owner:GetStat(strStat), intFireRate)
		end
	end
	return intFireRate
end
