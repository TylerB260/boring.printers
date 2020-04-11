AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

function ENT:Initialize()
	self.BaseClass.Initialize(self)
	self:GetPhysicsObject():SetMass(250)
end