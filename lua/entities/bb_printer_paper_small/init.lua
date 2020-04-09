AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

function ENT:Touch(ent)
	if not self.lastthink then self.lastthink = 0 end
	
	if ent.PrinterStats and ent.PrinterStats.paper and (CurTime() - self.lastthink == 0 or CurTime() - self.lastthink >= 0.1) then
		if self:GetPos().z > ent:GetPos().z then
			if ent:GetStat("paper") <= ent:GetStatMax("paper") - 1 then
				local avail = math.min(math.ceil(ent:GetStatMax("paper") - ent:GetStat("paper")), math.min(self:GetRate("paper"), self:GetStat("paper")))
				
				self:EmitSound("items/itempickup.wav", 60)
				self:SetStat("paper", self:GetStat("paper") - avail)
				ent:SetStat("paper", ent:GetStat("paper") + avail)
			end
			
			if self:GetStat("paper") <= 0 then 
				self:Remove()
				return 
			end
		end
			
		self.lastthink = CurTime()
		self:PhysWake()
	end
end