AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")

include("shared.lua")

function ENT:Initialize()
	self.BaseClass.Initialize(self)
	self:GetPhysicsObject():SetMass(50)
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