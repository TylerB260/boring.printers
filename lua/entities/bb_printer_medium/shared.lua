ENT.Type = "anim"
ENT.Base = "bb_printer_base"
ENT.PrintName = "Printer - Medium"
ENT.Author = "Tyler B."
ENT.Spawnable = true
ENT.AdminSpawnable = true

ENT.Sounds = {
	motor = {path = "ambient/machines/power_transformer_loop_2.wav", pitch = 90},
	
	start = {path = "npc/roller/mine/rmine_reprogram.wav", pitch = 100},
	stop = {path = "npc/roller/code2.wav", pitch = 100},
	
	alert = {path = "npc/roller/mine/rmine_shockvehicle2.wav", pitch = 100},
	full = {path = "npc/roller/mine/rmine_blip1.wav", pitch = 100},
	use = {path = "buttons/blip1.wav", pitch = 75}
}

ENT.Model = "models/props_c17/consolebox01a.mdl"

ENT.PrinterInfo = { -- per second
	button = {
		pos = Vector(14.5, 6.4, 5.5),
		size = 5
	},
	
	fan = {
		pos = Vector(16.2, 12, 5.5),
		size = 5
	},
	
	health = {
		max = 100,
		rate = 0.2 -- regen
	},
	
	paper = {
		max = 2000,
		rate = 2
	},
	
	ink = {
		max = 4000,
		rate = 4
	},
	
	money = {
		max = 2000,
		rate = 4
	},
	
	heat = {
		max = 125
	}
}