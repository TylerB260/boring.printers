ENT.Type = "anim"
ENT.Base = "bb_printer_ink_small"
ENT.PrintName = "Ink - 10000 mL"
ENT.Author = "Tyler B."
ENT.Spawnable = true
ENT.AdminSpawnable = true

ENT.PrinterInfo = { -- per second
	health = {
		max = 100,
		rate = 0.1 -- regen
	},
	
	ink = {
		max = 10000,
		rate = 50
	}
}