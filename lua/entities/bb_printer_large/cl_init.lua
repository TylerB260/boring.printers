include("shared.lua")

function ENT:SpawnCLEnts() -- spawn in fan, button, etc.
	self.CLEnts = self.CLEnts or {}
	self:RemoveCLEnts()

	local fan = ClientsideModel("models/props/cs_assault/wall_vent.mdl")
	local ang = self:GetAngles()
	ang:RotateAroundAxis(ang:Up(),90)
	fan:SetAngles(ang)
	fan:SetPos(self:GetFanPos())
	fan:SetParent(self)
	
	local mat = Matrix()
	mat:Scale(Vector(0.3, 0.4, 0.5))
	fan:EnableMatrix("RenderMultiply", mat)
	
	local button = ClientsideModel("models/maxofs2d/button_slider.mdl")
	local ang = self:GetAngles()
	ang:RotateAroundAxis(ang:Right(), 90)
	ang:RotateAroundAxis(ang:Up(), 180)
	button:SetAngles(ang)
	button:SetPos(self:GetButtonPos())
	button:SetParent(self)
	
	local mat = Matrix()
	mat:Scale(Vector(1.5, 1.5, 1.5))
	button:EnableMatrix("RenderMultiply", mat)
	

	self.CLEnts.fan = fan
	self.CLEnts.button = button
	
	self.CLEntsSpawned = true
end

function ENT:Draw()
	self:DrawModel()
	
	if self:GetDistance() > (512 + 64) and self.CLEntsSpawned then self:RemoveCLEnts() end
	if self:GetDistance() < 512 and !self.CLEntsSpawned then self:SpawnCLEnts() end
	
	local pos = self:LocalToWorld(Vector(13,-7.45,28))
	local ang = self:GetAngles()
	ang:RotateAroundAxis(ang:Forward(), 90)
	ang:RotateAroundAxis(ang:Right(), 270)
	
	self.background = self.background or Material("console/background02")
	
	cam.Start3D2D(pos, ang, 0.1035)
		if self:GetDistance() < 1024 then
			surface.SetDrawColor(Color(255, 255, 255, 255)) -- background
			surface.SetMaterial(self.background)
			surface.DrawTexturedRect(0, 0, 226, 74)    
		end
		
		if self:GetDistance() < 512 then
			-- paper --
			self:drawRect(2, 2, 54, 70)
			self:drawBar(4, 4, 50, 67, (self:GetStat("paper") / self:GetStatMax("paper")) * 100)
			
			draw.DrawText("Paper", "TargetIDSmall", 28, 6, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)   
			draw.DrawText(math.floor(self:GetStat("paper")), "TargetID", 28, 41, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)   
			draw.DrawText("pages", "TargetIDSmall", 28, 53, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)   
			self:drawIcon("icon16/page_copy.png", 29, 31, 16, 16)
			
			-- ink --
			self:drawRect(58, 2, 54, 70)
			self:drawBar(60, 4, 50, 67, (self:GetStat("ink") / self:GetStatMax("ink")) * 100, "redblue")
			
			draw.DrawText("Ink", "TargetIDSmall", 85, 6, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)   
			draw.DrawText(math.floor(self:GetStat("ink")), "TargetID", 85, 41, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)   
			draw.DrawText("mL", "TargetIDSmall", 85, 53, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)   
			self:drawIcon("icon16/water.png", 86, 30, 16, 16)
			
			-- cash --
			self:drawRect(114, 2, 54, 70)
			self:drawBar(116, 4, 50, 67, (self:GetStat("money") / self:GetStatMax("money")) * 100, "green")
			
			local pretty = self:GetStat("money") < 1 and (self:GetStat("money") * 100).."¢" or "$"..math.floor(self:GetStat("money"))
			
			draw.DrawText("Cash", "TargetIDSmall", 140, 6, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)   
			draw.DrawText(pretty, "TargetID", 140, 47, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)   
			self:drawIcon("icon16/money.png", 141, 31, 16, 16)
			
			-- temp --
			self:drawRect(170, 2, 54, 70)
			self:drawBar(172, 4, 50, 67, (self:GetStat("heat") / self:GetStatMax("heat")) * 100, "greenred")
			
			draw.DrawText("Temp", "TargetIDSmall", 197, 6, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)   
			draw.DrawText(math.floor(self:GetStat("heat")).."°", "TargetIDSmall", 197, 47, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)   
			self:drawIcon("icon16/fire.png", 197, 31, 16, 16)
			
			self:DrawHelp(225, 74)
		end
	cam.End3D2D()
end