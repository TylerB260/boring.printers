AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")

include("shared.lua")

function ENT:Touch(ent)
    if not IsValid(ent) then return end
    
    if ent.BrokenFan then
		ent:SetNWBool("BrokenFan", false)
		ent.BrokenFan = false
		
		ent:EmitSound("ambient/machines/pneumatic_drill_"..math.random(1,4)..".wav", 80, 100)
		
		self:Remove()
	end
end

function ENT:OnRemove()
    --if IsValid(self.paper) then
        --self.paper:Remove()
    --end
end