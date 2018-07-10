ENT.Type = "anim"
ENT.Base = "printer_base"
ENT.PrintName = "Server Class Money Printer"
ENT.Author = "TylerB"
ENT.Spawnable = false
ENT.AdminSpawnable = false

function ENT:Initialize()
    self:SetModel("models/props_lab/reciever_cart.mdl")

    self.PrinterDelay = 0.1
    self.PrinterAmount = 0.05
    self.PrinterSound = "ambient/machines/thumper_amb.wav"
    self.PrinterPitch = 90
    self.PrinterHeatRate = 0.4
    self.PrinterHeatMax = 148
    self.PrinterInkRate = 0.00005
    self.PrinterInkMax = 10
    self.PrinterPaperRate = 0.0125
    self.PrinterPaperMax = 1000
    
    self.PrinterCurrentMoney = 0
    self.PrinterCurrentHeat = 0
    self.PrinterCurrentInk = 0
    self.PrinterCurrentPaper = 0
    self.PrinterInteractSound = 0
    self.PrinterMaxMoney = 5000
    self.PrinterRunning = false
    self.PrinterRunning2 = false
    
    self.ButtonSize = 12.5
    self.ButtonPos = Vector(-11,4.25,7)
    self.FanSize = 15
    self.FanPos = Vector(-0.75,19,11.15)
    self.PrintPos = Vector(0,0,-10)
    
    if SERVER then
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetSolid(SOLID_VPHYSICS)
        self:SetMoveType(MOVETYPE_VPHYSICS)
        self:SetUseType(SIMPLE_USE)
        self:PhysWake()
        self:GetPhysicsObject():SetMass(100)
        
        self:SetPos(self:GetPos() + Vector(0,0,25))
        self.health = 100
        
        self.PrintLast = CurTime()
        self.LastBroadcast = 0
        self.LastBroadcastHeat = 0
        self.LastBroadcastPaper = 0
        self.LastBroadcastInk = 0
        self.LastBroadcastAmount = 0
        self.PrinterSoundEffect = CreateSound(self, self.PrinterSound)
        self.PrinterSoundEffect:SetSoundLevel(60)
        
        self.PrinterBeep = CreateSound(self, "npc/attack_helicopter/aheli_crash_alert2.wav")
        self.PrinterBeep:SetSoundLevel(60)
        self.PrinterBeep:ChangePitch(90,0)
        
        self.PrinterOC = 0
        
        -- for vent --
        self.steam = ents.Create("env_steam")
        self.steam:SetPos(self:LocalToWorld(self.FanPos))
        local ang = self:GetAngles()
        ang:RotateAroundAxis(ang:Up(),90)
        self.steam:SetAngles(ang)
        self.steam:SetKeyValue("SpreadSpeed", 40)
        self.steam:SetKeyValue("Speed", 100)
        self.steam:SetKeyValue("StartSize", 5)
        self.steam:SetKeyValue("EndSize", 10)
        self.steam:SetKeyValue("Rate", 250)
        self.steam:SetKeyValue("JetLength", 64)
        self.steam:SetKeyValue("renderamt", 5)
        self.steam:SetKeyValue("type", 0)
        self.steam:SetKeyValue("rendercolor","215 215 255")
        self.steam:Spawn()
        self.steam:SetParent(self)
        self.steam:Fire("turnoff","",0)
    
        self:SetNWEntity("steam",self.steam)
        
        self.smoke = ents.Create("env_steam")
        self.smoke:SetPos(self:LocalToWorld(self.FanPos))
        local ang = self:GetAngles()
        ang:RotateAroundAxis(ang:Up(),90)
        self.smoke:SetAngles(ang)
        self.smoke:SetKeyValue("SpreadSpeed", 8)
        self.smoke:SetKeyValue("Speed", 32)
        self.smoke:SetKeyValue("StartSize", 10)
        self.smoke:SetKeyValue("EndSize", 10)
        self.smoke:SetKeyValue("Rate", 50)
        self.smoke:SetKeyValue("JetLength", 128)
        self.smoke:SetKeyValue("renderamt", 200)
        self.smoke:SetKeyValue("type", 0)
        self.smoke:SetKeyValue("rendercolor","20 20 20")
        self.smoke:Spawn()
        self.smoke:SetParent(self)
        self.smoke:Fire("turnoff","",0)
        
        self:Test()
    else
        self:SpawnEffects()
    end
end