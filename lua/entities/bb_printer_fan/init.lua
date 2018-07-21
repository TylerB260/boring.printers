AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")

include("shared.lua")

function ENT:Initialize() -- spawn
	self:SetModel("models/props/de_prodigy/fanoff.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self:PhysWake()
	self:SetTrigger(true)
	
	self.PrinterStats = {}
	self:GetPhysicsObject():SetMass(250)
	
	self:SetStat("health", self:GetStatMax("health"))
end

function ENT:Touch(ent)
	if not self.used and ent.PrinterStats and ent:GetStat("heat") > 0 then -- its a printer
		if ent:GetStat("fan") == 0 or ent:GetStat("health") != ent:GetStatMax("health") then
			self.used = true
			ent:SetStat("health", ent:GetStatMax("health"))
			ent:FixFan()
			self:Remove()
		end
	end
	
	self:PhysWake()
end

function ENT:OnTakeDamage(dmg)
	self:SetStat("health", self:GetStat("health") - (dmg:GetDamage() or 0))
	
	if self:GetStat("health") <= 0 then
		sound.Play("physics/plastic/plastic_box_impact_bullet"..math.random(1,5)..".wav", self:GetPos(), 80)
		self:Remove()
	end
end