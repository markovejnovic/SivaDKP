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

dkpcommand = {}

dkpcommand.inform_dkp_status = function(user, target)
	SendChatMessage(target .. "'s DKP is: " .. tostring(dkpdb.get_user_dkp(target)), "WHISPER", nil, user)
end

dkpcommand.award_dkp = function(user, target, dkp)
	if target == "raid" then
		for i = 1, MAX_RAID_MEMBERS do
			target = GetRaidRosterInfo(i)

			-- I'd love a continue here. Lua is dumb.
			if target ~= nil and guildutil.is_in_guild(target) then
				target = string.lower(target)
				dkpdb.set_user_dkp(target, dkpdb.get_user_dkp(target) + dkp)
				SendChatMessage(user .. " awarded you with " .. tostring(dkp) .. " DKP.", "WHISPER", nil, target)
			end
		end
	else
		dkpdb.set_user_dkp(target, dkpdb.get_user_dkp(target) + dkp)
		SendChatMessage(user .. " awarded you with " .. tostring(dkp) .. " DKP.", "WHISPER", nil, target)
	end
end

dkpcommand.deduce_dkp = function(user, target, dkp)
	if target == "raid" then
		for i = 1, MAX_RAID_MEMBERS do
			target = GetRaidRosterInfo(i)

			if target ~= nil then
				target = string.lower(target)
				dkpdb.set_user_dkp(target, dkpdb.get_user_dkp(target) - dkp)
				SendChatMessage(user .. " deduced " .. tostring(dkp) .. " DKP from you.", "WHISPER", nil, target)
			end
		end
	else
		dkpdb.set_user_dkp(target, dkpdb.get_user_dkp(target) - dkp)
		SendChatMessage(user .. " deduced " .. tostring(dkp) .. " DKP from you.", "WHISPER", nil, target)
	end
end

dkpcommand.start_bidding = function(user, item_str)
	local item_id, item = GetItemInfo(item_str)
	dkpbidtracker.start_bidding(item_id)

	SendChatMessage(user .. ' announced bidding for: ' .. item .. '. If interested, bid with `!dkp bid [NUMBER]`.',
		"RAID_WARNING")
end

dkpcommand.bid = function(user, bid)
	local err = dkpbidtracker.add_bid(user, bid)

	if err == -2 then
		SendChatMessage('Bidding is currently not open.', "WHISPER", nil, user)
	elseif err == -1 then
		SendChatMessage('You do not have enough DKP. Your DKP: '.. tostring(dkpdb.get_user_dkp(user)), "WHISPER", nil, user)
	elseif err == 1 then
		SendChatMessage('This bid is lower than the maximum bid, currently at: ' ..
			dkpbidtracker.get_max_bid().value .. '.', "WHISPER", nil, user)
	else
		SendChatMessage(user .. "'s bid of " .. bid .. " has been accepted." , "RAID")
	end
end

dkpcommand.finish_bidding = function(user)
	dkpbidtracker.finish_bidding()
	local max_bid = dkpbidtracker.get_max_bid()
	local _, item = GetItemInfo(max_bid.item_id)

	local eq_bids = dkpbidtracker.get_equal_max_bids()

	if eq_bids == nil then
		dkpdb.set_user_dkp(max_bid.owner, dkpdb.get_user_dkp(max_bid.owner) - max_bid.value)

		SendChatMessage('The bidding has finished. ' .. max_bid.owner .. ' won ' .. item .. ' with a price of '
			.. max_bid.value .. ' DKP.', "RAID_WARNING")
	else
		SendChatMessage('The bidding has finished. There is a tie between the following players, at ' ..
			max_bid.value .. ' DKP. No DKP has been deduced', "RAID_WARNING")

		for user, bid in pairs(eq_bids.bids) do
			SendChatMessage(user, "RAID")
		end
	end
end

dkpcommand.cancel_bidding = function(user)
	local _, item = GetItemInfo(dkpbidtracker.get_max_bid().item_id)
	dkpbidtracker.finish_bidding()

	SendChatMessage(user .. ' has cancelled the bid on ' .. item, "RAID_WARNING")
end