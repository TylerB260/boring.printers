ENT.Type = "anim"
ENT.Base = "bb_printer_base"
ENT.PrintName = "Paper - 500 Sheets"
ENT.Author = "Tyler B."
ENT.Spawnable = true
ENT.AdminSpawnable = true

ENT.PrinterInfo = { -- per second
	health = {
		max = 100,
		rate = 0.1 -- regen
	},
	
	paper = {
		max = 500,
		rate = 3 -- 2.5 is icky
	}
}