AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")

include("shared.lua")

function ENT:Initialize() -- spawn
	self:SetModel("models/props/cs_assault/wall_vent.mdl")
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
	if not self.used and ent.PrinterStats and ent:GetStat("heat") > 0 and ent:GetStat("fan") == 0  then -- its a printer
		self.used = true
		ent:FixFan()
		self:Remove()
	end
	
	self:PhysWake()
end
