AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")

include("shared.lua")

function ENT:Initialize() -- spawn
	self:SetModel("models/props_junk/cardboard_box003a.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self:PhysWake()
	self:SetTrigger(true)
	
	self.PrinterStats = {}
	
	self:SetStat("health", self:GetStatMax("health"))
	self:SetStat("paper", self:GetStatMax("paper"))
	self.lastthink = 0
end