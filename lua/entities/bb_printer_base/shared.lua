ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Base"
ENT.Author = "Tyler B."
ENT.Spawnable = false
ENT.AdminSpawnable = false

ENT.PrinterInfo = {}

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