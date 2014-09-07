AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")

include("shared.lua")

util.AddNetworkString("printer_update")
util.AddNetworkString("printer_switch")


function ENT:OnTakeDamage(dmg)
    if dmg:GetDamagePosition():Distance(self:LocalToWorld(self.FanPos)) < self.FanSize and not self.BrokenFan then
        self:BreakFan()
    end
    
    self.health = self.health - (dmg:GetDamage() or 0)
    if self.health <= 0 then
        self:Explode()
    end
    if self.health <= 10 and not self:IsOnFire() then
        self:Ignite(60)
    end
end

function ENT:Touch( ent )
    if not IsValid(ent) then return end
    
    if ent:GetClass() == "printer_paper" or ent:GetClass() == "printer_ink" then
        ent:Process(self)
        ent:GetPhysicsObject():SetVelocity(Vector(0,0,0.1))
    end
    
    if ent:GetClass() == "printer_fan" and self.BrokenFan then
        self.BrokenFan = false
        
        self:EmitSound("ambient/machines/pneumatic_drill_"..math.random(1,4)..".wav",80)

        self:SetNWBool("BrokenFan",false)
        
        ent:Remove()
        
        if self.PrinterRunning then
            self.steam:Fire("turnon")
            self.smoke:Fire("turnoff")
        end
    end
end

function ENT:Test()
    --self.PrinterCurrentMoney = 0
    --self.PrinterCurrentHeat = 0
    --self.PrinterCurrentInk = 5000
    --self.PrinterCurrentPaper = 5000
    --self.PrinterInteractSound = 0    
end

function ENT:Explode()
    local effectdata = EffectData()
    effectdata:SetStart( self:LocalToWorld(self.FanPos) )
    effectdata:SetOrigin( self:LocalToWorld(self.FanPos) )
    effectdata:SetScale( 1 )
    for i = 1,5 do util.Effect( "Explosion", effectdata ) end
    for i = 1,5 do util.Effect( "cball_explode", effectdata ) end
    
    for k, v in pairs(ents.FindInSphere(self:GetPos(), 256)) do
        if IsValid(v) and not v:IsWeapon() and v:GetClass() != "predicted_viewmodel" and not v:IsOnFire() then
            v:Ignite(math.random(30,60), 32)
            if IsValid(v:GetPhysicsObject()) then
                v:GetPhysicsObject():ApplyForceCenter((v:GetPos() - self:GetPos()) * 250) 
            end
        end
    end
    
    --util.BlastDamage(self, self, self:GetPos(), 256, 100)
    
    self:Remove()
end

function ENT:BreakFan()
    local effectdata = EffectData()
    effectdata:SetStart( self:LocalToWorld(self.FanPos) )
    effectdata:SetOrigin( self:LocalToWorld(self.FanPos) )
    effectdata:SetScale( 1 )
    util.Effect( "Explosion", effectdata )
    util.Effect( "cball_explode", effectdata )
    
    local id = self:EntIndex()
    
    if self.PrinterRunning then
        self.smoke:Fire("turnon")
        self.steam:Fire("turnoff")
    end
    
    self:SetNWBool("BrokenFan",true)
    
    self:EmitSound("npc/attack_helicopter/aheli_megabomb_siren1.wav",80,100)
    
    self.BrokenFan = true
end

function ENT:Refill()
    self.PrinterCurrentInk = 5000
    self.PrinterCurrentPaper = 5000
end

function ENT:FindClose()
    local tab = {}
    
    for k,v in pairs(player.GetAll()) do
        if v:GetPos():Distance(self:GetPos()) <= 1024 then
            table.insert(tab,v)
        end
    end
    
    return tab
end

function ENT:ChangeOC(oc)
    self.PrinterOC = oc
    self.PrinterSoundEffect:ChangePitch(self.PrinterPitch + (self.PrinterOC * 25),1)
    
    self:EmitSound("buttons/blip1.wav",80,100 + (self.PrinterOC * 10))
    net.Start("printer_switch")
        net.WriteEntity(self)
        net.WriteFloat(self.PrinterOC)
    net.Broadcast()
end

function ENT:Print()
    local amt = math.Round(self.PrinterCurrentMoney)
    
    if amt < 1 then 
        if self.PrinterInteractSound <= CurTime() then
            self:EmitSound("buttons/button8.wav")
            self.PrinterInteractSound = CurTime() + 0.5
        end    
        return
    end
    
    DarkRP.createMoneyBag(self:LocalToWorld(self.PrintPos), math.Clamp(math.Round(amt),0,self.PrinterMaxMoney))
    self:EmitSound("ambient/levels/labs/coinslot1.wav")
    self.PrinterCurrentMoney = math.Round(self.PrinterCurrentMoney - math.Round(amt),3)
end

function ENT:FanBreakRandom()
    if self.PrinterOC > 0 then
        local chance = math.random(1,5000 - (self.PrinterOC * 250))
            
        --print(chance)
            
        if chance == 1 and not self.BrokenFan then
            self:BreakFan()
        end
    end
end

function ENT:WaterDamage()
    local effectdata = EffectData()
    effectdata:SetStart(self.FanPos)
    effectdata:SetOrigin(self.FanPos)
    effectdata:SetScale(1)
    effectdata:SetMagnitude(1)
    effectdata:SetScale(3)
    effectdata:SetRadius(1)
    effectdata:SetEntity(self)
    
    for i = 1, 100 do timer.Simple(1/i, function() util.Effect("TeslaHitBoxes", effectdata, true, true) end) end

    self:TakeDamage( 2, self, self )
            
    local Zap = math.random(1,9)
    if Zap == 4 then Zap = 3 end
    self:EmitSound("ambient/energy/zap"..Zap..".wav",80,math.random(95,105))
end

function ENT:Use( activator, caller )
    if caller:GetClass() == "gmod_wire_user" then
        local vStart = caller:GetPos()
        
        local trace = util.TraceLine( {
            start = vStart,
            endpos = vStart + (caller:GetUp() * caller:GetBeamLength()),
            filter = { caller },
        })

        if trace.HitPos:Distance(self:LocalToWorld(self.ButtonPos)) <= self.ButtonSize then
            self:ChangeOC(self.PrinterOC + 0.1)
            
            if self.PrinterOC > 1 then
                self:ChangeOC(0)
            end
            
            return
        end    
    else
        if activator:GetEyeTrace().HitPos:Distance(self:LocalToWorld(self.ButtonPos)) <= self.ButtonSize then
            self:ChangeOC(self.PrinterOC + 0.1)
            
            if self.PrinterOC > 1 then
                self:ChangeOC(0)
            end
            
            return
        end
    end
    
    if self.PrinterCurrentMoney < 1 then
        if self.PrinterInteractSound <= CurTime() then
            self:EmitSound("buttons/button8.wav")
            self.PrinterInteractSound = CurTime() + 0.5
        end
        return
    end
    
    self:Print()
end

function ENT:Think()
    if not self.PrinterRunning then 
        self.PrinterCurrentHeat = math.Clamp(self.PrinterCurrentHeat - math.random(0.05,0.3),0,self.PrinterHeatMax)
        net.Start("printer_update")
            net.WriteEntity(self)
            net.WriteString("heat")
            net.WriteFloat(math.Round(self.PrinterCurrentHeat,1))
        net.Send(self:FindClose())
                
        self.LastBroadcastHeat = math.Round(self.PrinterCurrentHeat,1)   
    end
        
    if self.PrinterCurrentHeat >= (self.PrinterHeatMax - 15) and not self.PrinterBeep:IsPlaying() then
        self.PrinterBeep:Play()
    end
 
    if self.PrinterCurrentHeat < (self.PrinterHeatMax - 15) and self.PrinterBeep:IsPlaying() then
        self.PrinterBeep:Stop()
    end
                
    if self:WaterLevel() > 0 then
        self:WaterDamage()
    end
            
    if CurTime() - self.PrintLast > self.PrinterDelay then
        
        --updates--        
        if self.PrinterOC  == 0 or self.PrinterCurrentPaper < self.PrinterPaperRate or self.PrinterCurrentInk < self.PrinterInkRate or self.PrinterAmount >= self.PrinterMaxMoney then
            self.PrinterRunning = false
            
            if self.PrinterRunning2 then
                self.PrinterRunning2 = false
                self.PrinterSoundEffect:Stop()
                self.steam:Fire("turnoff")
                self.smoke:Fire("turnoff")
                
                self:SetNWBool("PrinterEnabled",false)
                
                self:EmitSound("ambient/machines/thumper_shutdown1.wav",80,self.PrinterPitch)
            end
        else
            self.PrinterRunning = true
            
            if not self.PrinterRunning2 then
                self.PrinterRunning2 = true
                self.PrinterSoundEffect:Play()
                self.PrinterSoundEffect:ChangePitch(self.PrinterPitch + (self.PrinterOC * 25),1)
                self.PrinterSoundEffect:ChangeVolume(0, 0)
                self.PrinterSoundEffect:ChangeVolume(1, 1)                
                if not self.BrokenFan then self.steam:Fire("turnon") end
                if self.BrokenFan then self.smoke:Fire("turnon") end
  
                self:SetNWBool("PrinterEnabled",true)
              
                self:EmitSound("ambient/machines/thumper_startup1.wav",80,self.PrinterPitch)
            end
        end
        
        if not self.PrinterRunning then 
            if CurTime() - self.LastBroadcast > 0.5 then
                self.LastBroadcast = CurTime() + 1
            
                net.Start("printer_update")
                    net.WriteEntity(self)
                    net.WriteString("heat")
                    net.WriteFloat(math.Round(self.PrinterCurrentHeat,1))
                net.Send(self:FindClose())
                
                self.LastBroadcastHeat = niceheat         
                
                net.Start("printer_update")
                    net.WriteEntity(self)
                    net.WriteString("paper")
                    net.WriteFloat(math.Round(self.PrinterCurrentPaper,1))
                net.Send(self:FindClose())
                
                self.LastBroadcastHeat = niceheat         
                
                net.Start("printer_update")
                    net.WriteEntity(self)
                    net.WriteString("ink")
                    net.WriteFloat(math.Round(self.PrinterCurrentInk,1))
                net.Send(self:FindClose())

                net.Start("printer_update")
                    net.WriteEntity(self)
                    net.WriteString("money")
                    net.WriteFloat(math.floor(self.PrinterCurrentMoney))
                net.Send(self:FindClose())
                                
                self.LastBroadcastHeat = self.PrinterCurrentHeat  
                self.LastBroadcastPaper = self.PrinterCurrentPaper
                self.LastBroadcastInk = self.PrinterCurrentInk   
                self.LastBroadcastMoney = self.PrinterCurrentMoney              
            end
            return 
        else
            local cool = self.PrinterHeatRate
            
            if not self.BrokenFan then
                cool = cool * (((100 - (((self.PrinterCurrentHeat)/(20 + ( self.PrinterOC * 30 )))*100))/100) * 1)
            else
                cool = self.PrinterHeatRate * ((self.PrinterOC * 7.5) * (1.1 - (self.PrinterCurrentHeat / self.PrinterHeatMax)))
            end
            
            if self:IsOnFire() then
                cool = cool + math.random(2,7)
            end
            
            self.PrinterCurrentHeat = math.Clamp(self.PrinterCurrentHeat + cool,0,self.PrinterHeatMax)
            self.PrinterCurrentPaper = math.Clamp(self.PrinterCurrentPaper - (self.PrinterPaperRate * (1 + self.PrinterOC * 2)),0,self.PrinterPaperMax)
            self.PrinterCurrentInk = math.Clamp(self.PrinterCurrentInk - (self.PrinterInkRate * (1 + self.PrinterOC * 2)),0,self.PrinterInkMax)
        end
        
        local niceheat = math.Round(self.PrinterCurrentHeat,1)
        local nicepaper = math.Round(self.PrinterCurrentPaper,1)
        local niceink = math.Round(self.PrinterCurrentInk,1)
        local nicemoney = math.floor(self.PrinterCurrentMoney)

        if niceheat != self.LastBroadcastHeat or CurTime() - self.LastBroadcast > 5 then
            net.Start("printer_update")
                net.WriteEntity(self)
                net.WriteString("heat")
                net.WriteFloat(niceheat)
            net.Send(self:FindClose())
            
            self.LastBroadcastHeat = niceheat
        end

        if nicepaper != self.LastBroadcastPaper or CurTime() - self.LastBroadcast > 5 then
            net.Start("printer_update")
                net.WriteEntity(self)
                net.WriteString("paper")
                net.WriteFloat(nicepaper)
            net.Send(self:FindClose())
            
            self.LastBroadcastPaper = nicepaper
        end
        
        if niceink != self.LastBroadcastInk or CurTime() - self.LastBroadcast > 5 then
            net.Start("printer_update")
                net.WriteEntity(self)
                net.WriteString("ink")
                net.WriteFloat(niceink)
            net.Send(self:FindClose())
            
            self.LastBroadcastInk = niceink
        end
        
        if nicemoney != self.LastBroadcastMoney or CurTime() - self.LastBroadcast > 5 then
            net.Start("printer_update")
                net.WriteEntity(self)
                net.WriteString("money")
                net.WriteFloat(nicemoney)
            net.Send(self:FindClose())
            
            self.LastBroadcastMoney = nicemoney
        end
                       
        if niceheat >= self.PrinterHeatMax and not self:IsOnFire() then
            self:Ignite(300)
        end
        
        self.LastBroadcast = CurTime()
        --updates--
        
        self.PrintLast = CurTime()
        self.PrinterCurrentMoney = self.PrinterCurrentMoney + (self.PrinterAmount * (1 + self.PrinterOC * 2))
        
        self:FanBreakRandom()
        
        if self.BrokenFan and math.random(1,5) == 1 then
            local effectdata = EffectData()
            effectdata:SetStart( self:LocalToWorld(self.FanPos) )
            effectdata:SetOrigin( self:LocalToWorld(self.FanPos) )
            effectdata:SetScale( 1 )
            util.Effect( "cball_explode", effectdata ) 
            
            self:EmitSound("ambient/energy/spark"..(math.random(1,6))..".wav",60)
        end
    end
    
    if not self:IsOnFire() and self.PrinterCurrentHeat >= self.PrinterHeatMax then
        self:Ignite(30,32)
    end
    
    if self.PrinterCurrentMoney >= self.PrinterMaxMoney then
        self:Print()  
    end
    
    self.steam:SetKeyValue("SpreadSpeed", 10 + (self.PrinterOC * 2 * 10))
    self.steam:SetKeyValue("JetLength", 64 + (self.PrinterOC * 2*32))
end