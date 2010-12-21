local ENT = FindMetaTable("Entity")

function ENT:IsBuilding()
	if self:GetClass() ==  "prop_physics" then return true end
	return false
end

function ENT:IsPet()
	if self:IsNPC() && self:GetOwner() && self:GetOwner():IsPlayer() then
		return true
	end
	return false
end

function ENT:Idle()
	self:SetNPCState( NPC_STATE_IDLE )
	if self:IsCurrentSchedule( SCHED_FORCED_GO ) then
		self:SetSchedule( IDLE_STAND )
	end
	if self:GetEnemy() then
		self:SetEnemy( nil )
	end
	if self:IsFollowing() then
		self.IsFollowing = false
	end
	self:StopMoving()
	self:TaskComplete()
end

function ENT:IsIdle()
	if self:GetNPCState() == NPC_STATE_IDLE && !self:GetEnemy() then
		if self:IsCurrentSchedule( IDLE_STAND )  then
			return true
		end
	end
	return false
end

function ENT:Follow(Ent)
	self:Idle()
	self:SetLastPosition( Ent:GetPos() + Vector(math.random(10,30),math.random(10,30),0) )
	self:SetSchedule( SCHED_FORCED_GO )
	self.IsFollowing = true
end

function ENT:IsFollowing()
	if self.IsFollowing then
		return true
	end
	return false
end

function ENT:ReturnSpawn()
	self:Idle()
	if self.Position then
		self:SetLastPosition( self.Position )
		self:SetSchedule( SCHED_FORCED_GO )
	end
end

function ENT:AttackEnemy(Enemy)
	self:SetEnemy( Enemy )
	self:SetNPCState( NPC_STATE_COMBAT )
	self:SetLastPosition( Enemy:GetPos() )
	self:SetSchedule( SCHED_FORCED_GO )
end

function ENT:IsBlocked()
	if ValidEntity(self:GetBlockingEntity()) && self:GetBlockingEntity()then
		return self:GetBlockingEntity()
	end
	return false
end

if SERVER then
	function ENT:SetServerScale(vecScale)
		for _, ply in pairs(player.GetAll()) do
			ply:ConCommand("UD_SetEtityScale " .. self:EntIndex() .. " " .. StringatizeVector(vecScale))
		end
	end
end
if CLIENT then
	concommand.Add("UD_SetEtityScale", function(ply, command, args)
		local entEtity = ents.GetByIndex(args[1])
		local vecScale = VectortizeString(args[2])
		if ValidEntity(entEtity) && vecScale then
			entEtity:SetModelScale(vecScale)
		end
	end)
end
