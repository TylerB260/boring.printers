include("shared.lua")

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
	self:SetModel(self.Model)
	
	if self.PrinterInfo.type == "printer" then
		self.PrinterStats = {
			fan = 1 -- stop the "Overheated" message on spawn.
		}
	else
		self.PrinterStats = {
			ink = self:GetStatMax("ink"),
			paper = self:GetStatMax("paper")
		}
	end
	
	self:SpawnCLEnts()
	
	if self.PrinterInfo.type == "printer" then -- ink vials dont make motor noises...
		self.MotorSound = CreateSound(self, self.Sounds.motor.path)
		self.MotorSound:SetSoundLevel(60)
		
		self.FanSound = CreateSound(self, "tylerb/server_fan.mp3") -- ambient/office/tech_room.wav
		self.FanSound:SetSoundLevel(60)
	end
end

function ENT:Think() -- handle stuff, only run if player is nearby.
	if self:GetDistance() > 512 and self.PrinterInfo.type == "printer" then 
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
				if not self.lastfire then self.lastfire = 0 end
				
				if CurTime() - self.lastfire >= 0.05 then 
					self.CLEnts.fan:StopParticles()
					ParticleEffect("fire_jet_01", self:GetFanPos(), self:GetAngles(), self.CLEnts.fan)
					self.lastfire = CurTime()
				end
			end
		else
			self.CLEnts.fan:StopParticles()
		end
		
		if self:GetStat("fan") == 1 and !self.FanSound:IsPlaying() then self.FanSound:Play() end
		
		--self.MotorSound:SetSoundLevel(50)
		self.MotorSound:ChangePitch(100 + math.random(0, 1))
		self.FanSound:ChangePitch(100 + math.max(0, self:GetStat("heat") - 70) * 2 + math.random(0, 1))
	elseif self.PrinterInfo.type == "printer" then
		if IsValid(self.CLEnts.fan) then self.CLEnts.fan:StopParticles() end
		
		if self.MotorSound:IsPlaying() then self.MotorSound:Stop() end
		if self.FanSound:IsPlaying() then self.FanSound:Stop() end
		
		if self:GetStat("money") >= self:GetStatMax("money") and self:GetStat("speed") > 0 then
			self.moneybeep = self.moneybeep or 0
			
			if CurTime() - self.moneybeep > 2 then
				self.moneybeep = CurTime()
				self:EmitSound(self.Sounds.full.path, 60, self.Sounds.full.pitch)
			end
		end
	end
	
	 if IsValid(self.CLEnts.fan) then 
		local c = self:GetStat("fan") == 1 and 255 or 0
		self.CLEnts.fan:SetColor(Color(c, c, c)) 
	end
	
	if IsValid(self.CLEnts.button) and self.CLEnts.button:GetPos():Distance(self:GetButtonPos()) > 1 then
		self:SpawnCLEnts()
	end
end

-- SpawnCLEnts is defined per entity since they have different models.

function ENT:SpawnCLEnts()
	self.CLEnts = self.CLEnts or {}
	self:RemoveCLEnts()
	
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