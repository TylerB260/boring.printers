AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")

include("shared.lua")

util.AddNetworkString("bb_printer_update")

function ENT:Initialize() -- spawn
	self:SetModel(self.Model)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self:PhysWake()
	self:SetTrigger(true)
	
	self.PrinterStats = {}
	
	self:SetStat("health", self:GetStatMax("health"))
		
	if self.PrinterInfo.type == "printer" then
		self:SetStat("paper", 0)
		self:SetStat("ink", 0)
		self:SetStat("money", 0)
		self:SetStat("heat", 22)
	
		self:SetStat("speed", 0)
		self:SetStat("fan", 1)
	else
		self:SetStat("paper", self:GetStatMax("paper"))
		self:SetStat("ink", self:GetStatMax("ink"))
	end
	
	timer.Simple(0.5, function()
		if IsValid(self) then self:BroadcastUpdate() end
	end)
end

function ENT:FindNearby()
	local nearby = {}
	
	for k, v in pairs(player.GetAll()) do
		if v:GetPos():Distance(self:GetPos()) <= 512 then
			table.insert(nearby, v)
		end
	end
	
	return nearby
end

function ENT:Use(ply)
	if not ply or not IsValid(ply) then return end
	local pos = self:LocalToWorld(self:OBBCenter())
	
	if self.PrinterInfo.type == "printer" and self.PrinterInfo.button then
		if ply:GetPos():Distance(pos) < 92 and ply:GetEyeTrace().Entity == self and ply:KeyDown(IN_USE) then
			if ply:GetEyeTrace().HitPos:Distance(self:GetButtonPos()) <= self:GetButtonSize() then
				if self:GetStat("speed") == 1 and self:GetRunning() then self:EmitSound(self.Sounds.stop.path, 80, self.Sounds.stop.pitch) end
				self:SetStat("speed", (self:GetStat("speed") >= 1 and 0 or self:GetStat("speed") + 0.1))
				if self:GetStat("speed") == 0.1 and self:GetRunning() then self:EmitSound(self.Sounds.start.path, 80, self.Sounds.start.pitch) end
				
				self:EmitSound(self.Sounds.use.path, 60, self.Sounds.use.pitch + (50 * self:GetStat("speed")))
			else
				local money = math.floor(self:GetStat("money"))
				
				if money > 0 then
					ply:addMoney(money)
					self:SetStat("money", self:GetStat("money") - money)
					DarkRP.notify(ply, 0, 4, DarkRP.getPhrase("found_money", DarkRP.formatMoney(money)))
					self:EmitSound("ambient/levels/labs/coinslot1.wav", 60)
				end
			end
		else -- it's a user
			for k, v in pairs(ents.FindByClass("gmod_wire_user")) do -- find all users
				if v.Inputs and v.Inputs.Fire and v.Inputs.Fire.Value > 0 then -- is it firing?
					local trace = util.TraceLine( {
						start = v:GetPos(),
						endpos = v:GetPos() + (v:GetUp() * v:GetBeamLength()),
						filter = {v},
					})
					
					if trace.HitPos:Distance(self:GetButtonPos()) <= self:GetButtonSize() then -- GOTCHA!!
						if self:GetStat("speed") == 0 and self:GetRunning() then self:EmitSound(self.Sounds.stop.path, 80, self.Sounds.stop.pitch) end
						self:SetStat("speed", (self:GetStat("speed") >= 1 and 0 or self:GetStat("speed") + 0.1))
						if self:GetStat("speed") == 0.1 and self:GetRunning() then self:EmitSound(self.Sounds.start.path, 80, self.Sounds.start.pitch) end
						
						self:EmitSound(self.Sounds.use.path, 60, self.Sounds.use.pitch + (50 * self:GetStat("speed")))
					elseif trace.Entity == self then -- gotcha, but no money for you!
						local money = math.floor(self:GetStat("money"))
				
						if money > 0 then
							self:SetStat("money", self:GetStat("money") - money)
							self:EmitSound("ambient/machines/combine_terminal_idle4.wav", 60)
							DarkRP.createMoneyBag(self:GetFanPos(), money)
						end
					end
				end
			end
		end
	elseif not self:IsPlayerHolding() and ply:GetPos():Distance(pos) <= 96 and ply:KeyDown(IN_USE) then
		ply:PickupObject(self)
	end
end

-- HEALTH --

function ENT:OnTakeDamage(dmg)
	if self.PrinterInfo.type == "printer" and dmg:GetDamagePosition():Distance(self:GetFanPos()) < self:GetFanSize() and self:GetStat("fan") == 1 then
		self:BreakFan()
	end
	
	self:SetStat("health", self:GetStat("health") - (dmg:GetDamage() or 0))
	
	if self:GetStat("health") <= 0 then
		if self.PrinterInfo.type == "printer" then
			self:Explode() -- printers
		else
			self:Remove() -- paper, ink, fan.
		end
	end
	
	if self:GetStat("health") <= 10 and not self:IsOnFire() and self.PrinterInfo.type == "printer" then -- printers ignite
		self:Ignite(15)
	end
end

function ENT:Explode()
	local effectdata = EffectData()
	effectdata:SetStart(self:GetFanPos())
	effectdata:SetOrigin(self:GetFanPos())
	effectdata:SetScale(1)
	
	for i = 1, 5 do util.Effect("Explosion", effectdata) end
	for i = 1, 5 do util.Effect("cball_explode", effectdata) end
	
	for k, v in pairs(ents.FindInSphere(self:GetPos(), 128)) do
		if IsValid(v) and not v:IsWeapon() and v:GetClass() != "predicted_viewmodel" and not v:IsOnFire() then
			v:Ignite(math.random(30,60), 32)
			if IsValid(v:GetPhysicsObject()) then
				v:GetPhysicsObject():ApplyForceCenter((v:GetPos() - self:GetPos()) * v:GetPhysicsObject():GetMass() * 32) 
			end
		end
	end
	
	--util.BlastDamage(self, self, self:GetPos(), 256, 100)
	
	self:Remove()
end

-- STATS AND STUFF --

function ENT:SetStat(name, value) -- paper ink money heat fan etc
	if self:GetStatMax(name) > 0 then
		self.PrinterStats[name] = math.max(math.min(self:GetStatMax(name), value), 0)
	else
		self.PrinterStats[name] = value
	end
	
	net.Start("bb_printer_update")
		net.WriteEntity(self)
		net.WriteString(name)
		net.WriteDouble(value)
	net.Send(self:FindNearby())
end

function ENT:BroadcastUpdate()
	for k, v in pairs(self.PrinterStats) do
		net.Start("bb_printer_update")
			net.WriteEntity(self)
			net.WriteString(k)
			net.WriteDouble(v)
		net.Send(self:FindNearby())
	end
end

local delay = 0.25 -- in seconds

function ENT:Think() -- increase stuff based on tickrate!!
	local mul = self:GetStat("speed")
	self.heatoffset = self.heatoffset or 0
	
	if self:GetRunning() then
		-- eat paper
		self:SetStat("paper", self:GetStat("paper") - (self:GetRate("paper") * delay * mul))
		
		-- eat ink
		self:SetStat("ink", self:GetStat("ink") - (self:GetRate("ink") * delay * mul))
		
		-- increment money
		self:SetStat("money", self:GetStat("money") + (self:GetRate("money") * delay * mul))
		
		--[[
			explosive calculation is as follows:
			50,000 at speed 0.1
			5,000 less for every click 
		]]--
		
		self.Likelyhood = 55000 - (mul * 50000)
		
		local boom = math.floor(math.random(1, self.Likelyhood))
		if boom == 1 and self:GetStat("fan") == 1 then self:BreakFan() end
	end
	
	self:NextThink(0) -- do not manually think! let the timer call it instead.
	
	-- handle heat
	
	if self.PrinterInfo.type == "printer" then
		local target = 0
		local heat = self:GetStat("heat")
		local maxheat = self:GetStatMax("heat")
		local ambient = 22
		local range = (maxheat - ambient) * 0.9 -- 0.9 for "breathing room" at max speed
		
		if self:GetRunning() and self:GetStat("fan") == 0 then target = maxheat * 1.25 end -- enough to make it boom, but not too quickly.
		if self:GetRunning() and self:GetStat("fan") == 1 then target = ambient + (range * mul) end
		
		if math.random(1,10) == 1 then self.heatoffset = math.random(-5,5) end
		
		target = target + self.heatoffset
		if heat < target then heat = heat + (target - heat) / 64 end
		if heat > target then heat = heat - (heat - target) / 64 end
		
		if heat >= maxheat and not self:IsOnFire() then
			self:Ignite(5) -- it will be reignited if the heat is not handled quickly.
		end
		
		self:SetStat("heat", heat)

		if self:GetStat("fan") == 0 and math.random(1, 15) == 1 then
			local effectdata = EffectData()
			effectdata:SetStart(self:GetFanPos())
			effectdata:SetOrigin(self:GetFanPos())
			effectdata:SetScale( 1 )
			util.Effect("cball_explode", effectdata) 
			
			self:EmitSound("ambient/energy/spark"..(math.random(1,6))..".wav",60)
		end
	end
	
	local hcol = (self:GetStat("health") / self:GetStatMax("health")) * 255
	
	self:SetColor(Color(255, hcol, hcol))
	
	if self:WaterLevel() >= 1 then
		local effectdata = EffectData()
		effectdata:SetStart(self:GetPos())
		effectdata:SetOrigin(self.PrinterInfo.type == "printer" and self:GetFanPos() or self:GetPos())
		effectdata:SetScale(1)
		effectdata:SetMagnitude(1)
		effectdata:SetScale(3)
		effectdata:SetRadius(1)
		effectdata:SetEntity(self)
		
		util.Effect("TeslaHitBoxes", effectdata, true, true)

		self:TakeDamage( 2, self, self )
				
		local Zap = math.random(1,9)
		if Zap == 4 then Zap = 3 end
		self:EmitSound("ambient/energy/zap"..Zap..".wav",80,math.random(95,105))
	end
	return true
end

function ENT:BreakFan()
	self:PhysWake() -- make stuff jiggle so fan fixes 
	
	self:SetStat("fan", 0)
	self:EmitSound(self.Sounds.alert.path, 100, self.Sounds.alert.pitch)
	
	local effectdata = EffectData()
	effectdata:SetStart(self:GetFanPos())
	effectdata:SetOrigin(self:GetFanPos())
	effectdata:SetScale( 1 )
	util.Effect( "Explosion", effectdata )
	util.Effect( "cball_explode", effectdata )
end

function ENT:FixFan()
	self:SetStat("fan", 1)
	self:EmitSound("ambient/machines/pneumatic_drill_"..math.random(1,4)..".wav", 80)
end

timer.Create("bb_printer_think", delay, 0, function()
	for _, e in pairs(ents.GetAll()) do
		if e.PrinterStats then 
			e:Think()
		end
	end
end)

timer.Create("bb_printer_network", 5, 0, function()
	for _, e in pairs(ents.GetAll()) do
		if e.PrinterStats then 
			e:BroadcastUpdate() 
		end
	end
end)