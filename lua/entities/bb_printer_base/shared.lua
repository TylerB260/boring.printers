ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Base"
ENT.Author = "Tyler B."
ENT.Spawnable = false
ENT.AdminSpawnable = false

game.AddParticles("particles/fire_01.pcf")
PrecacheParticleSystem("fire_jet_01")

ENT.Model = "models/props_c17/consolebox03a.mdl"
ENT.PrinterInfo = { -- per second
	type = "printer",

	health = {
		max = 100,
		rate = 0.1 -- regen
	}
}

function ENT:GetStat(name)
	if !self.PrinterStats[name] then return 0 end
	return math.Round(self.PrinterStats[name], 2)
end

function ENT:GetStatMax(name)
	if !self.PrinterInfo[name] then return 0 end
	if !self.PrinterInfo[name].max then return 0 end
	return self.PrinterInfo[name].max
end

function ENT:GetRate(name)
	if !self.PrinterInfo[name] then return 0 end
	if !self.PrinterInfo[name].rate then return 0 end
	return self.PrinterInfo[name].rate
end

function ENT:GetButtonPos() return self.PrinterInfo.button and self:LocalToWorld(self.PrinterInfo.button.pos) or false end
function ENT:GetButtonSize() return self.PrinterInfo.button and self.PrinterInfo.button.size or false end
function ENT:GetFanPos() return self.PrinterInfo.fan and self:LocalToWorld(self.PrinterInfo.fan.pos) or false end
function ENT:GetFanSize() return self.PrinterInfo.fan and self.PrinterInfo.fan.size or false end

function ENT:GetRunning()
	if self.PrinterInfo.type != "printer" then return false end
	
	if self:GetStat("speed") == 0 then return false end
	if self:GetStat("paper") < self:GetRate("paper") then return false end
	if self:GetStat("ink") < self:GetRate("ink") then return false end
	if self:GetStat("money") >= self:GetStatMax("money") then return false end

	return true
end
