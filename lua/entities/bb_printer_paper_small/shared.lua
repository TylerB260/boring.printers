ENT.Type = "anim"
ENT.Base = "bb_printer_base"
ENT.PrintName = "Paper - 500 Sheets"
ENT.Author = "Tyler B."
ENT.Spawnable = false
ENT.AdminSpawnable = true

ENT.PrinterInfo = { -- per second
	health = {
		max = 100,
		rate = 0.1 -- regen
	},
	
	paper = {
		max = 500,
		rate = 5
	}
}