ENT.Type = "anim"
ENT.Base = "bb_printer_base"
ENT.PrintName = "Replacement Fan"
ENT.Author = "Tyler B."
ENT.Spawnable = true
ENT.AdminSpawnable = true

ENT.Model = "models/props/cs_assault/wall_vent.mdl"

ENT.PrinterInfo = { -- per second
	type = "item",
	
	health = {
		max = 100,
		rate = 0.1 -- regen
	}
}
