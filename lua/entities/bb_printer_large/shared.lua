ENT.Type = "anim"
ENT.Base = "bb_printer_base"
ENT.PrintName = "Printer - Large"
ENT.Author = "Tyler B."
ENT.Spawnable = true
ENT.AdminSpawnable = true

ENT.Sounds = {
	motor = {path = "ambient/machines/thumper_amb.wav", pitch = 100},
	
	start = {path = "ambient/machines/thumper_startup1.wav", pitch = 100},
	stop = {path = "ambient/machines/thumper_shutdown1.wav", pitch = 100},
	
	alert = {path = "npc/attack_helicopter/aheli_damaged_alarm1.wav", pitch = 80},
	full = {path = "buttons/combine_button3.wav", pitch = 100},
	use = {path = "buttons/button17.wav", pitch = 50}
}

ENT.Model = "models/props/CS_militia/furnace01.mdl"

ENT.PrinterInfo = { -- per second
	button = {
		pos = Vector(14, 0, 28.5),
		size = 12
	},
	
	fan = {
		pos = Vector(15.5, 0, 61.25),
		size = 16
	},
	
	health = {
		max = 150,
		rate = 0.3 -- regen
	},
	
	paper = {
		max = 5000,
		rate = 5
	},
	
	ink = {
		max = 10000,
		rate = 10
	},
	
	money = {
		max = 5000,
		rate = 10
	},
	
	heat = {
		max = 130
	}
}