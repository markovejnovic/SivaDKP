guildutil = {}

guildutil.is_in_guild = function(target)
	for i = 1, GetNumGuildMembers() do
		local name = GetGuildRosterInfo(i)

		if string.find(string.lower(name), string.lower(target)) then
			return true
		end
	end

	return false
end