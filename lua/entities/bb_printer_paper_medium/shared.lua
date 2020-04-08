ENT.Type = "anim"
ENT.Base = "bb_printer_paper_small"
ENT.PrintName = "Paper - 2000 Sheets"
ENT.Author = "Tyler B."
ENT.Spawnable = true
ENT.AdminSpawnable = true

ENT.Model = "models/props_junk/cardboard_box003a.mdl"

ENT.PrinterInfo = { -- per second
	type = "item",
	
	health = {
		max = 100,
		rate = 0.1 -- regen
	},
	
	paper = {
		max = 2000,
		rate = 10
	}
}