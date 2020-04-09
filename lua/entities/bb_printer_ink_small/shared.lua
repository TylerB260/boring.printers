ENT.Type = "anim"
ENT.Base = "bb_printer_base"
ENT.PrintName = "Ink - 1000 mL"
ENT.Author = "Tyler B."
ENT.Spawnable = true
ENT.AdminSpawnable = true

ENT.Model = "models/props_lab/jar01a.mdl"

ENT.PrinterInfo = { -- per second
	type = "item",
	
	health = {
		max = 10,
		rate = 0.1 -- regen
	},
	
	ink = {
		max = 1000,
		rate = 5
	}
}