ENT.Type = "anim"
ENT.Base = "bb_printer_base"
ENT.PrintName = "Ink - 500 mL"
ENT.Author = "Tyler B."
ENT.Spawnable = false
ENT.AdminSpawnable = true

ENT.PrinterInfo = { -- per second
	health = {
		max = 100,
		rate = 0.1 -- regen
	},
	
	ink = {
		max = 1000,
		rate = 10
	}
}