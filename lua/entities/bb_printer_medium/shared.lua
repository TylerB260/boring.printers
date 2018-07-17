ENT.Type = "anim"
ENT.Base = "bb_printer_small"
ENT.PrintName = "Printer - Medium"
ENT.Author = "Tyler B."
ENT.Spawnable = true
ENT.AdminSpawnable = true

ENT.Sounds = {
	motor = {path = "ambient/machines/machine2.wav", pitch = 100},
	
	start = {path = "ambient/machines/thumper_startup1.wav", pitch = 100},
	stop = {path = "ambient/machines/thumper_shutdown1.wav", pitch = 100},
	
	alert = {path = "npc/attack_helicopter/aheli_damaged_alarm1.wav", pitch = 100},
	use = {path = "buttons/blip1.wav", pitch = 75}
}

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
		max = 200,
		rate = 0.1 -- regen
	},
	
	paper = {
		max = 2000,
		rate = 1
	},
	
	ink = {
		max = 4000,
		rate = 2
	},
	
	money = {
		max = 1000,
		rate = 3
	},
	
	heat = {
		max = 150
	}
}