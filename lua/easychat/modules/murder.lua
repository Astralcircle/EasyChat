if gmod.GetGamemode().Name ~= "Murder" then return end

if SERVER then
	hook.Add("PlayerSay","EasyChatMurderWorkaround",function(ply, msg)
		if ply:Team() ~= 2 or not ply:Alive() or GAMEMODE:GetRound() == 0 then
			return msg
		end
	end)
end