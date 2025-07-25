local setting_cvars = {}

local function get_cvar(cvar_name)
	local cvar = GetConVar(cvar_name)
	table.insert(setting_cvars, cvar)
	return cvar
end

local color_white = color_white

-- general
local EC_ENABLE = get_cvar("easychat_enable")
local EC_NO_MODULES = get_cvar("easychat_no_modules")

-- teams and colors
local EC_TEAMS = get_cvar("easychat_teams")
local EC_TEAMS_COLOR = get_cvar("easychat_teams_colored")
local EC_PLAYER_COLOR = get_cvar("easychat_players_colored")
local EC_PLAYER_PASTEL = get_cvar("easychat_pastel")

-- misc
local EC_SECONDARY = get_cvar("easychat_secondary_mode")
local EC_ALWAYS_LOCAL = get_cvar("easychat_always_local")
local EC_ONLY_LOCAL = get_cvar("easychat_only_local")
local EC_LOCAL_MSG_DIST = get_cvar("easychat_local_msg_distance")
local EC_TICK_SOUND = get_cvar("easychat_tick_sound")
local EC_USE_ME = get_cvar("easychat_use_me")
local EC_IMAGES = get_cvar("easychat_images")
local EC_LINKS_CLIPBOARD = get_cvar("easychat_links_to_clipboard")
local EC_GM_COMPLETE = get_cvar("easychat_gm_complete")
local EC_NICK_COMPLETE = get_cvar("easychat_nick_complete")
local EC_NICK_PRIORITIZE = get_cvar("easychat_nick_prioritize")
local EC_OUT_CLICK_CLOSE = get_cvar("easychat_out_click_close")
local EC_SERVER_MSG = get_cvar("easychat_server_msg")
local EC_SKIP_STARTUP_MSG = get_cvar("easychat_skip_startup_msg")
local EC_SYNC_STEAM_BLOCKS = get_cvar("easychat_sync_steam_blocks")

-- timestamps
local EC_TIMESTAMPS = get_cvar("easychat_timestamps")
local EC_TIMESTAMPS_12 = get_cvar("easychat_timestamps_12")
local EC_HUD_TIMESTAMPS = get_cvar("easychat_hud_timestamps")
local EC_TIMESTAMPS_COLOR = get_cvar("easychat_timestamps_color")

-- chatbox
local EC_TAGS_IN_CHATBOX = get_cvar("easychat_tags_in_chatbox")
local EC_USE_DERMASKIN = get_cvar("easychat_use_dermaskin")
local EC_HISTORY = get_cvar("easychat_history")
local EC_PRESERVE_MESSAGE_IN_PROGRESS = get_cvar("easychat_preserve_message_in_progress")
local EC_GLOBAL_ON_OPEN = get_cvar("easychat_global_on_open")
local EC_FONT = get_cvar("easychat_font")
local EC_FONT_SIZE = get_cvar("easychat_font_size")
local EC_PEEK_COMPLETION = get_cvar("easychat_peek_completion")
local EC_LEGACY_ENTRY = get_cvar("easychat_legacy_entry")
local EC_LEGACY_TEXT = get_cvar("easychat_legacy_text")
local EC_MODERN_TEXT_HISTORY_LIMIT = get_cvar("easychat_modern_text_history_limit")
local EC_NON_QWERTY = get_cvar("easychat_non_qwerty")
local EC_BLUR_IMAGES = get_cvar("easychat_blur_images")
local EC_BLUR_BACKGROUND = get_cvar("easychat_background_blur")

-- chathud
local EC_HUD_FOLLOW = get_cvar("easychat_hud_follow")
local EC_HUD_TTL = get_cvar("easychat_hud_ttl")
local EC_HUD_FADELEN = get_cvar("easychat_hud_fadelen")
local EC_HUD_SMOOTH = get_cvar("easychat_hud_smooth")
local EC_HUD_SH_CLEAR = get_cvar("easychat_hud_sh_clear")
local EC_HUD_CUSTOM = get_cvar("easychat_hud_custom")
local EC_HUD_POS_X = get_cvar("easychat_hud_pos_x")
local EC_HUD_POS_Y = get_cvar("easychat_hud_pos_y")
local EC_HUD_WIDTH = get_cvar("easychat_hud_width")

-- translation
local EC_TRANSLATE_INC_MSG = get_cvar("easychat_translate_inc_msg")
local EC_TRANSLATE_INC_SRC_LANG = get_cvar("easychat_translate_inc_source_lang")
local EC_TRANSLATE_INC_TARGET_LANG = get_cvar("easychat_translate_inc_target_lang")
local EC_TRANSLATE_OUT_MSG = get_cvar("easychat_translate_out_msg")
local EC_TRANSLATE_OUT_SRC_LANG = get_cvar("easychat_translate_out_source_lang")
local EC_TRANSLATE_OUT_TARGET_LANG = get_cvar("easychat_translate_out_target_lang")

local function create_default_settings()
	local settings = EasyChat.Settings

	-- general settings
	do
		local category_name = "Общее"
		settings:AddCategory(category_name)

		settings:AddConvarSettingsSet(category_name, {
			[EC_ALWAYS_LOCAL] = "Всегда говорить в локальном режиме по стандарту",
			[EC_ONLY_LOCAL] = "Получать только локальные сообщения",
			[EC_LINKS_CLIPBOARD] = "Автоматически копировать ссылки в буфер обмена",
			[EC_TEAMS] = "Отображать команды",
			[EC_TEAMS_COLOR] = "Раскрашивать теги команд",
			[EC_PLAYER_COLOR] = "Раскрашивать игроков в цвет своей команды",
			[EC_PLAYER_PASTEL] = "Пастелизировать цвета игроков",
			[EC_TICK_SOUND] = "Тикать при новых сообщениях",
			[EC_USE_ME] = "Заменить ваше имя в чате на \"Я\"",
			[EC_GM_COMPLETE] = "Использовать автозаполнение стандартного режима",
			[EC_NICK_COMPLETE] = "Автозаполнять имена игроков",
			[EC_NICK_PRIORITIZE] = "Давать приоритет автодополнению никнеймов игроков перед всем остальным",
			[EC_OUT_CLICK_CLOSE] = "Закрыть чат при нажатии на пустоту",
			[EC_SERVER_MSG] = "Показывать изменения серверных ConVar-ов",
			[EC_SKIP_STARTUP_MSG] = "Пропускать раздражающие сообщения о запуске аддонов",
			[EC_SYNC_STEAM_BLOCKS] = "Синхронизировать ваш список блокировок в Steam с EasyChat",
		})

		settings:AddSpacer(category_name)

		local setting_blocked_players = settings:AddSetting(category_name, "list", "Заблокированные игроки")
		local blocked_players_list = setting_blocked_players.List
		blocked_players_list:SetMultiSelect(true)
		blocked_players_list:AddColumn("SteamID")
		blocked_players_list:AddColumn("Имя")

		blocked_players_list.DoDoubleClick = function(_, _, line)
			local steam_id = line:GetColumnText(1)
			if not steam_id or #steam_id:Trim() <= 0 then return end

			local steam_id64 = util.SteamIDTo64(steam_id)
			EasyChat.OpenURL("https://steamcommunity.com/profiles/" .. steam_id64)
		end

		local function build_blocked_players_list()
			blocked_players_list:Clear()

			for steam_id, _ in pairs(EasyChat.BlockedPlayers) do
				local steam_id64 = util.SteamIDTo64(steam_id)
				steamworks.RequestPlayerInfo(steam_id64, function(steam_name)
					if not IsValid(blocked_players_list) then return end
					blocked_players_list:AddLine(steam_id, steam_name)
				end)
			end
		end

		build_blocked_players_list()
		hook.Add("ECBlockedPlayer", blocked_players_list, build_blocked_players_list)
		hook.Add("ECUnblockedPlayer", blocked_players_list, build_blocked_players_list)

		local setting_unblock_player = settings:AddSetting(category_name, "action", "Разблокировать игрока(-ов)")
		setting_unblock_player.DoClick = function()
			local lines = blocked_players_list:GetSelected()
			for _, line in pairs(lines) do
				local steam_id = line:GetColumnText(1)
				EasyChat.BlockedPlayers[steam_id] = nil
			end

			file.Write("easychat/blocked_players.json", util.TableToJSON(EasyChat.BlockedPlayers))
			build_blocked_players_list()
		end

		local setting_blocked_strings = settings:AddSetting(category_name, "list", "Заблокированные")
		local blocked_strings_list = setting_blocked_strings.List
		blocked_strings_list:SetMultiSelect(true)
		blocked_strings_list:AddColumn("Id")
		blocked_strings_list:AddColumn("Содержание")
		blocked_strings_list:AddColumn("Паттерн")

		local function build_blocked_strings_list()
			blocked_strings_list:Clear()
			for i = 1, #EasyChat.BlockedStrings do
				local blocked_str = EasyChat.BlockedStrings[i]
				blocked_strings_list:AddLine(tostring(i), blocked_str.Content, tostring(blocked_str.IsPattern))
			end
		end

		build_blocked_strings_list()

		local setting_block_string = settings:AddSetting(category_name, "action", "Заблокировать слово")
		setting_block_string.DoClick = function()
			local frame
			frame = EasyChat.AskForInput("Заблокировать слово", function(str)
				EasyChat.BlockString(str, frame.IsPattern:GetChecked())
				build_blocked_strings_list()
			end, false)

			frame:SetTall(125)
			frame.IsPattern = frame:Add("DCheckBoxLabel")
			frame.IsPattern:SetText("Паттерн")
			frame.IsPattern:Dock(FILL)
		end

		local setting_unblock_string = settings:AddSetting(category_name, "action", "Разблокировать слово")
		setting_unblock_string.DoClick = function()
			local lines = blocked_strings_list:GetSelected()
			for _, line in pairs(lines) do
				local id = tonumber(line:GetColumnText(1))
				if not id then continue end
				EasyChat.UnblockString(id)
			end

			build_blocked_strings_list()
		end

		settings:AddSpacer(category_name)

		local setting_secondary_mode = settings:AddConvarSetting(category_name, "string", EC_SECONDARY, "Вторичный режим сообщений")
		setting_secondary_mode.GetAutoComplete = function(self, text)
			local suggestions = {}
			for _, mode in pairs(EasyChat.Modes) do
				table.insert(suggestions, mode.Name:lower())
			end

			return suggestions
		end

		local secondary_mode_selection = 1
		local secondary_mode_input = ""
		setting_secondary_mode.OnKeyCodeTyped = function(self, key_code)
			if key_code == KEY_TAB then
				local suggestion = self:GetAutoComplete(secondary_mode_input)[secondary_mode_selection]
				if suggestion then
					self:SetText(suggestion)
					EasyChat.RunOnNextFrame(function()
						self:RequestFocus()  -- keep focus
						self:SetCaretPos(#self:GetText())
					end)
				end

				secondary_mode_selection = secondary_mode_selection + 1
				if secondary_mode_selection > (EasyChat.ModeCount + 1) then
					secondary_mode_selection = 1
				end
			elseif key_code == KEY_ENTER or key_code == KEY_PAD_ENTER then
				if IsValid(self.Menu) then self.Menu:Remove() end
				self:OnEnter()
				EasyChat.RunOnNextFrame(function()
					self:RequestFocus()  -- keep focus
					self:SetCaretPos(#self:GetText())
				end)
			else
				secondary_mode_input = self:GetText()
				secondary_mode_selection = 1
			end
		end

		settings:AddConvarSetting(category_name, "number", EC_LOCAL_MSG_DIST, "Дальность локальных сообщений", 1000, 100)

		local setting_reset_misc = settings:AddSetting(category_name, "action", "Сбросить настройки")
		setting_reset_misc.DoClick = function()
			local default_distance = tonumber(EC_LOCAL_MSG_DIST:GetDefault())
			EC_LOCAL_MSG_DIST:SetInt(default_distance)
			EC_SECONDARY:SetString(EC_SECONDARY:GetDefault())
		end

		settings:AddSpacer(category_name)

		settings:AddConvarSetting(category_name, "boolean", EC_TIMESTAMPS, "Отображать временные отметки")
		settings:AddConvarSetting(category_name, "boolean", EC_TIMESTAMPS_12, "Отображать 12-часовые временные отметки")
		settings:AddConvarSetting(category_name, "boolean", EC_HUD_TIMESTAMPS, "Отображать временные отметки в Chat HUD")

		local setting_timestamps_color = settings:AddSetting(category_name, "color", "Цвет временных отметок")
		setting_timestamps_color:SetColor(EasyChat.TimestampColor)
		setting_timestamps_color.OnValueChanged = function(_, color)
			EC_TIMESTAMPS_COLOR:SetString(("%d %d %d"):format(color.r, color.g, color.b))
		end

		local setting_reset_timestamps = settings:AddSetting(category_name, "action", "Сбросить настройки")
		setting_reset_timestamps.DoClick = function()
			EC_TIMESTAMPS:SetBool(tobool(EC_TIMESTAMPS:GetDefault()))
			EC_TIMESTAMPS_12:SetBool(tobool(EC_TIMESTAMPS_12:GetDefault()))
			EC_HUD_TIMESTAMPS:SetBool(tobool(EC_HUD_TIMESTAMPS:GetDefault()))
			setting_timestamps_color:SetColor(Color(255, 255, 255, 255))
			EC_TIMESTAMPS_COLOR:SetString(EC_TIMESTAMPS_COLOR:GetDefault())
		end

		local setting_reload_ec = settings:AddSetting(category_name, "action", "Перезапустить EasyChat")
		setting_reload_ec.DoClick = function() EasyChat.Reload() end

		local setting_disable_ec = settings:AddSetting(category_name, "action", "Выключить EasyChat")
		setting_disable_ec.DoClick = function() EC_ENABLE:SetBool(false) end

		local function delete_dir(dir_path)
			local files, folders = file.Find(dir_path .. "/*", "DATA")
			for _, f in pairs(files) do
				local file_path = dir_path .. "/" .. f
				file.Delete(file_path)
			end

			for _, folder in pairs(folders) do
				delete_dir(dir_path .. "/" .. folder)
			end

			file.Delete(dir_path)
		end

		local function factory_reset()
			EasyChat.AskForValidation(
				"Сброс к заводским настройкам Reset",
				"Вы уверены, что хотите сбросить EasyChat к заводским настройкам? Все ваши данные будут удалены.",
				{
					ok_text = "Сбросить",
					ok_btn_color = Color(255, 0, 0),
					callback = function()
						EasyChat.SafeHookRun("ECFactoryReset")

						for _, cvar in pairs(setting_cvars) do
							cvar:SetString(cvar:GetDefault())
						end

						delete_dir("easychat")
						EasyChat.RunOnNextFrame(function() EasyChat.Reload() end)
					end
				}
			)
		end

		local setting_factory_reset = settings:AddSetting(category_name, "action", "Сброс к заводским настройкам")
		setting_factory_reset.DoClick = factory_reset
		concommand.Add("easychat_factory_reset", factory_reset, nil, "Factory reset EasyChat")
	end

	-- chatbox settings
	do
		local category_name = "Чатбокс"
		settings:AddCategory(category_name)

		settings:AddConvarSettingsSet(category_name, {
			[EC_GLOBAL_ON_OPEN] = "Открывать на глобальной вкладке",
			[EC_HISTORY] = "Включить историю",
			[EC_TAGS_IN_CHATBOX] = "Показывать теги в чатбоксе",
			[EC_IMAGES] = "Отображать изображения",
			[EC_PEEK_COMPLETION] = "Просмотривать возможное автозаполнение чата",
			[EC_NON_QWERTY] = "Проверять, есть ли у вас QWERTY-клавиатура или нет",
			[EC_BLUR_IMAGES] = "Размывать изображения в чатбоксе",
			[EC_BLUR_BACKGROUND] = "Размывает фон чатбокса и его окна",
		})

		settings:AddSpacer(category_name)

		if not EasyChat.UseDermaSkin then
			local built_in_themes = {
				Legacy = {
					outlay        = Color(62, 62, 62, 235),
					outlayoutline = Color(0, 0, 0, 0),
					tab           = Color(36, 36, 36, 235),
					taboutline    = Color(0, 0, 0, 0),
				},
				Standard = EasyChat.DefaultColors,
				Crimson = {
					outlay        = Color(62, 32, 32, 255),
					outlayoutline = Color(0, 0, 0, 0),
					tab           = Color(32, 15, 15, 255),
					taboutline    = Color(0, 0, 0, 0),
				},
				Ocean = {
					outlay        = Color(30, 30, 128, 235),
					outlayoutline = Color(0, 0, 0, 0),
					tab           = Color(15, 15, 62, 235),
					taboutline    = Color(0, 0, 0, 0)
				},
				["High Contrast"] = {
					outlay        = Color(0, 0, 0, 255),
					outlayoutline = Color(255, 255, 255, 255),
					tab           = Color(0, 0, 0, 255),
					taboutline    = Color(255, 255, 255, 255),
				},
				["80s"] = {
					outlay        = Color(128, 30, 128, 235),
					outlayoutline = Color(0, 0, 0, 0),
					tab           = Color(0, 0, 36, 255),
					taboutline    = Color(0, 0, 0, 0),
				},
				Desert = {
					outlay        = Color(220, 100, 0, 235),
					outlayoutline = Color(0, 0, 0, 0),
					tab           = Color(36, 15, 0, 255),
					taboutline    = Color(0, 0, 0, 0),
				},
				["Red Light"] = {
					outlay        = Color(220, 0, 75, 235),
					outlayoutline = Color(0, 0, 0, 0),
					tab           = Color(25, 25, 25, 255),
					taboutline    = Color(0, 0, 0, 0),
				}
			}

			local setting_built_in_themes = settings:AddSetting(category_name, "action", "Встроенные темы")

			local setting_outlay_color = settings:AddSetting(category_name, "color", "Outlay цвет")
			setting_outlay_color:SetColor(EasyChat.OutlayColor)
			setting_outlay_color.OnValueChanged = function(_, color)
				EasyChat.OutlayColor = Color(color.r, color.g, color.b, color.a)

				local text_entry = EasyChat.GUI.TextEntry
				if IsValid(text_entry) and text_entry.ClassName == "TextEntryX" then
					local border_color = EasyChat.TabOutlineColor.a == 0
						and EasyChat.OutlayColor or EasyChat.TabOutlineColor
					text_entry:SetBorderColor(border_color)
				end
			end

			local setting_outlay_outline_color = settings:AddSetting(category_name, "color", "Outlay Outline цвет")
			setting_outlay_outline_color:SetColor(EasyChat.OutlayOutlineColor)
			setting_outlay_outline_color.OnValueChanged = function(_, color)
				EasyChat.OutlayOutlineColor = Color(color.r, color.g, color.b, color.a)
			end

			local setting_tab_color = settings:AddSetting(category_name, "color", "Tab цвет")
			setting_tab_color:SetColor(EasyChat.TabColor)
			setting_tab_color.OnValueChanged = function(_, color)
				EasyChat.TabColor = Color(color.r, color.g, color.b, color.a)

				local text_entry = EasyChat.GUI.TextEntry
				if IsValid(text_entry) and text_entry.ClassName == "TextEntryX" then
					text_entry:SetBackgroundColor(EasyChat.TabColor)
				end
			end

			local setting_tab_outline_color = settings:AddSetting(category_name, "color", "Tab Outline цвет")
			setting_tab_outline_color:SetColor(EasyChat.TabOutlineColor)
			setting_tab_outline_color.OnValueChanged = function(_, color)
				EasyChat.TabOutlineColor = Color(color.r, color.g, color.b, color.a)
				local text_entry = EasyChat.GUI.TextEntry

				if IsValid(text_entry) and text_entry.ClassName == "TextEntryX" then
					local border_color = EasyChat.TabOutlineColor.a == 0
						and EasyChat.OutlayColor or EasyChat.TabOutlineColor
					text_entry:SetBorderColor(border_color)
				end
			end

			-- needs to be done after color settings so we can apply the new colors to them
			setting_built_in_themes.DoClick = function()
				local themes_menu = DermaMenu()
				for theme_name, theme_data in pairs(built_in_themes) do
					themes_menu:AddOption(theme_name, function()
						setting_outlay_color:SetColor(theme_data.outlay)
						setting_outlay_outline_color:SetColor(theme_data.outlayoutline)
						setting_tab_color:SetColor(theme_data.tab)
						setting_tab_outline_color:SetColor(theme_data.taboutline)
					end)
				end

				themes_menu:AddSpacer()
				themes_menu:AddOption("Отмена", function() themes_menu:Remove() end)
				themes_menu:Open()
			end

			local setting_save_colors = settings:AddSetting(category_name, "action", "Сохранить цвета")
			setting_save_colors.DoClick = function()
				local text_entry = EasyChat.GUI.TextEntry
				if IsValid(text_entry) and text_entry.ClassName == "TextEntryX" then
					local border_color = EasyChat.TabOutlineColor.a == 0
						and EasyChat.OutlayColor or EasyChat.TabOutlineColor

					text_entry:SetBackgroundColor(EasyChat.TabColor)
					text_entry:SetBorderColor(border_color)
					text_entry:SetTextColor(EasyChat.TextColor)
				end

				file.Write("easychat/colors.txt", util.TableToJSON({
					outlay = EasyChat.OutlayColor,
					outlayoutline = EasyChat.OutlayOutlineColor,
					tab = EasyChat.TabColor,
					taboutline = EasyChat.TabOutlineColor,
				}, true))
			end

			local setting_reset_colors = settings:AddSetting(category_name, "action", "Сбросить цвета")
			setting_reset_colors.DoClick = function()
				local outlay_color = EasyChat.DefaultColors.outlay
				local outlay_outline_color = EasyChat.DefaultColors.outlayoutline
				local tab_color = EasyChat.DefaultColors.tab
				local tab_outline_color = EasyChat.DefaultColors.taboutline

				setting_outlay_color:SetColor(outlay_color)
				setting_outlay_outline_color:SetColor(outlay_outline_color)
				setting_tab_color:SetColor(tab_color)
				setting_tab_outline_color:SetColor(tab_outline_color)

				file.Write("easychat/colors.txt", util.TableToJSON({
					outlay = outlay_color,
					outlayoutline = outlay_outline_color,
					tab = tab_color,
					taboutline = tab_outline_color,
				}, true))

				EasyChat.OutlayColor = outlay_color
				EasyChat.OutlayOutlineColor = outlay_outline_color
				EasyChat.TabColor = tab_color
				EasyChat.TabOutlineColor = tab_outline_color
			end

			settings:AddSpacer(category_name)
		end

		settings:AddConvarSetting(category_name, "string", EC_FONT, "Шрифт")
		settings:AddConvarSetting(category_name, "number", EC_FONT_SIZE, "Размер шрифта", 128, 5)

		cvars.RemoveChangeCallback(EC_FONT:GetName(), EC_FONT:GetName())
		cvars.RemoveChangeCallback(EC_FONT_SIZE:GetName(), EC_FONT_SIZE:GetName())

		local function font_change_callback() settings:InvalidateChildren(true) end
		cvars.AddChangeCallback(EC_FONT:GetName(), font_change_callback, EC_FONT:GetName())
		cvars.AddChangeCallback(EC_FONT_SIZE:GetName(), font_change_callback, EC_FONT_SIZE:GetName())

		local setting_reset_font = settings:AddSetting(category_name, "action", "Сбросить шрифт")
		setting_reset_font.DoClick = function()
			local default_font, default_font_size = EC_FONT:GetDefault(), tonumber(EC_FONT_SIZE:GetDefault())
			EC_FONT:SetString(default_font)
			EC_FONT_SIZE:SetInt(default_font_size)
		end

		settings:AddSpacer(category_name)

		local setting_tabs = settings:AddSetting(category_name, "list", "Вкладки")
		local tab_list = setting_tabs.List
		tab_list:SetMultiSelect(true)
		tab_list:AddColumn("Имя")
		tab_list:AddColumn("Скрыта")

		local function show_or_hide_tab(selected_line)
			local tab_name = selected_line:GetColumnText(1)
			local tab_data = EasyChat.GetTab(tab_name)
			if tab_data then
				local is_visible = tab_data.Tab:IsVisible()
				tab_data.Tab:SetVisible(not is_visible)

				-- this is inverted, because we get IsVisible before setting it
				selected_line:SetColumnText(2, is_visible and "Да" or "Нет")
			end
		end

		tab_list.DoDoubleClick = function(_, _, line)
			show_or_hide_tab(line)
		end

		tab_list.OnRowRightClick = function(_, _, line)
			local tab_menu = DermaMenu()

			tab_menu:AddOption(line:GetColumnText(2) == "Да" and "Показать" or "Скрыть", function()
				show_or_hide_tab(line)
			end)
			tab_menu:AddSpacer()
			tab_menu:AddOption("Restrict", function()
				local succ, err = EasyChat.Config:WriteTab(line:GetColumnText(1), false)
				if not succ then
					notification.AddLegacy(err, NOTIFY_ERROR, 3)
					surface.PlaySound("buttons/button11.wav")
				end
			end):SetImage("icon16/shield.png")
			tab_menu:AddSpacer()
			tab_menu:AddOption("Cancel", function() tab_menu:Remove() end)

			tab_menu:Open()
		end

		local tab_class_blacklist = {
			["ECChatTab"] = true,
			["ECSettingsTab"] = true,
		}

		local function build_tab_list()
			tab_list:Clear()

			for tab_name, tab_data in pairs(EasyChat.GetTabs()) do
				if not tab_class_blacklist[tab_data.Panel.ClassName] then
					tab_list:AddLine(tab_name, tab_data.Tab:IsVisible() and "Нет" or "ДА")
				end
			end
		end

		build_tab_list()
		hook.Add("ECSettingsOpened", tab_list, build_tab_list)

		local setting_apply_tab = settings:AddSetting(category_name, "action", "Скрыть / Показать вкладку")
		setting_apply_tab.DoClick = function()
			local selected_lines = tab_list:GetSelected()
			for _, selected_line in pairs(selected_lines) do
				show_or_hide_tab(selected_line)
			end
		end

		local setting_manage_tabs = settings:AddSetting(category_name, "action", "(ADMIN) Управление вкладками")
		setting_manage_tabs:SetImage("icon16/shield.png")
		setting_manage_tabs.DoClick = function()
			local frame = EasyChat.CreateFrame()
			frame:SetSize(400, 285)
			frame:SetTitle("Управление вкладками")

			local setting_restricted_tabs = settings:AddSetting(category_name, "list", "Запрещенные вкладки")
			setting_restricted_tabs:SetParent(frame)

			local frame_tab_list = setting_restricted_tabs.List
			frame_tab_list:SetMultiSelect(true)
			frame_tab_list:AddColumn("Имя вкладки")

			local function build_frame_tab_list()
				frame_tab_list:Clear()

				for tab_name, is_allowed in pairs(EasyChat.Config.Tabs) do
					if not is_allowed then
						frame_tab_list:AddLine(tab_name)
					end
				end
			end

			build_frame_tab_list()
			hook.Add("ECServerConfigUpdate", frame, build_frame_tab_list)

			local setting_unrestrict_tab = settings:AddSetting(category_name, "action", "Разрешить вкладку")
			setting_unrestrict_tab:SetParent(frame)
			setting_unrestrict_tab:SetImage("icon16/shield.png")
			setting_unrestrict_tab.DoClick = function()
				local lines = frame_tab_list:GetSelected()
				for _, line in pairs(lines) do
					local succ, err = EasyChat.Config:WriteTab(line:GetColumnText(1), true)
					if not succ then
						notification.AddLegacy(err, NOTIFY_ERROR, 3)
						surface.PlaySound("buttons/button11.wav")
						break
					end
				end
			end

			local spacer = settings:AddSpacer(category_name)
			spacer:SetParent(frame)
			spacer:DockMargin(10, 0, 10, 20)

			local setting_restrict_tab_name = settings:AddSetting(category_name, "string", "Имя вкладки")
			setting_restrict_tab_name:SetParent(frame)
			setting_restrict_tab_name.OnEnter = function(self)
				local succ, err = EasyChat.Config:WriteTab(self:GetText(), false)
				if not succ then
					notification.AddLegacy(err, NOTIFY_ERROR, 3)
					surface.PlaySound("buttons/button11.wav")
				end
			end

			local setting_restrict_tab = settings:AddSetting(category_name, "action", "Запретить вкладку")
			setting_restrict_tab:SetParent(frame)
			setting_restrict_tab:SetImage("icon16/shield.png")
			setting_restrict_tab.DoClick = function()
				setting_restrict_tab_name:OnEnter()
			end

			frame:Center()
			frame:MakePopup()
		end

		settings:AddSpacer(category_name)

		if EasyChat.GUI.RichText and EasyChat.GUI.RichText.ClassName == "RichTextX" then
			settings:AddConvarSetting(category_name, "number", EC_MODERN_TEXT_HISTORY_LIMIT, "Размер истории чата", 5000, -1)
		end

		if EasyChat.CanUseCEFFeatures() then
			local setting_legacy_entry = settings:AddSetting(category_name, "action", EC_LEGACY_ENTRY:GetBool() and "Использовать современный Textbox" or "Использовать устаревший Textbox")
			setting_legacy_entry.DoClick = function()
				EC_LEGACY_ENTRY:SetBool(not EC_LEGACY_ENTRY:GetBool())
			end

			local setting_legacy_text = settings:AddSetting(category_name, "action", EC_LEGACY_TEXT:GetBool() and "Использовать современный RichText" or "Использовать устаревший RichText")
			setting_legacy_text.DoClick = function()
				EC_LEGACY_TEXT:SetBool(not EC_LEGACY_TEXT:GetBool())
			end
		end

		local setting_dermaskin = settings:AddSetting(category_name, "action", EC_USE_DERMASKIN:GetBool() and "Использовать кастомный скин" or "Использовать дермаскин")
		setting_dermaskin.DoClick = function()
			EC_USE_DERMASKIN:SetBool(not EC_USE_DERMASKIN:GetBool())
		end

		local setting_clear_history = settings:AddSetting(category_name, "action", "Очистить историю")
		setting_clear_history.DoClick = function()
			local files, _ = file.Find("easychat/history/*_history.txt", "DATA")
			for _, f in pairs(files) do
				file.Delete("easychat/" .. f)
			end

			EasyChat.Reload()
		end
	end

	-- chathud settings
	do
		local category_name = "Чат HUD"
		settings:AddCategory(category_name)

		local function create_admin_shield_icon(src_panel)
			local icon = vgui.Create("DButton", src_panel:GetParent())
			icon:SetImage("icon16/shield.png")
			icon:SetSize(20, 20)
			icon.Paint = function() end

			icon.Think = function(self)
				if not IsValid(src_panel) then return end
				local x, y = src_panel:GetPos()
				surface.SetFont(src_panel.Label:GetFont() or "DermaDefault")
				local w, _ = surface.GetTextSize(src_panel.Label:GetText() .. (" "):rep(4))

				self:SetPos(x + w + 50, y)
			end

			return icon
		end

		local setting_tags_names = settings:AddSetting(category_name, "boolean", "(ADMIN) Разрешить теги в именах")
		create_admin_shield_icon(setting_tags_names)

		local setting_tags_msgs = settings:AddSetting(category_name, "boolean", "(ADMIN) Разрешить теги в сообщениях")
		create_admin_shield_icon(setting_tags_msgs)

		setting_tags_names:SetChecked(EasyChat.Config.AllowTagsInNames)
		setting_tags_msgs:SetChecked(EasyChat.Config.AllowTagsInMessages)

		setting_tags_names.OnChange = function(self, enabled)
			local succ, err = EasyChat.Config:WriteTagsInNames(enabled)
			if not succ then
				notification.AddLegacy(err, NOTIFY_ERROR, 3)
				surface.PlaySound("buttons/button11.wav")
				self:SetChecked(EasyChat.Config.AllowTagsInNames)
			end
		end

		setting_tags_msgs.OnChange = function(self, enabled)
			local succ, err = EasyChat.Config:WriteTagsInMessages(enabled)
			if not succ then
				notification.AddLegacy(err, NOTIFY_ERROR, 3)
				surface.PlaySound("buttons/button11.wav")
				self:SetChecked(EasyChat.Config.AllowTagsInMessages)
			end
		end

		hook.Add("ECServerConfigUpdate", setting_tags_msgs, function(_, config)
			setting_tags_names:SetChecked(config.AllowTagsInNames)
			setting_tags_msgs:SetChecked(config.AllowTagsInMessages)
		end)

		settings:AddSpacer(category_name)

		local setting_font_editor = settings:AddSetting(category_name, "action", "Редактор шрифтов")
		setting_font_editor.DoClick = function()
			local editor = vgui.Create("ECChatHUDFontEditor")
			editor:MakePopup()
			editor:Center()
		end

		concommand.Add("chathud_font_editor", setting_font_editor.DoClick)

		settings:AddSpacer(category_name)

		settings:AddConvarSettingsSet(category_name, {
			[EC_HUD_FOLLOW] = "Следовать за окном чатбокса",
			[EC_HUD_SMOOTH] = "Плавные переходы между сообщениями",
			[EC_HUD_SH_CLEAR] = "Очистить теги, сказав \'sh\'",
			[EC_HUD_CUSTOM] = "Использовать кастомный EasyChat's HUD",
		})

		settings:AddSpacer(category_name)

		settings:AddConvarSetting(category_name, "number", EC_HUD_WIDTH, "Ширина HUD-а", 1250, 250)
		settings:AddConvarSetting(category_name, "number", EC_HUD_POS_X, "X Позиция HUD-а", 5000, 0)
		settings:AddConvarSetting(category_name, "number", EC_HUD_POS_Y, "Y Позиция HUD-а", 5000, 0)

		local setting_reset_hud_bounds = settings:AddSetting(category_name, "action", "Сброс границ HUD")
		setting_reset_hud_bounds.DoClick = function()
			EC_HUD_WIDTH:SetInt(-1)
			EC_HUD_POS_X:SetInt(-1)
			EC_HUD_POS_Y:SetInt(-1)
		end

		settings:AddSpacer(category_name)

		settings:AddConvarSetting(category_name, "number", EC_HUD_TTL, "Время жизни сообщения", 60, 2)
		settings:AddConvarSetting(category_name, "number", EC_HUD_FADELEN, "Время затухания сообщения", 5, 1)

		local setting_reset_duration = settings:AddSetting(category_name, "action", "Сбросить время жизни/затухения сообщения")
		setting_reset_duration.DoClick = function()
			local default_duration = tonumber(EC_HUD_TTL:GetDefault())
			EC_HUD_TTL:SetInt(default_duration)

			local default_fadelen = tonumber(EC_HUD_FADELEN:GetDefault())
			EC_HUD_FADELEN:SetInt(default_fadelen)
		end
	end

	-- ranks / usergroups settings
	do
		local category_name = "Ранги"
		settings:AddCategory(category_name)

		local setting_override_client_settings = settings:AddSetting(category_name, "boolean", "Настройки сервера переопределяют настройки клиента")
		setting_override_client_settings:SetChecked(EasyChat.Config.OverrideClientSettings)
		setting_override_client_settings.OnChange = function(self, enabled)
			local succ, err = EasyChat.Config:WriteSettingOverride(enabled)
			if not succ then
				notification.AddLegacy(err, NOTIFY_ERROR, 3)
				surface.PlaySound("buttons/button11.wav")
				self:SetChecked(EasyChat.Config.OverrideClientSettings)
			end
		end

		settings:AddSpacer(category_name)

		local setting_usergroups = settings:AddSetting(category_name, "list", "Префиксы рангов")
		local prefix_list = setting_usergroups.List
		prefix_list:SetMultiSelect(true)
		prefix_list:AddColumn("Группа")
		prefix_list:AddColumn("Эмоция")
		prefix_list:AddColumn("Тег")

		local function build_emote_tag(emote_name, emote_size, emote_provider)
			local emote_tag = ""
			if #emote_name > 0 then
				emote_tag = ("<emote=%s"):format(emote_name)
				if emote_size ~= -1 then
					emote_tag = ("%s,%d"):format(emote_tag, emote_size)
				end

				if #emote_provider > 0 then
					-- add a comma for proper markup parsing
					if emote_size == -1 then
						emote_tag = ("%s,"):format(emote_tag)
					end

					emote_tag = ("%s,%s"):format(emote_tag, emote_provider)
				end

				emote_tag = ("%s>"):format(emote_tag)
			end

			return emote_tag
		end

		local function setup_rank(usergroup)
			-- usergroup = usergroup or "user"

			-- sanity check to see if wanted usergroup actually exists
			--if usergroup and not EasyChat.Config.UserGroups[usergroup] then return end

			local frame = EasyChat.CreateFrame()
			frame:SetSize(400, 400)
			frame:SetTitle(usergroup and "Modify Rank" or "New Rank")

			local setting_usergroup = settings:AddSetting(category_name, "string", "Usergroup")
			setting_usergroup:SetParent(frame)
			setting_usergroup:DockMargin(5, 20, 5, 10)
			if usergroup then
				setting_usergroup:SetText(usergroup)
			end

			local setting_emote_name = settings:AddSetting(category_name, "string", "Emote")
			setting_emote_name:SetParent(frame)
			setting_emote_name:DockMargin(5, 15, 5, 10)
			if usergroup then
				local prefix_data = EasyChat.Config.UserGroups[usergroup]
				local text = build_emote_tag(prefix_data.EmoteName, prefix_data.EmoteSize or -1, prefix_data.EmoteProvider or ""):match("<emote=(.*)>")
				if text then
					setting_emote_name:SetText(text)
				end
			end

			local setting_tag = settings:AddSetting(category_name, "string", "Tag")
			setting_tag:SetParent(frame)
			setting_tag:DockMargin(5, 15, 5, 10)
			if usergroup then
				setting_tag:SetText(EasyChat.Config.UserGroups[usergroup].Tag)
			end

			local setting_save = settings:AddSetting(category_name, "action", "Save")
			setting_save:SetParent(frame)
			setting_save:Dock(BOTTOM)
			setting_save:DockMargin(5, 10, 5, 5)
			setting_save.DoClick = function()
				local emote_components = setting_emote_name:GetText():Split(",")
				-- emote_name, emote_size, emote_provider

				local succ, err = EasyChat.Config:WriteUserGroup(
					setting_usergroup:GetText(),
					setting_tag:GetText(),
					emote_components[1], -- emote name
					emote_components[2], -- emote size
					emote_components[3] -- emote provider
				)

				if not succ then
					notification.AddLegacy(err, NOTIFY_ERROR, 3)
					surface.PlaySound("buttons/button11.wav")
				else
					frame:Close()
				end
			end

			local mk = nil
			local function build_mk()
				if not IsValid(frame) then return end

				local input_str = ("%s<stop>"):format(setting_tag:GetText():Trim())
				local emote_components =  setting_emote_name:GetText():Split(",")
				local emote_tag = build_emote_tag(
					emote_components[1]:Trim(), -- emote name
					tonumber(emote_components[2]) or -1, -- emote size
					(emote_components[3] or ""):Trim() -- emote provider
				)

				if #emote_tag > 0 then
					input_str = ("%s %s"):format(input_str, emote_tag)
				end

				input_str = ("%s %s<stop>: Hello!"):format(input_str, LocalPlayer():RichNick())
				mk = ec_markup.Parse(input_str)
			end

			build_mk()
			setting_emote_name.OnChange = function()
				timer.Create("ECUserGroupPrefixSetup", 0.25, 1, build_mk)
			end

			setting_tag.OnChange = function()
				timer.Create("ECUserGroupPrefixSetup", 0.25, 1, build_mk)
			end

			local setting_canvas = frame:Add("DPanel")
			setting_canvas:Dock(FILL)
			setting_canvas:DockMargin(5, 10, 5, 5)
			setting_canvas.Paint = function(_, w, h)
				surface.SetDrawColor(color_white)
				surface.DrawOutlinedRect(0, 0, w, h)

				if mk then
					local mk_w, mk_h = mk:GetWide(), mk:GetTall()
					mk:Draw(w / 2 - mk_w / 2, h / 2 - mk_h / 2)
				end
			end

			frame:MakePopup()
			frame:Center()
		end

		local function modify_rank()
			local selected_lines = prefix_list:GetSelected()
			for _, line in pairs(selected_lines) do
				local usergroup = line:GetColumnText(1)
				setup_rank(usergroup)
			end
		end

		local function delete_rank()
			local selected_lines = prefix_list:GetSelected()
			for _, line in pairs(selected_lines) do
				local usergroup = line:GetColumnText(1)
				local succ, err = EasyChat.Config:DeleteUserGroup(usergroup)
				if not succ then
					notification.AddLegacy(err, NOTIFY_ERROR, 3)
					surface.PlaySound("buttons/button11.wav")
					break
				end
			end
		end

		prefix_list.DoDoubleClick = function(_, _, line)
			setup_rank(line:GetColumnText(1))
		end

		prefix_list.OnRowRightClick = function()
			local prefix_menu = DermaMenu()
			prefix_menu:AddOption("Modify", modify_rank):SetImage("icon16/shield.png")
			prefix_menu:AddOption("Delete", delete_rank):SetImage("icon16/shield.png")
			prefix_menu:AddSpacer()
			prefix_menu:AddOption("Cancel", function() prefix_menu:Remove() end)
			prefix_menu:Open()
		end

		local function build_usergroup_list()
			prefix_list:Clear()

			for usergroup, prefix_data in pairs(EasyChat.Config.UserGroups) do
				local emote_display = build_emote_tag(prefix_data.EmoteName, prefix_data.EmoteSize or -1, prefix_data.EmoteProvider or "")
				local line = prefix_list:AddLine(usergroup, emote_display, prefix_data.Tag)

				local input_str = ("%s<stop>"):format(prefix_data.Tag)
				if #emote_display > 0 then
					input_str = ("%s %s"):format(input_str, emote_display)
				end

				input_str = ("%s %s"):format(input_str, LocalPlayer():RichNick())
				local mk = ec_markup.Parse(input_str)
				local mk_w, mk_h = mk:GetWide(), mk:GetTall()

				local tooltip = vgui.Create("Panel")
				tooltip:SetVisible(false)
				tooltip:SetDrawOnTop(true)
				tooltip:SetWide(mk_w + 10)
				tooltip:SetTall(mk_h + 10)
				tooltip.Paint = function(_, w, h)
					if not settings:IsVisible() then return end
					mk:Draw(w / 2 - mk_w / 2, h / 2 - mk_h / 2)
				end

				line.Think = function(self)
					local is_hovered = self:IsHovered()
					tooltip:SetVisible(is_hovered)
					local mx, my = gui.MousePos()
					tooltip:SetPos(mx, my)
				end

				line.OnRemove = function()
					if not IsValid(tooltip) then return end
					tooltip:Remove()
				end
			end
		end

		build_usergroup_list()

		local setting_add_usergroup = settings:AddSetting(category_name, "action", "(ADMIN) Создать новый ранг")
		setting_add_usergroup:SetImage("icon16/shield.png")
		setting_add_usergroup.DoClick = function()
			setup_rank()
		end

		local setting_modify_usergroup = settings:AddSetting(category_name, "action", "(ADMIN) Модифицировать ранг")
		setting_modify_usergroup:SetImage("icon16/shield.png")
		setting_modify_usergroup.DoClick = modify_rank

		local setting_del_usergroup = settings:AddSetting(category_name, "action", "(ADMIN) Удалить ранг")
		setting_del_usergroup:SetImage("icon16/shield.png")
		setting_del_usergroup.DoClick = delete_rank

		hook.Add("ECServerConfigUpdate", settings, function(_, config)
			setting_override_client_settings:SetChecked(config.OverrideClientSettings)
			build_usergroup_list()
		end)
	end

	-- translation
	do
		local category_name = "Перевод"
		settings:AddCategory(category_name)

		local valid_languages = {
			["Automatic"] = "auto",

			["Afrikaans"] = "af", ["Irish"] = "ga", ["Albanian"] = "sq", ["Italian"] = "it", ["Arabic"] = "ar", ["Japanese"] = "ja",
			["Azerbaijani"] = "az", ["Kannada"] = "kn", ["Basque"] = "eu", ["Korean"] = "ko", ["Bengali"] = "bn", ["Latin"] = "la",
			["Belarusian"] = "be", ["Latvian"] = "lv", ["Bulgarian"] =	"bg", ["Lithuanian"] = "lt", ["Catalan"] = "ca",
			["Macedonian"] = "mk", ["Chinese Simplified"] = "zh-CN", ["Malay"] =	"ms", ["Chinese Traditional"] = "zh-TW", ["Maltese"] = "mt",
			["Croatian"] = "hr", ["Norwegian"] = "no", ["Czech"] = "cs", ["Persian"] = "fa", ["Danish"] = "da", ["Polish"] = "pl", ["Dutch"] = "nl",
			["Portuguese"] = "pt", ["English"] = "en", ["Romanian"] = "ro", ["Esperanto"] =	"eo", ["Russian"] = "ru", ["Estonian"] = "et", ["Serbian"] = "sr",
			["Filipino"] = "tl", ["Slovak"] = "sk", ["Finnish"] = "fi", ["Slovenian"] =	"sl", ["French"] = "fr", ["Spanish"] = "es", ["Galician"] = "gl",
			["Swahili"] = "sw", ["Georgian"] = "ka", ["Swedish"] = "sv", ["German"] = "de", ["Tamil"] =	"ta", ["Greek"] = "el", ["Telugu"] = "te",
			["Gujarati"] = "gu", ["Thai"] = "th", ["Haitian Creole"] = "ht", ["Turkish"] = "tr", ["Hebrew"] = "iw", ["Ukrainian"] =	"uk", ["Hindi"] = "hi",
			["Urdu"] = "ur", ["Hungarian"] = "hu", ["Vietnamese"] = "vi", ["Icelandic"] = "is", ["Welsh"] = "cy", ["Indonesian"] = "id", ["Yiddish"] = "yi",
		}

		local language_count = table.Count(valid_languages)

		local function build_translation_auto_complete(text_entry, is_target)
			text_entry.GetAutoComplete = function(self, text)
				text = text:lower()

				local suggestions = {}
				for complete_name, shortcut in pairs(valid_languages) do
					if is_target and shortcut == "auto" then continue end -- dont show auto as a target language
					if complete_name:lower():match(text) or shortcut:match(text) then
						table.insert(suggestions, ("%s (%s)"):format(shortcut, complete_name))
					end
				end

				return suggestions
			end

			local language_selection = 1
			local language_input = ""
			text_entry.OnKeyCodeTyped = function(self, key_code)
				if key_code == KEY_TAB then
					local suggestion = self:GetAutoComplete(language_input)[language_selection]
					if suggestion then
						local country_code = suggestion:match("^(.+)%s%(")
						self:SetText(country_code)
						EasyChat.RunOnNextFrame(function()
							self:RequestFocus()  -- keep focus
							self:SetCaretPos(#self:GetText())
						end)
					end

					language_selection = language_selection + 1
					if language_selection > language_count then
						language_selection = 1
					end
				elseif key_code == KEY_ENTER or key_code == KEY_PAD_ENTER then
					if IsValid(self.Menu) then self.Menu:Remove() end
					self:OnEnter()
					EasyChat.RunOnNextFrame(function()
						self:RequestFocus()  -- keep focus
						self:SetCaretPos(#self:GetText())
					end)
				else
					language_input = self:GetText()
					language_selection = 1
				end
			end

			local old_enter = text_entry.OnEnter
			function text_entry.OnEnter(self)
				local country_code = self:GetText():match("^(.+)%s%(")
				if country_code then
					self:SetText(country_code)
				end

				country_code = self:GetText():Trim()
				if not table.HasValue(valid_languages, country_code) then
					notification.AddLegacy("Неверный код страны", NOTIFY_ERROR, 3)
					surface.PlaySound("buttons/button11.wav")
					return
				elseif not util.IsBinaryModuleInstalled("ollama") then
					notification.AddLegacy("Бинарный модуль Ollama не установлен", NOTIFY_ERROR, 3)
					surface.PlaySound("buttons/button11.wav")
					return
				elseif not Ollama or not Ollama.IsRunning() then
					notification.AddLegacy("Ollama не запущен. Пожалуйста запустите Ollama сервер", NOTIFY_ERROR, 3)
					surface.PlaySound("buttons/button11.wav")
					return
				end

				old_enter(self)
			end

			return text_entry
		end

		-- Ollama status indicator
		local ollama_status = settings:GetCategory(category_name):Add("DLabel")
		ollama_status:SetFont("ECSettingsFont")
		ollama_status:Dock(TOP)
		ollama_status:DockMargin(10, 0, 10, 5)
		ollama_status:SetAutoStretchVertical(true)

		local function update_ollama_status()
			if not IsValid(ollama_status) then return end

			if not util.IsBinaryModuleInstalled("ollama") then
				ollama_status:SetText("Бинарный модуль Ollama не установлен")
				ollama_status:SetTextColor(Color(220, 0, 0))
			elseif not Ollama or not Ollama.IsRunning() then
				ollama_status:SetText("Ollama сервер не запущен (localhost:11434)")
				ollama_status:SetTextColor(Color(220, 120, 0))
			else
				ollama_status:SetText("Ollama готова - Используется модель gemma3 для перевода")
				ollama_status:SetTextColor(Color(0, 180, 0))

				Ollama.IsModelAvailable("gemma3", function(err, available)
					if err then
						ollama_status:SetText("Ошибка при проверке доступности модели")
						ollama_status:SetTextColor(Color(220, 0, 0))
					end

					if not available then
						ollama_status:SetText("Gemma3 модель недоступна")
						ollama_status:SetTextColor(Color(220, 0, 0))
					end
				end)
			end
		end

		update_ollama_status()
		timer.Create("ECOllamaStatusCheck", 5, 0, update_ollama_status)

		local ollama_help = settings:AddSetting(category_name, "action", "Руководство по установке и использованию")
		ollama_help.DoClick = function()
			local frame = EasyChat.CreateFrame()
			frame:SetSize(600, 700)
			frame:SetTitle("Руководство по установке Ollama")

			local content = frame:Add("DPanel")
			content:Dock(FILL)
			content.Paint = function() end

			local y_offset = 10

			-- Title
			local title = content:Add("DLabel")
			title:SetPos(10, y_offset)
			title:SetText("Следуйте этим шагам для установки Ollama переводчика:")
			title:SetFont("DermaDefaultBold")
			title:SetTextColor(EasyChat.TextColor)
			title:SizeToContents()
			y_offset = y_offset + 25

			-- What is Ollama explanation
			local ollama_explanation = content:Add("DLabel")
			ollama_explanation:SetPos(10, y_offset)
			ollama_explanation:SetText("Ollama — это локальный AI сервер, который запускает языковые модели (LLM) на вашем компьютере.")
			ollama_explanation:SetTextColor(EasyChat.TextColor)
			ollama_explanation:SizeToContents()
			y_offset = y_offset + 20

			local ollama_explanation2 = content:Add("DLabel")
			ollama_explanation2:SetPos(10, y_offset)
			ollama_explanation2:SetText("Это позволяет выполнять приватные офлайн-переводы без отправки данных на другие сервера.")
			ollama_explanation2:SetTextColor(EasyChat.TextColor)
			ollama_explanation2:SizeToContents()
			y_offset = y_offset + 35

			-- Step 1
			local step1_title = content:Add("DLabel")
			step1_title:SetPos(10, y_offset)
			step1_title:SetText("Step 1: Установите gm_ollama модуль")
			step1_title:SetFont("DermaDefaultBold")
			step1_title:SetTextColor(EasyChat.TextColor)
			step1_title:SizeToContents()
			y_offset = y_offset + 25

			local step1_desc = content:Add("DLabel")
			step1_desc:SetPos(20, y_offset)
			step1_desc:SetText("Скачайте и установите бинарный модуль gm_ollama отсюда:")
			step1_desc:SetTextColor(EasyChat.TextColor)
			step1_desc:SizeToContents()
			y_offset = y_offset + 20

			local step1_link = content:Add("DLabelURL")
			step1_link:SetPos(20, y_offset)
			step1_link:SetText("https://github.com/Earu/gm_ollama/releases")
			step1_link:SetURL("https://github.com/Earu/gm_ollama/releases")
			step1_link:SetColor(Color(100, 149, 237))
			step1_link:SizeToContents()
			y_offset = y_offset + 35

			-- Step 2
			local step2_title = content:Add("DLabel")
			step2_title:SetPos(10, y_offset)
			step2_title:SetText("Step 2: Установите сервер Ollama")
			step2_title:SetFont("DermaDefaultBold")
			step2_title:SetTextColor(EasyChat.TextColor)
			step2_title:SizeToContents()
			y_offset = y_offset + 25

			local step2_desc = content:Add("DLabel")
			step2_desc:SetPos(20, y_offset)
			step2_desc:SetText("Если у вас не установлена Ollama, загрузите его с сайта:")
			step2_desc:SetTextColor(EasyChat.TextColor)
			step2_desc:SizeToContents()
			y_offset = y_offset + 20

			local step2_link = content:Add("DLabelURL")
			step2_link:SetPos(20, y_offset)
			step2_link:SetText("https://ollama.com/download")
			step2_link:SetURL("https://ollama.com/download")
			step2_link:SetColor(Color(100, 149, 237))
			step2_link:SizeToContents()
			y_offset = y_offset + 35

			-- Step 3
			local step3_title = content:Add("DLabel")
			step3_title:SetPos(10, y_offset)
			step3_title:SetText("Step 3: Установить модель перевода")
			step3_title:SetFont("DermaDefaultBold")
			step3_title:SetTextColor(EasyChat.TextColor)
			step3_title:SizeToContents()
			y_offset = y_offset + 25

			local step3_desc = content:Add("DLabel")
			step3_desc:SetPos(20, y_offset)
			step3_desc:SetText("Откройте терминал/командную строку и напишите:")
			step3_desc:SetTextColor(EasyChat.TextColor)
			step3_desc:SizeToContents()
			y_offset = y_offset + 20

			local step3_cmd = content:Add("DLabel")
			step3_cmd:SetPos(20, y_offset)
			step3_cmd:SetText("ollama pull gemma3")
			step3_cmd:SetFont("DebugOverlay")
			step3_cmd:SetTextColor(Color(0, 150, 0))
			step3_cmd:SizeToContents()
			y_offset = y_offset + 25

			local step3_note = content:Add("DLabel")
			step3_note:SetPos(20, y_offset)
			step3_note:SetText("Это загрузит модель Gemma3 (~5 ГБ). Это может занять некоторое время.")
			step3_note:SetTextColor(EasyChat.TextColor)
			step3_note:SizeToContents()
			y_offset = y_offset + 35

			-- Step 4
			local step4_title = content:Add("DLabel")
			step4_title:SetPos(10, y_offset)
			step4_title:SetText("Step 4: Перезапустить EasyChat")
			step4_title:SetFont("DermaDefaultBold")
			step4_title:SetTextColor(EasyChat.TextColor)
			step4_title:SizeToContents()
			y_offset = y_offset + 25

			local step4_desc = content:Add("DLabel")
			step4_desc:SetPos(20, y_offset)
			step4_desc:SetText("Напишите в игровой консоли:")
			step4_desc:SetTextColor(EasyChat.TextColor)
			step4_desc:SizeToContents()
			y_offset = y_offset + 20

			local step4_cmd = content:Add("DLabel")
			step4_cmd:SetPos(20, y_offset)
			step4_cmd:SetText("easychat_reload")
			step4_cmd:SetFont("DebugOverlay")
			step4_cmd:SetTextColor(Color(0, 150, 0))
			step4_cmd:SizeToContents()
			y_offset = y_offset + 35

			-- Final note
			local final_note = content:Add("DLabel")
			final_note:SetPos(10, y_offset)
			final_note:SetText("После выполнения этих шагов индикатор состояния выше должен показывать 'Ollama ready'.")
			final_note:SetFont("DermaDefaultBold")
			final_note:SetTextColor(EasyChat.TextColor)
			final_note:SizeToContents()
			y_offset = y_offset + 35

			-- Performance note
			local perf_note_title = content:Add("DLabel")
			perf_note_title:SetPos(10, y_offset)
			perf_note_title:SetText("Примечание к производительности:")
			perf_note_title:SetFont("DermaDefaultBold")
			perf_note_title:SetTextColor(Color(220, 120, 0))
			perf_note_title:SizeToContents()
			y_offset = y_offset + 25

			local perf_note = content:Add("DLabel")
			perf_note:SetPos(20, y_offset)
			perf_note:SetText("Переводы могут выполняться медленно на старых или системах без GPU.")
			perf_note:SetTextColor(EasyChat.TextColor)
			perf_note:SizeToContents()
			y_offset = y_offset + 20

			local perf_note2 = content:Add("DLabel")
			perf_note2:SetPos(20, y_offset)
			perf_note2:SetText("Первый перевод может занять больше времени, так как модель загружается в память.")
			perf_note2:SetTextColor(EasyChat.TextColor)
			perf_note2:SizeToContents()
			y_offset = y_offset + 25

			-- Troubleshooting
			local trouble_title = content:Add("DLabel")
			trouble_title:SetPos(10, y_offset)
			trouble_title:SetText("Решение проблем:")
			trouble_title:SetFont("DermaDefaultBold")
			trouble_title:SetTextColor(EasyChat.TextColor)
			trouble_title:SizeToContents()
			y_offset = y_offset + 25

			local trouble_desc = content:Add("DLabel")
			trouble_desc:SetPos(20, y_offset)
			trouble_desc:SetText("• Убедитесь, что сервер Ollama запущен (он должен запуститься автоматически)")
			trouble_desc:SetTextColor(EasyChat.TextColor)
			trouble_desc:SizeToContents()
			y_offset = y_offset + 20

			local trouble_desc2 = content:Add("DLabel")
			trouble_desc2:SetPos(20, y_offset)
			trouble_desc2:SetText("• Убедитесь, что модель Gemma3 успешно загружен.")
			trouble_desc2:SetTextColor(EasyChat.TextColor)
			trouble_desc2:SizeToContents()
			y_offset = y_offset + 20

			local trouble_desc3 = content:Add("DLabel")
			trouble_desc3:SetPos(20, y_offset)
			trouble_desc3:SetText("• Убедитесь, что модуль gm_ollama находится в папке garrysmod/lua/bin")
			trouble_desc3:SetTextColor(EasyChat.TextColor)
			trouble_desc3:SizeToContents()

			frame:Center()
			frame:MakePopup()
		end

		settings:AddSpacer(category_name)

		local translate_out_msg = settings:AddConvarSetting(category_name, "boolean", EC_TRANSLATE_OUT_MSG, "Переводить ваши сообщения")
		translate_out_msg:GetParent():DockMargin(10, 0, 0, 20)
		build_translation_auto_complete(settings:AddConvarSetting(category_name, "string", EC_TRANSLATE_OUT_SRC_LANG, "Ваш язык"))
		build_translation_auto_complete(settings:AddConvarSetting(category_name, "string", EC_TRANSLATE_OUT_TARGET_LANG, "Их язык"), true)

		settings:AddSpacer(category_name)

		local translate_inc_msg = settings:AddConvarSetting(category_name, "boolean", EC_TRANSLATE_INC_MSG, "Переводить чужие сообщения")
		translate_inc_msg:GetParent():DockMargin(10, 0, 0, 20)
		build_translation_auto_complete(settings:AddConvarSetting(category_name, "string", EC_TRANSLATE_INC_TARGET_LANG, "Ваш язык"), true)
		build_translation_auto_complete(settings:AddConvarSetting(category_name, "string", EC_TRANSLATE_INC_SRC_LANG, "Их язык"))
	end
end

local function add_chathud_markup_settings()
	local settings = EasyChat.Settings
	local category_name = "Чат HUD"

	settings:AddSpacer(category_name)

	local setting_help = settings:AddSetting(category_name, "action", "Показать помощь/примеры")
	setting_help.DoClick = function()
		RunConsoleCommand("easychat_hud_examples")
	end

	local tag_options = {}
	for part_name, _ in pairs(EasyChat.ChatHUD.Parts) do
		local cvar = get_cvar("easychat_tag_" .. part_name)
		if cvar then
			tag_options[cvar] = ("%s теги"):format(part_name)
		end
	end

	settings:AddConvarSettingsSet(category_name, tag_options)
end

local function add_legacy_settings()
	local registered_cvars = EasyChat.GetRegisteredConvars()
	if #registered_cvars == 0 then return end

	local options = {}
	for _, registered_cvar in pairs(registered_cvars) do
		options[registered_cvar.Convar] = registered_cvar.Description
	end

	EasyChat.Settings:AddConvarSettingsSet("Другое", options)
end

hook.Add("ECPreLoadModules", "EasyChatDefaultSettings", create_default_settings)
hook.Add("ECPostLoadModules", "EasyChatDefaultSettings", function()
	add_chathud_markup_settings()
	add_legacy_settings()
end)
