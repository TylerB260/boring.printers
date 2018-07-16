include("shared.lua")
include("bb_printer_gui.lua")

net.Receive("bb_printer_update", function()
	local printer = net.ReadEntity()
	local stat = net.ReadString()
	local value = net.ReadDouble()
	
	if IsValid(printer) and printer.PrinterStats then
		printer.PrinterStats[stat] = value
		
		if stat == "speed" and IsValid(printer.CLEnts.button) then
			printer.CLEnts.button:SetPoseParameter("switch", value)
		end
	end
end)

function ENT:Initialize() -- spawn
	self:SetModel("models/props_c17/consolebox03a.mdl")
	
	self.PrinterStats = {}
end

function ENT:GetDistance()
	if not LocalPlayer() then return 384 end
	
	return LocalPlayer():GetPos():Distance(self:GetPos())
end
