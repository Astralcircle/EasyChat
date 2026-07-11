-- this is inspired off
-- https://github.com/meepen/gmodchatmod

local TAG = "EasyChatEngineChatHack"
local EC_ENABLED = GetConVar("easychat_enable")
local EC_SKIP_STARTUP_MSG = GetConVar("easychat_skip_startup_msg")
local MSG_BLOCK_TIME = 5 -- how many seconds after InitPostEntity do we still block messages

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

				local is_team = string.match(string.lower(label:GetText()), "team")
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

local STACK_OFFSET = 4 -- we start at 4 to ignore all the calls from the internals of easychat
local function is_easychat_calling()
	local data = debug.getinfo(STACK_OFFSET)
	if data then
		local ret = string.match(data.source, "^@lua/easychat") ~= nil or string.match(data.source, "^@addons/easychat/lua/easychat") ~= nil
		if ret then return true end

		if string.match(data.source, "^@addons") then
			local chunks = string.Split(data.source, "/")
			return chunks[1] == "@addons" and chunks[3] == "lua" and chunks[4] == "easychat"
		end
	end

	return false
end

chat.old_EC_HackAddText = chat.old_EC_HackAddText or chat.AddText
chat.AddText = function(...)
	local calling = is_easychat_calling()
	if EC_SKIP_STARTUP_MSG:GetBool() and not calling then
		if EasyChat and EasyChat.SkippedAnnoyingMessages then
			chat.old_EC_HackAddText(...)
		else
			MsgC("\n", ...)
			return "EC_SKIP_MESSAGE"
		end
	else
		chat.old_EC_HackAddText(...)
	end
end

hook.Add("InitPostEntity", TAG, function()
	timer.Simple(MSG_BLOCK_TIME, function()
		EasyChat.SkippedAnnoyingMessages = true
	end)

	hook.Remove("InitPostEntity", TAG)
end)
