dkpcommandparser = {}

dkpcommandparser.parse_command_and_execute = function(command_str, user)
	local s = string.lower(command_str)
	local user = string.lower(user)

	local command = string.match(s, '^!dkp%s+(%w+)')
	local subcommand, subsubcommand

	if command == nil then
		return
	elseif command == "status" then
		_, subcommand = string.match(s, '^!dkp%s+(%w+)%s+(%a+).*$')
	elseif command == "award" or command == "deduce" then
		_, subcommand, subsubcommand = string.match(s, '^!dkp%s+(%w+)%s+(%a+)%s+(%d+)')
	elseif command == "startbidding" then
		_, subcommand = string.match(s, '^!dkp%s+(%w+)%s+(.*)')
	elseif command == "bid" then
		_, subcommand = string.match(s, '^!dkp%s+(%w+)%s+(%d+)')
	end

	if subcommand ~= nil then
		subcommand = string.lower(subcommand)
	end
	if subsubcommand ~= nil then
		subsubcommand = string.lower(subsubcommand)
	end

	if command == "status" then
		local target
		if subcommand == nil or subcommand == "" then
			target = user
		else
			target = subcommand
		end
		dkpcommand.inform_dkp_status(user, target)

	elseif command == "award" then
		if not permissions.has_admin_privileges(user) then
			return
		end

		local target = subcommand
		local dkp = tonumber(subsubcommand)
		dkpcommand.award_dkp(user, target, dkp)

	elseif command == "deduce" then
		if not permissions.has_admin_privileges(user) then
			return
		end

		local target = subcommand
		local dkp = tonumber(subsubcommand)
		dkpcommand.deduce_dkp(user, target, dkp)

	elseif command == "startbidding" then
		if not permissions.has_admin_privileges(user) then
			return
		end

		local item = subcommand
		dkpcommand.start_bidding(user, item)

	elseif command == "finishbidding" then
		if not permissions.has_admin_privileges(user) then
			return
		end
		
		dkpcommand.finish_bidding(user)

	elseif command == "bid" then
		local bid = tonumber(subcommand)
		dkpcommand.bid(user, bid)

	elseif command == "cancelbidding" then
		if not permissions.has_admin_privileges(user) then
			return
		end

		dkpcommand.cancel_bidding(user)
	end
end