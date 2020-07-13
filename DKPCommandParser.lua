--[[
	SivaDKP - A KISS, easy-to-use WoW DKP system
	Copyright (C) 2020 Marko Vejnovic

	This program is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.

	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with this program.  If not, see <https://www.gnu.org/licenses/>.
--]]

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