ENT.Type = "anim"
ENT.Base = "bb_printer_base"
ENT.PrintName = "Printer - Small"
ENT.Author = "Tyler B."
ENT.Spawnable = true
ENT.AdminSpawnable = true

ENT.Sounds = {
	motor = {path = "npc/scanner/combat_scan_loop2.wav", pitch = 100},
	
	start = {path = "npc/scanner/combat_scan2.wav", pitch = 100},
	stop = {path = "npc/scanner/combat_scan3.wav", pitch = 100},
	
	alert = {path = "npc/scanner/scanner_explode_crash2.wav", pitch = 100},
	full = {path = "npc/scanner/scanner_scan2.wav", pitch = 100},
	use = {path = "buttons/button16.wav", pitch = 75}
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