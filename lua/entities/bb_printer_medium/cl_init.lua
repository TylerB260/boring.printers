include("shared.lua")

function ENT:Initialize() -- spawn
	self:SetModel("models/props_c17/consolebox01a.mdl")
	
	self.PrinterStats = {}
	
	self:SpawnCLEnts()
			
	self.MotorSound = CreateSound(self, self.Sounds.motor.path)
	self.MotorSound:SetSoundLevel(50)
	
	self.FanSound = CreateSound(self, "boring.builders/server_fan.mp3")
	self.FanSound:SetSoundLevel(50)
end

function ENT:SpawnCLEnts() -- spawn in fan, button, etc.
	self.CLEnts = self.CLEnts or {}
	self:RemoveCLEnts()

	local fan = ClientsideModel("models/props/cs_assault/wall_vent.mdl")
	fan:SetAngles(self:GetAngles())
	fan:SetPos(self:GetFanPos())
	fan:SetParent(self)
	
	local mat = Matrix()
	mat:Scale(Vector(0.15,0.225,0.25))
	fan:EnableMatrix("RenderMultiply", mat)
	
	local button = ClientsideModel("models/maxofs2d/button_slider.mdl")
	local ang = self:GetAngles()
	ang:RotateAroundAxis(ang:Right(), 270)
	button:SetAngles(ang)
	button:SetPos(self:GetButtonPos())
	button:SetParent(self)
	button:SetModelScale(0.61, 0)
	

	self.CLEnts.fan = fan
	self.CLEnts.button = button
	
	self.CLEntsSpawned = true
end

function ENT:Draw()
	self:DrawModel()
	
	if self:GetDistance() > (512 + 64) and self.CLEntsSpawned then self:RemoveCLEnts() end
	if self:GetDistance() < 512 and !self.CLEntsSpawned then self:SpawnCLEnts() end
	
	
	local pos = self:LocalToWorld(Vector(16.5, -14.45, 10.2));
	local ang = self:GetAngles()
	ang:RotateAroundAxis(ang:Forward(), 90)
	ang:RotateAroundAxis(ang:Right(), 270)
	
	cam.Start3D2D(pos, ang, 0.1175)
		if self:GetDistance() < 1024 then
			surface.SetDrawColor(Color(0, 0, 0, 255)) -- background
			surface.DrawRect(0, 0, 188, 82)    
		end
		
		if self:GetDistance() < 512 then
			-- paper --
			self:drawRect(2, 2, 48, 77)
			self:drawBar(4, 4, 44, 74, (self:GetStat("paper") / self:GetStatMax("paper")) * 100)
			
			draw.DrawText("Paper", "TargetIDSmall", 25, 10, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)   
			draw.DrawText(math.floor(self:GetStat("paper")), "TargetID", 25, 45, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)   
			draw.DrawText("pages", "TargetIDSmall", 25, 57, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)   
			self:drawIcon("icon16/page_copy.png", 26, 35, 16, 16)
			
			-- ink --
			self:drawRect(52, 2, 48, 77)
			self:drawBar(54, 4, 44, 74, (self:GetStat("ink") / self:GetStatMax("ink")) * 100, "redblue")
			
			draw.DrawText("Ink", "TargetIDSmall", 75, 10, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)   
			draw.DrawText(math.floor(self:GetStat("ink")), "TargetID", 75, 45, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)   
			draw.DrawText("mL", "TargetIDSmall", 75, 57, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)   
			self:drawIcon("icon16/water.png", 76, 34, 16, 16)
			
			-- cash --
			self:drawRect(102, 2, 48, 77)
			self:drawBar(104, 4, 44, 74, (self:GetStat("money") / self:GetStatMax("money")) * 100, "green")
			
			local pretty = self:GetStat("money") < 1 and (self:GetStat("money") * 100).."¢" or "$"..math.floor(self:GetStat("money"))
			
			draw.DrawText("Cash", "TargetIDSmall", 125, 10, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)   
			draw.DrawText(pretty, "TargetID", 125, 51, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)   
			self:drawIcon("icon16/money.png", 126, 35, 16, 16)
			
			-- temp --
			self:drawRect(152, 2, 8, 77)
			self:drawBar(154, 4, 4, 74, (self:GetStat("heat") / self:GetStatMax("heat")) * 100, "greenred")
			
			
			
			self:DrawHelp(162, 82)
		end
	cam.End3D2D()
	
	local pos = self:LocalToWorld(Vector(16.85, 8.7, 9.35))

	cam.Start3D2D(pos, ang, 0.1)
		surface.SetDrawColor(Color(0, 0, 0, 255))
		surface.DrawRect(0, 0, 65, 75)     
	cam.End3D2D()
end