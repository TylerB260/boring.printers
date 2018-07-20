AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")

include("shared.lua")

function ENT:Initialize() -- spawn
	self:SetModel("models/props/CS_militia/furnace01.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self:PhysWake()
	
	self.PrinterStats = {}
	
	self:SetStat("paper", 0)
	self:SetStat("ink", 0)
	self:SetStat("money", 0)
	self:SetStat("heat", 22)
	
	self:SetStat("health", self:GetStatMax("health"))
	self:SetStat("speed", 0)
	self:SetStat("fan", 1)
	
	self:GetPhysicsObject():SetMass(250)
	
	timer.Simple(0, function()
		if IsValid(self) then self:BroadcastUpdate() end
		if IsValid(self.smoke) then self.smoke:Remove() end
	end)
end