ENT.Type = "anim"
ENT.Base = "bb_printer_base"
ENT.PrintName = "Gun Lab"
ENT.Author = "Tyler B."
ENT.Spawnable = false
ENT.AdminSpawnable = true

ENT.PrinterInfo = { -- per second
	health = {
		max = 100,
		rate = 0.1 -- regen
	}
}

function ENT:SetupDataTables()
	self:NetworkVar("Entity", 0, "owning_ent")
end

function ENT:GetDealer()
	if self.CPPIGetOwner then return self:CPPIGetOwner() end
	if self.Getowning_ent then return self:Getowning_ent() end
	
	return false
end
