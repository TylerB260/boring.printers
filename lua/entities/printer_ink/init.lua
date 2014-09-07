AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")

include("shared.lua")

function ENT:FindClose()
    local tab = {}
    
    for k,v in pairs(player.GetAll()) do
        if v:GetPos():Distance(self:GetPos()) <= 1024 then
            table.insert(tab,v)
        end
    end
    
    return tab
end


function ENT:Process(printer)
    if CurTime() - self.ProcessTime <= 0 then return end
    
    self.ProcessTime = CurTime() + 0.25
    
    local theirink = printer.PrinterCurrentInk
    local theirmaxink = printer.PrinterInkMax

    if theirink < theirmaxink then
        if theirmaxink - theirink > 0 then
            local acceptable = math.Clamp(theirmaxink - theirink, 0, 0.1)
            local giveable = math.Clamp(self.Ink,0,acceptable)
            
            self:SetInk(self.Ink - giveable)
            
            printer.PrinterCurrentInk = printer.PrinterCurrentInk + giveable
            
            net.Start("printer_update")
                net.WriteEntity(printer)
                net.WriteString("ink")
                net.WriteFloat(printer.PrinterCurrentInk)
            net.Send(printer:FindClose())
            
            self:EmitSound("ambient/water/drip"..math.random(1,4)..".wav",60,math.random(90,110))
        end
    end
    
    if self.Ink <= 0 then
        self:Remove()
    end
end
        


function ENT:SetInk(ink)
    net.Start("printer_update")
        net.WriteEntity(self)
        net.WriteString("ink")
        net.WriteFloat(ink)
    net.Send(self:FindClose())
    
    self.Ink = ink
    
    if ink <= 0 then self:Remove() end
end

function ENT:Touch(ent)
    if not IsValid(ent) then return end
    
    if ent:GetClass() == self:GetClass() then
        ent:GetPhysicsObject():SetVelocity(Vector(0,0,0.1))
        --if self:EntIndex() > ent:EntIndex() then
            if ent.Ink > 0 and self.Ink < self.MaxInk then
                local theirs = ent.Ink
                local mine = self.Ink
                local avail = self.MaxInk - self.Ink
                    
                if ent:GetPos().z > self:GetPos().z then
                    if theirs > 0 and avail > 0 then
                        local clamp = math.Clamp(avail,0,0.1)
                        self:SetInk(self.Ink + clamp)
                        ent:SetInk(theirs - clamp)
                        self:EmitSound("ambient/water/drip"..math.random(1,4)..".wav",60,math.random(90,110))
                    end
                end
            end
        --end
    end
end

function ENT:OnRemove()
    --if IsValid(self.paper) then
        --self.paper:Remove()
    --end
end