ENT.Type = "anim"
ENT.Base = "bb_printer_ink_small"
ENT.PrintName = "Ink - 4000 mL"
ENT.Author = "Tyler B."
ENT.Spawnable = true
ENT.AdminSpawnable = true

ENT.Model = "models/props_junk/metalgascan.mdl"

ENT.PrinterInfo = { -- per second
	type = "item",
	
	health = {
		max = 100,
		rate = 0.1 -- regen
	},
	
	ink = {
		max = 4000,
		rate = 20
	}
}