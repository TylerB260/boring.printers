ENT.Type = "anim"
ENT.Base = "bb_printer_small"
ENT.PrintName = "Printer - Large"
ENT.Author = "Tyler B."
ENT.Spawnable = false
ENT.AdminSpawnable = true

ENT.Sounds = {
	motor = {path = "ambient/machines/thumper_amb.wav", pitch = 100},
	
	start = {path = "ambient/machines/thumper_startup1.wav", pitch = 80},
	stop = {path = "ambient/machines/thumper_shutdown1.wav", pitch = 80},
	
	alert = {path = "npc/attack_helicopter/aheli_damaged_alarm1.wav", pitch = 80},
	use = {path = "buttons/blip1.wav", pitch = 75}
}

ENT.PrinterInfo = { -- per second
	button = {
		pos = Vector(14, 0, 28.5),
		size = 16
	},
	
	fan = {
		pos = Vector(15.5, 0, 61.25),
		size = 16
	},
	
	health = {
		max = 300,
		rate = 0.1 -- regen
	},
	
	paper = {
		max = 5000,
		rate = 2
	},
	
	ink = {
		max = 10000,
		rate = 4
	},
	
	money = {
		max = 5000,
		rate = 5
	},
	
	heat = {
		max = 150
	}
}