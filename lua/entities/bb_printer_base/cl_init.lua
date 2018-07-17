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

function ENT:drawRect(x, y, w, h)
	surface.SetDrawColor(Color(255, 255, 255)) -- white "trim"
	surface.DrawOutlinedRect(x, y , w, h)
	
	surface.SetDrawColor(Color(200, 200, 200)) -- gray "trim"
	surface.DrawOutlinedRect(x + 1, y + 1, w - 2, h - 2)

	surface.SetDrawColor(Color(80, 80, 80)) -- gray inside
	surface.DrawRect(x + 2, y + 2, w - 4, h - 4)    
end

local matcache = {}

function ENT:drawIcon(icon, x, y, w, h)
	if !matcache[icon] then matcache[icon] = Material(icon) end

	surface.SetDrawColor(Color(255, 255, 255))
	surface.SetMaterial(matcache[icon])
	surface.DrawTexturedRect(x - (w / 2), y - (h / 2), w, h)
end

function ENT:drawBar(x, y, w, h, percent, mode)
	-- function takes top left for x, but technically draws from bottom.
	local mode = mode or "redgreen"
	local col = Color(255, 0, 255)
	
	percent = math.min(100, math.max(0, percent))
	
	if mode == "redgreen" then
		col = HSVToColor(math.min(math.max(percent - 30, 0), 60) * 2, 0.8, 0.8)
		
		if percent <= 25 then
			-- flash instead --
			col = (math.Round(CurTime() % 1) == 1) and col or Color(col.r / 2, col.g / 2, col.b / 2)
		end
	elseif mode == "redblue" then
		col = HSVToColor(360 - math.min(math.max(percent - 30, 0), 60) * 2, 0.8, 0.8)
		
		if percent <= 25 then
			col = (math.Round(CurTime() % 1) == 1) and col or Color(col.r / 2, col.g / 2, col.b / 2)
		end
	elseif mode == "greenred" then
		col = HSVToColor(120 - (math.min(math.max(percent - 30, 0), 60) * 2), 0.8, 0.8)
	
		if percent >= 75 then
			col = (math.Round(CurTime() % 1) == 1) and col or Color(col.r / 2, col.g / 2, col.b / 2) -- faster!
		end
	elseif mode == "green" then
		col = Color(0, 100 + (percent * 1), 0)
	end
	
	if percent == 0 and (mode == "redgreen" or mode == "redblue") then percent = 100 end
	
	local realy = y + (h * ((100 - percent) / 100))
	local realh = h * (percent / 100)
	
	surface.SetDrawColor(col)
	surface.DrawRect(x, realy, w, realh)    
end