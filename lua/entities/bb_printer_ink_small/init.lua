AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")

include("shared.lua")

function ENT:Initialize() -- spawn
	self:SetModel("models/props_lab/jar01a.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self:PhysWake()
	self:SetTrigger(true)
	
	self.PrinterStats = {}
	
	self:SetStat("health", self:GetStatMax("health"))
	self:SetStat("ink", self:GetStatMax("ink"))
	self.lastthink = 0
end

function ENT:OnTakeDamage(dmg)
	self:SetStat("health", self:GetStat("health") - (dmg:GetDamage() or 0))
	
	if self:GetStat("health") <= 0 then
		sound.Play("physics/metal/metal_barrel_impact_hard"..math.random(1,7)..".wav", self:GetPos(), 80)
		self:Remove()
	end
end

function ENT:Touch(ent)
	if ent.PrinterStats and ent.PrinterStats.ink and (CurTime() - self.lastthink == 0 or CurTime() - self.lastthink >= 0.1) then
		if self:GetPos().z > ent:GetPos().z then
			-- print(ent:GetStat("ink").." / "..self:GetRate("ink"))
			if ent:GetStat("ink") <= ent:GetStatMax("ink") - 1 then
				local avail = math.min(math.ceil(ent:GetStatMax("ink") - ent:GetStat("ink")), math.min(self:GetRate("ink"), self:GetStat("ink")))
				
				if avail <= 0 then 
					self:Remove()
					return 
				end
				
				self:EmitSound("ambient/water/drip"..math.random(1,4)..".wav", 60, 125)
				self:SetStat("ink", self:GetStat("ink") - avail)
				ent:SetStat("ink", ent:GetStat("ink") + avail)
			end
		end
		
		self.lastthink = CurTime()
		self:PhysWake()
	end
end

function ENT:Think()
	if self:GetStat("ink") <= 0 then 
		self:Remove()
		return 
	end
	
	self.BaseClass:Think()
end