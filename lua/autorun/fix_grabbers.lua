hook.Add("InitPostEntity", "boring.printers", function()
	local ENT = scripted_ents.Get("gmod_wire_grabber")

	function ENT:CanGrab(trace)
		if not trace.Entity or not isentity(trace.Entity) then return false end
		if (not trace.Entity:IsValid() and not trace.Entity:IsWorld()) or trace.Entity:IsPlayer() then return false end
		if not util.IsValidPhysicsObject(trace.Entity, trace.PhysicsBone) then return false end

		--if not gamemode.Call( "CanTool", self:GetPlayer(), trace, "weld" ) then return false end
		
		return true
	end

	scripted_ents.Register(ENT, "gmod_wire_grabber")
end)