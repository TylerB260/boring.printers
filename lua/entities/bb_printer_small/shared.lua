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

ENT.PrinterInfo = { -- per second
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

function ENT:GetButtonPos() return self:LocalToWorld(self.PrinterInfo.button.pos) end
function ENT:GetButtonSize() return self.PrinterInfo.button.size end
function ENT:GetFanPos() return self:LocalToWorld(self.PrinterInfo.fan.pos) end
function ENT:GetFanSize() return self.PrinterInfo.fan.size end

function ENT:GetRunning()
	if self:GetStat("speed") == 0 then return false end
	if self:GetStat("paper") < self:GetRate("paper") then return false end
	if self:GetStat("ink") < self:GetRate("ink") then return false end
	if self:GetStat("money") >= self:GetStatMax("money") then return false end

	return true
end
