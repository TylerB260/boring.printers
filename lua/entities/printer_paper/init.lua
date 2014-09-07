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
    
    self.ProcessTime = CurTime() + 0.05
    
    local theirpaper = printer.PrinterCurrentPaper
    local theirmaxpaper = printer.PrinterPaperMax

    if theirpaper < theirmaxpaper then
        if math.floor(theirmaxpaper - theirpaper) >= 1 then
            self:SetSheets(self.Sheets - 1)
            printer.PrinterCurrentPaper = printer.PrinterCurrentPaper + 1
            
            net.Start("printer_update")
                net.WriteEntity(printer)
                net.WriteString("paper")
                net.WriteFloat(printer.PrinterCurrentPaper)
            net.Send(printer:FindClose())
            
            self:EmitSound("items/itempickup.wav",60,math.random(90,110))
        end
    end
    
    if self.Sheets <= 0 then
        self:Remove()
    end
end

function ENT:SetSheets(sheets)
    net.Start("printer_update")
        net.WriteEntity(self)
        net.WriteString("sheets")
        net.WriteFloat(sheets)
    net.Send(self:FindClose())
    
    self.Sheets = sheets
    
    if sheets <= 0 then self:Remove() end
end

function ENT:Touch(ent)
    if not IsValid(ent) then return end
    
    if ent:GetClass() == self:GetClass() then
        ent:GetPhysicsObject():SetVelocity(Vector(0,0,0.1))
        --if self:EntIndex() > ent:EntIndex() then
            if self.MaxSheets - self.Sheets >= 1 then
                if math.floor(self.MaxSheets - self.Sheets) >= 1 then
                    local theirs = ent.Sheets
                    local mine = self.Sheets
                    local avail = self.MaxSheets - self.Sheets
                    
                    if ent:GetPos().z > self:GetPos().z then
                        if theirs >= 1 and avail >= 1 then
                            self:SetSheets(self.Sheets + 1)
                            ent:SetSheets(theirs - 1)
                            self:EmitSound("items/itempickup.wav",60,math.random(90,110))
                        end
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