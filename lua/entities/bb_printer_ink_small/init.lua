AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

function ENT:Touch(ent)
	if not self.lastthink then self.lastthink = 0 end
	
	if ent.PrinterStats and ent.PrinterStats.ink and (CurTime() - self.lastthink == 0 or CurTime() - self.lastthink >= 0.1) then
		if self:GetPos().z > ent:GetPos().z then
			if ent:GetStat("ink") <= ent:GetStatMax("ink") - 1 then
				local avail = math.min(math.ceil(ent:GetStatMax("ink") - ent:GetStat("ink")), math.min(self:GetRate("ink"), self:GetStat("ink")))
				
				self:EmitSound("ambient/water/drip"..math.random(1,4)..".wav", 60, 125)
				self:SetStat("ink", self:GetStat("ink") - avail)
				ent:SetStat("ink", ent:GetStat("ink") + avail)
			end
		
			if self:GetStat("ink") <= 0 then 
				self:Remove()
				return 
			end
		end
		
		self.lastthink = CurTime()
		self:PhysWake()
	end
end