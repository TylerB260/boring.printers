include("shared.lua")

function ENT:SpawnCLEnts() -- spawn in fan, button, etc.
	self.CLEnts = self.CLEnts or {}
	self:RemoveCLEnts()

	local fan = ClientsideModel("models/props/cs_assault/wall_vent.mdl")
	fan:SetAngles(self:GetAngles())
	fan:SetPos(self:GetFanPos())
	fan:SetParent(self)
	fan:SetModelScale(0.175, 0)
	
	local button = ClientsideModel("models/maxofs2d/button_slider.mdl")
	local ang = self:GetAngles()
	ang:RotateAroundAxis(ang:Right(), 270)
	button:SetAngles(ang)
	button:SetPos(self:GetButtonPos())
	button:SetParent(self)
	button:SetModelScale(0.375, 0)
	

	self.CLEnts.fan = fan
	self.CLEnts.button = button
	
	self.CLEntsSpawned = true
end

function ENT:Draw()
	self:DrawModel()
	
	if self:GetDistance() > (512 + 64) and self.CLEntsSpawned then self:RemoveCLEnts() end
	if self:GetDistance() < 512 and !self.CLEntsSpawned then self:SpawnCLEnts() end
	
	
	local pos = self:LocalToWorld(Vector(10.2, -10.6, 7.3));
	local ang = self:GetAngles()
	ang:RotateAroundAxis(ang:Forward(), 90)
	ang:RotateAroundAxis(ang:Right(), 270)
	
	self.background = self.background or Material("console/background02")
	
	cam.Start3D2D(pos, ang, 0.075)
		if self:GetDistance() < 1024 then
			surface.SetDrawColor(Color(255, 255, 255, 255)) -- background
			surface.SetMaterial(self.background)
			surface.DrawTexturedRect(0, 0, 285, 74)    
		end
		
		if self:GetDistance() < 512 then
			-- paper --
			self:drawRect(2, 2, 48, 69)
			self:drawBar(4, 4, 44, 66, (self:GetStat("paper") / self:GetStatMax("paper")) * 100)
			
			draw.DrawText("Paper", "TargetIDSmall", 25, 6, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)   
			draw.DrawText(math.floor(self:GetStat("paper")), "TargetID", 25, 41, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)   
			draw.DrawText("pages", "TargetIDSmall", 25, 53, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)   
			self:drawIcon("icon16/page_copy.png", 26, 32, 16, 16)
			
			-- ink --
			self:drawRect(52, 2, 48, 69)
			self:drawBar(54, 4, 44, 66, (self:GetStat("ink") / self:GetStatMax("ink")) * 100, "redblue")
			
			draw.DrawText("Ink", "TargetIDSmall", 75, 6, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)   
			draw.DrawText(math.floor(self:GetStat("ink")), "TargetID", 75, 41, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)   
			draw.DrawText("mL", "TargetIDSmall", 75, 53, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)   
			self:drawIcon("icon16/water.png", 76, 32, 16, 16)
			
			-- cash --
			self:drawRect(102, 2, 48, 69)
			self:drawBar(104, 4, 44, 66, (self:GetStat("money") / self:GetStatMax("money")) * 100, "green")
			
			local pretty = self:GetStat("money") < 1 and (self:GetStat("money") * 100).."¢" or "$"..math.floor(self:GetStat("money"))
			
			draw.DrawText("Cash", "TargetIDSmall", 125, 6, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)   
			draw.DrawText(pretty, "TargetID", 125, 47, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)   
			self:drawIcon("icon16/money.png", 126, 32, 16, 16)
			
			-- temp --
			self:drawRect(152, 2, 34, 69)
			self:drawBar(154, 4, 30, 66, (self:GetStat("heat") / self:GetStatMax("heat")) * 100, "greenred")
			
			draw.DrawText("Tmp", "TargetIDSmall", 169, 6, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)   
			draw.DrawText(math.floor(self:GetStat("heat")).."°", "TargetIDSmall", 169, 47, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)   
			self:drawIcon("icon16/fire.png", 169, 32, 16, 16)
			
			self:DrawHelp(200, 74)
		end
	cam.End3D2D()
end