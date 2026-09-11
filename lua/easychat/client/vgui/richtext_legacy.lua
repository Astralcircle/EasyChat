local PANEL = {}

function PANEL:Init()
	local last_color = self:GetFGColor()
	local old_insert_color_change = self.InsertColorChange

	self.InsertColorChange = function(self, r, g, b, a)
		last_color = istable(r) and Color(r.r, r.g, r.b) or Color(r, g, b)
		old_insert_color_change(self, last_color.r, last_color.g, last_color.b, last_color.a)
	end

	self.GetLastColorChange = function(self) return last_color end
	local old_is_hovered = self.IsHovered
	self.IsHovered = function(self) return old_is_hovered(self) or self:IsChildHovered() end
	--  HACK: determine whether a clickable segment of text is being hovered or not
	local old_insert_clickable_text_start = self.InsertClickableTextStart
	self._click_list = {}

	self.InsertClickableTextStart = function(self, value)
		local prev = self._click_list[#self._click_list]

		table.insert(self._click_list, {value, prev, false})

		if #self._click_list > 1024 then
			table.Empty(self._click_list[1])
			table.remove(self._click_list, 1)
		end

		old_insert_clickable_text_start(self, value)
		local parent = self:GetParent()
	end
end

-- compat for RichTextX
function PANEL:AppendImageURL(url)
end

function PANEL:OnChildAdded(clickpanel)
	if clickpanel:GetClassName() == "ClickPanel" then
		local now = RealTime()
		if not next(self._click_list) then return end
		local click_data = self._click_list[#self._click_list]
		if not click_data or next(click_data) == nil then return end
		local signal_value, click_data_prevpos, clickpanel_old = unpack(click_data)
		click_data[3] = clickpanel
		clickpanel._click_data = click_data
		clickpanel.signal_value = signal_value
		self._think_dirty = true

		for i = 1, 1024 do
			--print("SHIFT", i, signal_value, click_data_prevpos and click_data_prevpos[1])
			-- oops, linkpanels got the wrong linkage, shift them backwards
			if not IsValid(clickpanel_old) then break end
			clickpanel = clickpanel_old
			click_data = click_data_prevpos
			if not click_data or next(click_data) == nil then return end
			signal_value, click_data_prevpos, clickpanel_old = unpack(click_data)
			click_data[3] = clickpanel -- rewrite this
			clickpanel._click_data = click_data
			clickpanel.signal_value = signal_value
		end
	end
end

-- for overrides
function PANEL:OnTextHover(text_value, is_hover)
	--print("OnTextHover", self, text_value, is_hover)
end

function PANEL:CleanupDirtyClickList()
	local data = self._click_list[#self._click_list]
	if not data then return end
	if not data[3] then return end -- haven't assigned all of them yet
	-- latest one has been assigned, the old ones stand no chance of being reassigned
	--print("emptying _click_list, len=", table.Count(self._click_list))

	for i = 1, 1025 do
		local data = self._click_list[i]
		if not data then break end
		table.Empty(data)
	end

	table.Empty(self._click_list)
end

local easychat_legacy_hover_hack = CreateClientConVar("easychat_legacy_hover_hack","0",true,false,"Allow hovering over links in text (WIP: does not always work properly and shows something closeby!)")
function PANEL:ThinkLinkHover()
	if self._think_dirty then
		self._think_dirty = false
		self:CleanupDirtyClickList()
	end

	local hover = vgui.GetHoveredPanel()

	if not easychat_legacy_hover_hack:GetBool() then return end

	if not hover or hover:GetClassName() ~= "ClickPanel" then
		self._link_hovering = false
		local signal_value = self._last_hover_signal_value

		if signal_value then
			self._last_hover_signal_value = nil
			self:OnTextHover(signal_value, false)
		end

		return
	end

	if hover:GetParent() ~= self then return end
	if self._link_hovering == hover then return end
	self._link_hovering = hover

	if self._last_hover_signal_value then
		local signal_value = self._last_hover_signal_value
		self._last_hover_signal_value = nil
		self:OnTextHover(signal_value, false)
	end

	local signal_value = hover.signal_value
	if not signal_value then return end
	self._last_hover_signal_value = signal_value
	self:OnTextHover(signal_value, true)
end

function PANEL:Think()
	--self.BaseClass.Think(self)
	local now = RealTime()
	local nt = self._next_think_hover or 0
	if nt > now then return end
	self._next_think_hover = now + 0.1
	self:ThinkLinkHover()
end

vgui.Register("RichTextLegacy", PANEL, "RichText")
