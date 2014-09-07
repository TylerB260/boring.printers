AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")

include("shared.lua")

function ENT:FanBreakRandom()
    if self.PrinterOC > 0 then
        local chance = math.random(1,15000 - (self.PrinterOC * 250))
            
        --print(chance)
            
        if chance == 1 and not self.BrokenFan then
            self:BreakFan()
        end
    end
end