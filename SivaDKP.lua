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

local GuildParserFrame = CreateFrame("Frame")
GuildParserFrame:RegisterEvent("CHAT_MSG_GUILD")
GuildParserFrame:SetScript("OnEvent", function (self, event, message, sender, ...)
	dkpcommandparser.parse_command_and_execute(message, sender)
end)