ENT.Type = "anim"
ENT.Base = "bb_printer_base"
ENT.PrintName = "Printer - Small"
ENT.Author = "Tyler B."
ENT.Spawnable = true
ENT.AdminSpawnable = true

ENT.Sounds = {
	motor = {path = "ambient/machines/combine_shield_loop3.wav", pitch = 125},
	
	start = {path = "ambient/machines/thumper_startup1.wav", pitch = 125},
	stop = {path = "ambient/machines/thumper_shutdown1.wav", pitch = 125},
	
	alert = {path = "npc/attack_helicopter/aheli_damaged_alarm1.wav", pitch = 125},
	use = {path = "buttons/blip1.wav", pitch = 100}
}

ENT.Model = "models/props_c17/consolebox03a.mdl"

ENT.PrinterInfo = { -- per second
	type = "printer",
	
	button = {
		pos = Vector(9.25, 4.65, 4.5),
		size = 3
	},
	
	fan = {
		pos = Vector(9.4, 8.2, 4.6),
		size = 5
	},
	
	health = {
		max = 100,
		rate = 0.1 -- regen
	},
	
	paper = {
		max = 500,
		rate = 0.5
	},
	
	ink = {
		max = 1000,
		rate = 1
	},
	
	money = {
		max = 500,
		rate = 1
	},
	
	heat = {
		max = 120
	}
}