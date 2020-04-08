ENT.Type = "anim"
ENT.Base = "bb_printer_base"
ENT.PrintName = "Gun Lab"
ENT.Author = "Tyler B."
ENT.Spawnable = false
ENT.AdminSpawnable = true

ENT.Model = "models/props_c17/TrapPropeller_Engine.mdl"

ENT.PrinterInfo = { -- per second
	type = "item",
	
	health = {
		max = 100,
		rate = 0.1 -- regen
	}
}

function ENT:SetupDataTables()
	self:NetworkVar("Entity", 0, "owning_ent")
end

function ENT:CalculatePrice(shipment)
	if shipment.separate then return shipment.pricesep end
	return shipment.price / shipment.amount
end

function ENT:GetDealer()
	if self.CPPIGetOwner and self:CPPIGetOwner():IsPlayer() then return self:CPPIGetOwner() end
	if self.Getowning_ent then return self:Getowning_ent() end
	
	return false
end
