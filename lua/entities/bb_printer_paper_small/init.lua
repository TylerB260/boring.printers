AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")

include("shared.lua")

function ENT:Initialize() -- spawn
	self:SetModel("models/props/cs_office/file_box.mdl")
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

function ENT:OnTakeDamage(dmg)
	self:SetStat("health", self:GetStat("health") - (dmg:GetDamage() or 0))
	sound.Play("physics/cardboard/cardboard_box_break"..math.random(1,3)..".wav", self:GetPos(), 80)
		
	if self:GetStat("health") <= 0 then
		self:Remove()
	end
end

function ENT:Touch(ent)
	if ent.PrinterStats and ent.PrinterStats.paper and (CurTime() - self.lastthink == 0 or CurTime() - self.lastthink >= 0.1) then
		if self:GetPos().z > ent:GetPos().z then
			-- print(ent:GetStat("paper").." / "..self:GetRate("paper"))
			if ent:GetStat("paper") <= ent:GetStatMax("paper") - 1 then
				local avail = math.min(math.ceil(ent:GetStatMax("paper") - ent:GetStat("paper")), math.min(self:GetRate("paper"), self:GetStat("paper")))
				
				if avail <= 0 then 
					self:Remove()
					return 
				end
				
				self:EmitSound("items/itempickup.wav", 60)
				self:SetStat("paper", self:GetStat("paper") - avail)
				ent:SetStat("paper", ent:GetStat("paper") + avail)
			end
		end
		
		self.lastthink = CurTime()
		self:PhysWake()
	end
end

function ENT:Think()
	local hcol = (self:GetStat("health") / self:GetStatMax("health")) * 255
	
	self:SetColor(Color(255, hcol, hcol))
	
	if self:WaterLevel() >= 1 then
		self:TakeDamage( 2, self, self )
	end
	
	if self:GetStat("paper") <= 0 then 
		self:Remove()
		return 
	end
end