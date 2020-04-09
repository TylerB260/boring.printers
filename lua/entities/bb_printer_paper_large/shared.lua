ENT.Type = "anim"
ENT.Base = "bb_printer_paper_small"
ENT.PrintName = "Paper - 5000 Sheets"
ENT.Author = "Tyler B."
ENT.Spawnable = true
ENT.AdminSpawnable = true

ENT.Model = "models/props_junk/cardboard_box001a.mdl"

ENT.PrinterInfo = { -- per second
	type = "item",
	
	health = {
		max = 50,
		rate = 0.5 -- regen
	},
	
	paper = {
		max = 5000,
		rate = 25
	}
}