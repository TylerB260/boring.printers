AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")

include("shared.lua")
resource.AddFile("sound/boring.builders/server_fan.wav")

function ENT:Initialize() -- spawn
	self:SetModel("models/props_c17/consolebox03a.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self:PhysWake()
	
	self.PrinterStats = {}
	
	self:SetStat("paper", 0)
	self:SetStat("ink", 0)
	self:SetStat("money", 0)
	self:SetStat("heat", 22)
	
	self:SetStat("health", self:GetStatMax("health"))
	self:SetStat("speed", 0)
	self:SetStat("fan", 1)
	
	timer.Simple(0, function()
		if IsValid(self) then self:BroadcastUpdate() end
		if IsValid(self.smoke) then self.smoke:Remove() end
	end)
end

function ENT:Use(ply)
	if not ply or not IsValid(ply) then return end
	
	if ply:GetPos():Distance(self:GetPos()) < 128 then
		if ply:GetEyeTrace().HitPos:Distance(self:GetButtonPos()) <= self:GetButtonSize() then
			if self:GetStat("speed") == 0 and self:GetRunning() then self:EmitSound(self.Sounds.stop.path, 80, self.Sounds.stop.pitch) end
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
		local user = nil
		
		for k, v in pairs(ents.FindByClass("gmod_wire_user")) do -- find all users
			if v.Inputs and v.Inputs.Fire and v.Inputs.Fire.Value > 0 then -- is it firing?
				local trace = util.TraceLine( {
					start = user:GetPos(),
					endpos = user:GetPos() + (user:GetUp() * user:GetBeamLength()),
					filter = {caller},
				})
				
				if trace.HitPos:Distance(self:GetButtonPos()) <= self:GetButtonSize() then -- GOTCHA!!
					if self:GetStat("speed") == 0 and self:GetRunning() then self:EmitSound(self.Sounds.stop.path, 80, self.Sounds.stop.pitch) end
					self:SetStat("speed", (self:GetStat("speed") >= 1 and 0 or self:GetStat("speed") + 0.1))
					if self:GetStat("speed") == 0.1 and self:GetRunning() then self:EmitSound(self.Sounds.start.path, 80, self.Sounds.start.pitch) end
					
					self:EmitSound(self.Sounds.use.path, 60, self.Sounds.use.pitch + (50 * self:GetStat("speed")))
				elseif trace.Entity == self then -- gotcha, but no money for you!
					self.EmitSound("buttons/button8.wav", 60, 100)
				end
			end
		end
    end
end

function ENT:OnTakeDamage(dmg)
	if dmg:GetDamagePosition():Distance(self:GetFanPos()) < self:GetFanSize() and self:GetStat("fan") == 1 then
		self:BreakFan()
	end
	
	self:SetStat("health", self:GetStat("health") - (dmg:GetDamage() or 0))
	
	if self:GetStat("health") <= 0 then
		self:Explode()
	end
	
	if self:GetStat("health") <= 10 and not self:IsOnFire() then
		self:Ignite(300)
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

function ENT:BreakFan()
	self:SetStat("fan", 0)
	self:EmitSound(self.Sounds.alert.path, 100, self.Sounds.alert.pitch)
	
	local effectdata = EffectData()
	effectdata:SetStart(self:GetFanPos())
	effectdata:SetOrigin(self:GetFanPos())
	effectdata:SetScale( 1 )
	util.Effect( "Explosion", effectdata )
	util.Effect( "cball_explode", effectdata )
	
	if IsValid(self.smoke) then self.smoke:Remove() end
	self.smoke = ents.Create("env_steam")
	self.smoke:SetPos(self:GetFanPos())
	self.smoke:SetAngles(self:GetAngles())
	self.smoke:SetKeyValue("SpreadSpeed", 12)
	self.smoke:SetKeyValue("Speed", 96)
	self.smoke:SetKeyValue("StartSize", 4)
	self.smoke:SetKeyValue("EndSize", 8)
	self.smoke:SetKeyValue("Rate", 50)
	self.smoke:SetKeyValue("JetLength", 96)
	self.smoke:SetKeyValue("renderamt", 255)
	self.smoke:SetKeyValue("type", 0)
	self.smoke:SetKeyValue("rendercolor","20 20 20")
	self.smoke:Spawn()
	self.smoke:SetParent(self)
	self.smoke:Fire("turnon", "", 0)
end

function ENT:FixFan()
	self:SetStat("fan", 1)
	self.smoke:Fire("turnoff", "", 0)
	self:EmitSound("ambient/machines/pneumatic_drill_"..math.random(1,4)..".wav", 80)
end

-- /STATS AND STUFF --

function ENT:Think() -- increase stuff based on tickrate!!
	local mul = 0
	
	if self:GetRunning() then
		if self:GetStat("speed") <= 0.5 then mul = self:GetStat("speed") * 2 end -- 0 to 0.5 is 0 to 1 in mul
		if self:GetStat("speed") > 0.5 then mul = 1 + self:GetStat("speed") end -- 0.6 to 1 is 1.1 to 1.5 in mul, less return.
		
		-- eat paper
		self:SetStat("paper", self:GetStat("paper") - (self:GetRate("paper") * 0.1 * mul))
		
		-- eat ink
		self:SetStat("ink", self:GetStat("ink") - (self:GetRate("ink") * 0.1 * mul))
		
		-- increment money
		self:SetStat("money", self:GetStat("money") + (self:GetRate("money") * 0.1 * mul))
		
		if self:GetStat("heat") >= self:GetStatMax("heat") and not self:IsOnFire() then
			self:Ignite(300)
		end
		
		local boom = 0
		
		if self:GetStat("heat") < self:GetStatMax("heat") * 0.75 then
			boom = 50000 - ((self:GetStat("heat") - 22) / ((self:GetStatMax("heat") - 22) * 0.75) * 30000)
		else
			boom = 10000 - math.min(9000, (((self:GetStat("heat") - (self:GetStatMax("heat") * 0.75)) / (self:GetStatMax("heat") * 0.25)) * 9000))
		end
		
		
		boom = math.random(1, math.floor(boom))
		
		if boom == 1 and self:GetStat("fan") == 1 then self:BreakFan() end
	end
	
	-- handle heat
	
	local target = 22
	local speed = 128 -- self:GetRunning() and 128 or 64
	local heat = self:GetStat("heat")
	
	if self:GetRunning() and self:GetStat("fan") == 0 then target = self:GetStatMax("heat") * 1.5 end
	if self:GetRunning() and self:GetStat("fan") == 1 then target = 22 + (mul * 48) end
	
	if heat < target then heat = heat + (target - heat) / speed end
	if heat > target then heat = heat - (heat - target) / speed end
	
	self:SetStat("heat", heat)
	
	self:NextThink(0) -- do not manually think! let the timer call it instead.
	
	if self:GetStat("fan") == 0 and math.random(1, 15) == 1 then
		local effectdata = EffectData()
		effectdata:SetStart(self:GetFanPos())
		effectdata:SetOrigin(self:GetFanPos())
		effectdata:SetScale( 1 )
		util.Effect("cball_explode", effectdata) 
		
		self:EmitSound("ambient/energy/spark"..(math.random(1,6))..".wav",60)
	end
	
	local hcol = (self:GetStat("health") / self:GetStatMax("health")) * 255
	
	self:SetColor(Color(255, hcol, hcol))
	return true
end