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

dkpdb = {}

dkpdb.table = {}

--- This function find the DKP encoded in the officer note of the specified user.
-- @usage This function should not be used externally.
-- @param user The user to find the DKP of.
-- @return The DKP of the user if available, if not - 0.
dkpdb.get_user_dkp_from_officer_note = function(user)
	for i = 1, GetNumGuildMembers() do
		local name, _, _, _, _, _, _, officer_note = GetGuildRosterInfo(i)

		if string.lower(string.match(name, "^(%w+)-(%w+)$")) == user then
			local dkp_str = string.match(officer_note, ".*DKP:(%d+).*")

			if dkp_str == nil then
				return 0
			else
				return tonumber(dkp_str)
			end
		end
	end
end


--- This function encodes the DKP of a user into an officer note.
-- It tries to preserve already existing notes surrounding the DKP:val substring.
-- @usage This function should not be used externally.
-- @param user The user to set the DKP of.
-- @param dkp The new dkp to set.
dkpdb.set_user_dkp_to_officer_note = function(user, dkp)
	for i = 1, GetNumGuildMembers() do
		local name, _, _, _, _, _, _, officer_note = GetGuildRosterInfo(i)

		if string.lower(string.match(name, "^(%w+)-(%w+)$")) == user then
			local prefix, suffix = string.match(officer_note, "(.*)DKP:%d+(.*)")

			if prefix == nil then
				prefix = ""
			end

			if suffix == nil then
				suffix = ""
			end

			GuildRosterSetOfficerNote(i, prefix .. "DKP:" .. tostring(dkp) .. suffix)

		end
	end
end

--- This function returns the DKP of the user in the current table if available, if not, then it finds the DKP
--  encoded in the officer note. If this is not available, gives 0.
-- @param user The user to get the DKP of.
-- @return The DKP of the user if available, if not - 0.
dkpdb.get_user_dkp = function(user)
	return dkpdb.get_user_dkp_from_officer_note(user)
end

--- This function sets a users DKP in the current table. Note that this does not persistently save into the guild note.
-- @param user The user to set the DKP of.
dkpdb.set_user_dkp = function(user, dkp)
	dkpdb.set_user_dkp_to_officer_note(user, dkp)
end

--- This function takes the whole current table and saves it persistently into the guild note.
--dkpdb.save_table = function()
--	for user, dkp in pairs(dkpdb.table) do
--		dkpdb.set_user_dkp_to_officer_note(user, dkp)
--	end
--end