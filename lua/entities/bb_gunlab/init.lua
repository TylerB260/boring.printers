AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

util.AddNetworkString("bb_gunlab")

net.Receive("bb_gunlab", function(_, ply)
	local lab = net.ReadEntity()
	local gun = net.ReadString()
	local price = net.ReadInt(32)
	
	if lab:GetClass() != "bb_gunlab" then return end
	
	if ply == lab:GetDealer() then
		lab:SetGun(gun)
		lab:SetPrice(price)
	end
end)

function ENT:Initialize() -- spawn
	self.BaseClass.Initialize(self)
	
	self:SetGun(CustomShipments[1].entity)
	self:SetPrice(self:CalculatePrice(CustomShipments[1]))
	
	self.lastuse = 0
end

function ENT:SetGun(class)
	local info = false
		
	for k, v in pairs(CustomShipments) do
		if v.entity == class then
			info = v
		end
	end
	
	if info then
		self.gun = class
		self:SetNWString("gun", class)
		self:SetNWString("name", info.name)
	else
		local name = class
		
		if class == "weapon_crowbar" then name = "Crowbar" end
		if class == "weapon_stunstick" then name = "Stunstick" end
		if class == "weapon_physcannon" then name = "Gravity Gun" end
		if class == "weapon_physgun" then name = "Physics Gun" end
		
		if class == "weapon_pistol" then name = "9MM Pistol" end
		if class == "weapon_357" then name = ".357 Magnum" end
		
		if class == "weapon_smg1" then name = "SMG" end
		if class == "weapon_ar2" then name = "Pulse-Rifle" end
		
		if class == "weapon_shotgun" then name = "Shotgun" end
		if class == "weapon_crossbow" then name = "Crossbow" end
		
		if class == "weapon_slam" then name = "S.L.A.M." end
		if class == "weapon_frag" then name = "Grenade" end
		if class == "weapon_rpg" then name = "RPG" end
		
		if name == class and weapons.Get(class) then 
			name = weapons.Get(class).PrintName
		end
		
		self.gun = class
		self:SetNWString("gun", class)
		self:SetNWString("name", name)
	end
end

function ENT:SetPrice(price)
	local price = math.Clamp(price, 0, 10000)
	
	self.price = price
	self:SetNWInt("price", price)
end

function ENT:Purchase(ply)
	if CurTime() - self.lastuse < 1 then return end
	
	self.lastuse = CurTime()
	
	if not ply:canAfford(self.price) then 
		self:EmitSound("ambient/levels/labs/coinslot1.wav", 60)
		return
	end
	
	local info = false
	
	for k, v in pairs(CustomShipments) do
		if v.entity == self.gun then
			info = v
		end
	end
	
	if not IsValid(self:GetDealer()) then return end
	
	local profit = self.price - self:CalculatePrice(info)
		
	if not self:GetDealer():canAfford(math.max(0, -profit)) then 
		DarkRP.notify(ply, 0, 4, "You cannot buy this gun because the owner of this Gun Lab cannot afford it.")
		DarkRP.notify(self:GetDealer(), 0, 4, ply:Name().." tried to buy a "..self:GetNWString("name", self.gun).." but you couldn't afford it.")
		return
	end
	
	if info then
		DarkRP.notify(self:GetDealer(), 0, 4, ply:Name().." just spent "..DarkRP.formatMoney(self.price).." on a "..self:GetNWString("name", self.gun)..", you "..(profit >= 0 and "profited" or "lost").." "..DarkRP.formatMoney(profit)..".")
		self:GetDealer():addMoney(profit)
	else
		DarkRP.notify(self:GetDealer(), 0, 4, ply:Name().." just spent "..DarkRP.formatMoney(self.price).." on a "..self:GetNWString("name", self.gun)..".")
		self:GetDealer():addMoney(self.price)		
	end
	
	DarkRP.notify(ply, 0, 4, "You just spent "..DarkRP.formatMoney(self.price).." on a "..self:GetNWString("name", self.gun)..".")
	ply:addMoney(-self.price)

	local gun = ents.Create("spawned_weapon")
	gun:SetModel(info and info.model or "models/props_junk/cardboard_box003a.mdl")
	gun:SetWeaponClass(self.gun)
	gun:SetPos(self:LocalToWorld(Vector(0, 0, 16)))
	gun.nodupe = true
	gun.ammoadd = weapons.Get(self.gun) and weapons.Get(self.gun).Primary.DefaultClip or 0
	gun:Spawn()
	
	gun:EmitSound("garrysmod/balloon_pop_cute.wav", 80)
	gun:EmitSound("ambient/machines/pneumatic_drill_"..math.random(1, 4)..".wav", 80)
	gun:GetPhysicsObject():SetVelocity(Vector(math.random(-25, 25), math.random(-25, 25), 128))
end

function ENT:Use(ply)
	if ply:GetEyeTrace().Entity == self and ply:GetPos():Distance(self:GetPos()) < 128 and ply:KeyDown(IN_USE) then
		if self:GetDealer() == ply and not ply:Crouching() then
			net.Start("bb_gunlab")
				net.WriteEntity(self)
				net.WriteString(self.gun)
				net.WriteInt(self.price, 32)
			net.Send(ply)
		else
			self:Purchase(ply)
		end
	else -- its a user
		for k, v in pairs(ents.FindByClass("gmod_wire_user")) do -- find all users
			if v.Inputs and v.Inputs.Fire and v.Inputs.Fire.Value > 0 then -- is it firing?
				local trace = util.TraceLine( {
					start = v:GetPos(),
					endpos = v:GetPos() + (v:GetUp() * v:GetBeamLength()),
					filter = {v},
				})
				
				local owner = nil
	
				if v.Getowning_ent then owner = v:Getowning_ent() end
				if v.CPPIGetOwner then owner = v:CPPIGetOwner() end
				
				if IsValid(owner) and owner:IsPlayer() and trace.Entity == self then -- gotcha
					self:Purchase(ply)
				end
			end
		end
	end
end