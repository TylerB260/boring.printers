ENT.Type = "anim"
ENT.Base = "bb_printer_base"
ENT.PrintName = "Printer - Large"
ENT.Author = "Tyler B."
ENT.Spawnable = true
ENT.AdminSpawnable = true

ENT.Sounds = {
	motor = {path = "ambient/atmosphere/amb_industrial_02.wav", pitch = 100},
	
	start = {path = "ambient/machines/thumper_startup1.wav", pitch = 80},
	stop = {path = "ambient/machines/thumper_shutdown1.wav", pitch = 80},
	
	alert = {path = "npc/attack_helicopter/aheli_damaged_alarm1.wav", pitch = 80},
	use = {path = "buttons/blip1.wav", pitch = 75}
}

ENT.Model = "models/props/CS_militia/furnace01.mdl"

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
		rate = 2
	},
	
	heat = {
		max = 130
	}
}