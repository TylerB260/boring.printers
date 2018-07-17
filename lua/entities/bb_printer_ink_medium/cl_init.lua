include("shared.lua")

function ENT:Initialize() -- spawn
	self:SetModel("models/props_junk/metalgascan.mdl")
	self.PrinterStats = {}
end

function ENT:Draw()
	self:DrawModel()
	
	local pos = self:LocalToWorld(Vector(4.1, -6.5, 7));
	local ang = self:GetAngles()
	ang:RotateAroundAxis(ang:Forward(), 90)
	ang:RotateAroundAxis(ang:Right(), 270)
	
	cam.Start3D2D(pos, ang, 0.25)
		if self:GetDistance() < 256 then
			-- ink --
			self:drawRect(2, 2, 48, 69)
			self:drawBar(4, 4, 44, 66, (self:GetStat("ink") / self:GetStatMax("ink")) * 100)
			
			draw.DrawText("Ink", "TargetIDSmall", 25, 6, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)   
			draw.DrawText(math.floor(self:GetStat("ink")), "TargetID", 25, 41, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)   
			draw.DrawText("mL", "TargetIDSmall", 25, 53, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)   
			self.self:drawIcon("icon16/water.png", 26, 31, 16, 16)
		end
	cam.End3D2D()
end

