local TAG = "EasyChatEngineChatHack"

if SERVER then
	-- handle messages that are run by the engine (usually the say or sayteam commands)
	hook.Add("PlayerSay", TAG, function(ply, msg, is_team, is_local)
		if _G.EC_PLAYER_SAY_CALL then return end

		EasyChat.ReceiveGlobalMessage(ply, msg, is_team, is_local or false)
		return "" -- we handled it dont network it back the source way
	end)

	local PLY = FindMetaTable("Player")
	PLY.old_Say = PLY.old_Say or PLY.Say

	function PLY:Say(msg, is_team, is_local)
		EasyChat.ReceiveGlobalMessage(self, msg, is_team, is_local)
	end
end

-- this is inspired off
-- https://github.com/meepen/gmodchatmod
if CLIENT then
	local EC_ENABLED = GetConVar("easychat_enable")

	local color_white = color_white

	local engine_panel
	local is_chat_opened = false
	local function hack_msg_send()
		local parent_panel = engine_panel:GetParent()
		local label = parent_panel:GetChildren()[1]
		--engine_panel:SetKeyboardInputEnabled(false) -- lets not do that lol

		local text_entry = parent_panel:Add("TextEntryLegacy")
		text_entry:SetZPos(9999999)
		text_entry:SetFocusTopLevel(true)
		text_entry:SetFont("ChatFont")
		text_entry:SetTextColor(color_white)
		text_entry:SetUpdateOnType(true)
		_G.EC_CHAT_HACK = text_entry

		local selection_color = Color(255, 0, 0, 127)
		function text_entry:Paint()
			self:DrawTextEntryText(EasyChat.TextColor, selection_color, EasyChat.TextColor)
		end

		hook.Add("Think", text_entry, function(self)
			if engine_panel:HasFocus() then
				engine_panel:KillFocus()
				self:RequestFocus()
			end

			self:SetPos(engine_panel:GetPos())
			self:SetSize(engine_panel:GetSize())

			local should_show = is_chat_opened and not EC_ENABLED:GetBool()
			self:SetVisible(should_show)

			if should_show and input.IsKeyDown(KEY_ESCAPE) then
				self:SetText("")
				hook.Run("ChatTextChanged", "")
				chat.Close()
			end
		end)

		function text_entry:OnValueChange(text)
			hook.Run("ChatTextChanged", text)
		end

		function text_entry:OnTab()
			local text = self:GetText()
			if #text == 0 then return end

			local completion = hook.Run("OnChatTab", text)
			if completion then self:SetText(completion) end

			EasyChat.RunOnNextFrame(function()
				self:SetCaretPos(#self:GetText())
				engine_panel:KillFocus()
				self:RequestFocus()
			end)
		end

		function text_entry:OnKeyCodeTyped(key_code)
			EasyChat.SetupHistory(self, key_code)

			if key_code == KEY_TAB then
				self:OnTab()
				return true
			end

			if key_code == KEY_ESCAPE then
				self:SetText("")
				hook.Run("ChatTextChanged", "")
				chat.Close()
				return true
			end

			if key_code == KEY_ENTER or key_code == KEY_PAD_ENTER then
				local msg = self:GetText()
				if not EasyChat.IsStringEmpty(msg) then
					msg = EasyChat.ExtendedStringTrim(self:GetText())

					local should_send = EasyChat.SafeHookRun("ECShouldSendMessage", msg)
					if should_send == false then return end

					local is_team = label:GetText():lower():match("team")
					EasyChat.SendGlobalMessage(msg, is_team, false)
				end

				self:SetText("")
				hook.Run("ChatTextChanged", "")
				chat.Close()
				return true
			end
		end
	end

	hook.Add("StartChat", TAG, function(is_team)
		is_chat_opened = true

		if EC_ENABLED:GetBool() then return end
		if IsValid(engine_panel) then return end

		hook.Add("Think", TAG, function()
			if IsValid(vgui.GetKeyboardFocus()) then
				engine_panel = vgui.GetKeyboardFocus()
				hack_msg_send()
				hook.Remove("Think", TAG)
			end
		end)
	end)

	hook.Add("FinishChat", TAG, function()
		is_chat_opened = false
	end)
end