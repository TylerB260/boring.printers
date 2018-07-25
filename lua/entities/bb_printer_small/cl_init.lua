include("shared.lua")

function ENT:Initialize() -- spawn
	self:SetModel("models/props_c17/consolebox03a.mdl")
	
	self.PrinterStats = {}
	
	self:SpawnCLEnts()
			
	self.MotorSound = CreateSound(self, self.Sounds.motor.path)
	self.MotorSound:SetSoundLevel(60)
	
	self.FanSound = CreateSound(self, "boring.builders/server_fan.wav")
	self.FanSound:SetSoundLevel(60)
end

function ENT:Think() -- handle stuff, only run if player is nearby.
	if self:GetDistance() > 384 then 
		if self.MotorSound:IsPlaying() then self.MotorSound:Stop() end
		if self.FanSound:IsPlaying() then self.FanSound:Stop() end
	
		return 
	end
	
	if self:GetRunning() then
		if !self.MotorSound:IsPlaying() then self.MotorSound:PlayEx(1, self.Sounds.motor.pitch) end
		
		if self:GetStat("fan") == 0 then 
			if self.FanSound:IsPlaying() then 
				self.FanSound:Stop() 
			end
			
			if IsValid(self.CLEnts.fan) then 
				self.CLEnts.fan:SetColor(Color(0, 0, 0)) 
				
				if not self.lastfire then self.lastfire = 0 end
				
				if CurTime() - self.lastfire >= (1 - self:GetStat("speed")) then 
					self.CLEnts.fan:StopParticles()
					ParticleEffect("fire_jet_01", self:GetFanPos(), self:GetAngles(), self.CLEnts.fan)
					self.lastfire = CurTime()
				end
			end
		end
		
		if self:GetStat("fan") == 1 and !self.FanSound:IsPlaying() then 
			self.FanSound:Play() 
			
			if IsValid(self.CLEnts.fan) then 
				self.CLEnts.fan:StopParticles()
				self.CLEnts.fan:SetColor(Color(255, 255, 255)) 
			end
		end
		
		--self.MotorSound:SetSoundLevel(50)
		self.FanSound:ChangePitch(100 + math.max(0, self:GetStat("heat") - 70) * 2)
	else
		if IsValid(self.CLEnts.fan) then self.CLEnts.fan:StopParticles() end
		
		if self.MotorSound:IsPlaying() then self.MotorSound:Stop() end
		if self.FanSound:IsPlaying() then self.FanSound:Stop() end
		
		if self:GetStat("fan") == 0 then
			self:StopParticles()
		end
	end
	
	if IsValid(self.CLEnts.button) and self.CLEnts.button:GetPos():Distance(self:GetButtonPos()) > 1 then
		self:SpawnCLEnts()
	end
end

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

function ENT:RemoveCLEnts() -- remove clientside ents, saves ents and FPS.
	if not self.CLEnts then return end
	
	if IsValid(self.CLEnts.fan) then self.CLEnts.fan:Remove() end
	if IsValid(self.CLEnts.button) then self.CLEnts.button:Remove() end
	
	self.CLEntsSpawned = false
end


function ENT:OnRemove() -- deletion
	self:RemoveCLEnts()
	
	if self.MotorSound then 
		self.MotorSound:Stop() 
	end
	if self.FanSound then 
		self.FanSound:Stop() 
	end
end

function ENT:DrawHelp(w, h)
	local offender = false
	
	if self:GetStat("speed") == 0 then offender = "off" end -- is it on?
	if self:GetStat("paper") < self:GetRate("paper") then offender = "paper" end -- out of paper
	if self:GetStat("ink") < self:GetRate("ink") then  -- out of ink
		if offender == "paper" then 
			offender = "both"
		else
			offender = "ink" 
		end
	end
	if self:GetStat("money") >= self:GetStatMax("money") then offender = "money" end -- full of money
	
	-- run these checks regardless of power state
	if self:GetStat("fan") == 0 then offender = "fan" end -- fans busted!
	
	if offender then
		surface.SetDrawColor(Color(0, 0, 0, 250)) -- overlay
		surface.DrawRect(0, 0, w, h)    
		
		if offender == "off" then
			self:drawIcon("icon16/cross.png", w / 2, (h / 2) - 16, 24, 24)
			draw.DrawText("Printer is off.", "TargetID", w / 2, h / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)   
			draw.DrawText("Turn on with the slider.", "TargetIDSmall", w / 2, (h / 2) + 16, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)   
		end
		
		if offender == "both" then
			self:drawIcon("icon16/cart.png", w / 2, (h / 2) - 16, 24, 24)
			draw.DrawText("Out of Supplies!", "TargetID", w / 2, h / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)   
			draw.DrawText("Buy some paper and ink.", "TargetIDSmall", w / 2, (h / 2) + 16, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)   
		end
		
		if offender == "paper" then
			self:drawIcon("icon16/page_copy.png", w / 2, (h / 2) - 16, 24, 24)
			draw.DrawText("Out of Paper!", "TargetID", w / 2, h / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)   
			draw.DrawText("Buy some paper.", "TargetIDSmall", w / 2, (h / 2) + 16, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)   
		end
		
		if offender == "ink" then
			self:drawIcon("icon16/water.png", w / 2, (h / 2) - 16, 24, 24)
			draw.DrawText("Out of Ink!", "TargetID", w / 2, h / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)   
			draw.DrawText("Buy some ink.", "TargetIDSmall", w / 2, (h / 2) + 16, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)   
		end
		
		if offender == "money" then
			self:drawIcon("icon16/money.png", w / 2, (h / 2) - 16, 24, 24)
			draw.DrawText("Storage Full!", "TargetID", w / 2, h / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)   
			draw.DrawText("Money storage is full.", "TargetIDSmall", w / 2, (h / 2) + 16, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)    
		end
		
		if offender == "fan" then
			self:drawIcon("icon16/fire.png", w / 2, (h / 2) - 16, 24, 24)
			draw.DrawText("Damaged Fan!", "TargetID", w / 2, h / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)   
			draw.DrawText("Buy a replacement fan!", "TargetIDSmall", w / 2, (h / 2) + 16, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)   
		end
	end
end

function ENT:Draw()
	self:DrawModel()
	
	if self:GetDistance() > (512 + 64) and self.CLEntsSpawned then self:RemoveCLEnts() end
	if self:GetDistance() < 512 and !self.CLEntsSpawned then self:SpawnCLEnts() end
	
	
	local pos = self:LocalToWorld(Vector(10.2, -10.6, 7.3));
	local ang = self:GetAngles()
	ang:RotateAroundAxis(ang:Forward(), 90)
	ang:RotateAroundAxis(ang:Right(), 270)
	
	cam.Start3D2D(pos, ang, 0.075)
		if self:GetDistance() < 1024 then
			surface.SetDrawColor(Color(0, 0, 0, 255)) -- background
			surface.DrawRect(0, 0, 285, 74)    
		end
		
		if self:GetDistance() < 512 then
			-- paper --
			self:drawRect(2, 2, 48, 69)
			self:drawBar(4, 4, 44, 66, (self:GetStat("paper") / self:GetStatMax("paper")) * 100)
			
			draw.DrawText("Paper", "TargetIDSmall", 25, 6, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)   
			draw.DrawText(math.floor(self:GetStat("paper")), "TargetID", 25, 41, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)   
			draw.DrawText("pages", "TargetIDSmall", 25, 53, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)   
			self:drawIcon("icon16/page_copy.png", 26, 31, 16, 16)
			
			-- ink --
			self:drawRect(52, 2, 48, 69)
			self:drawBar(54, 4, 44, 66, (self:GetStat("ink") / self:GetStatMax("ink")) * 100, "redblue")
			
			draw.DrawText("Ink", "TargetIDSmall", 75, 6, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)   
			draw.DrawText(math.floor(self:GetStat("ink")), "TargetID", 75, 41, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)   
			draw.DrawText("mL", "TargetIDSmall", 75, 53, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)   
			self:drawIcon("icon16/water.png", 76, 30, 16, 16)
			
			-- cash --
			self:drawRect(102, 2, 48, 69)
			self:drawBar(104, 4, 44, 66, (self:GetStat("money") / self:GetStatMax("money")) * 100, "green")
			
			local pretty = self:GetStat("money") < 1 and (self:GetStat("money") * 100).."¢" or "$"..math.floor(self:GetStat("money"))
			
			draw.DrawText("Cash", "TargetIDSmall", 125, 6, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)   
			draw.DrawText(pretty, "TargetID", 125, 47, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)   
			self:drawIcon("icon16/money.png", 126, 31, 16, 16)
			
			-- temp --
			self:drawRect(152, 2, 34, 69)
			self:drawBar(154, 4, 30, 66, (self:GetStat("heat") / self:GetStatMax("heat")) * 100, "greenred")
			
			draw.DrawText(math.floor(self:GetStat("heat")).."°", "TargetIDSmall", 169, 47, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)   
			
			self:DrawHelp(200, 74)
		end
	cam.End3D2D()
end