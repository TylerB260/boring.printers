ENT.Type = "anim"
ENT.Base = "bb_printer_ink_small"
ENT.PrintName = "Ink - 10000 mL"
ENT.Author = "Tyler B."
ENT.Spawnable = true
ENT.AdminSpawnable = true

ENT.Model = "models/props_c17/oildrum001.mdl"

ENT.PrinterInfo = { -- per second
	type = "item",
	
	health = {
		max = 50,
		rate = 0.5 -- regen
	},
	
	ink = {
		max = 10000,
		rate = 50
	}
}