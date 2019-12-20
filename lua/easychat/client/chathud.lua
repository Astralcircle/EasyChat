--[[
	TODO:
	- Handle font changes
	- Fix matrices not working / text not displaying when using them
]]--

--[[-----------------------------------------------------------------------------
	Micro Optimization
]]-------------------------------------------------------------------------------
local ipairs, pairs, tonumber = _G.ipairs, _G.pairs, _G.tonumber
local Color, Vector, Matrix = _G.Color, _G.Vector, _G.Matrix
local type, tostring, RealFrameTime, ScrH = _G.type, _G.tostring, _G.RealFrameTime, _G.ScrH
local select, setfenv, CompileString = _G.select, _G.setfenv, _G.CompileString

local table_copy = _G.table.Copy
local table_insert = _G.table.insert
local table_remove = _G.table.remove

local surface_SetDrawColor = _G.surface.SetDrawColor
local surface_SetTextColor = _G.surface.SetTextColor
local surface_GetTextSize = _G.surface.GetTextSize
local surface_DrawOutlinedRect = _G.surface.DrawOutlinedRect
local surface_SetFont = _G.surface.SetFont
local surface_SetTextPos = _G.surface.SetTextPos
local surface_DrawText = _G.surface.DrawText

local math_max = _G.math.max
local math_floor = _G.math.floor
local math_clamp = _G.math.Clamp

local cam_PopModelMatrix = _G.cam.PopModelMatrix
local cam_PushModelMatrix = _G.cam.PushModelMatrix

local hook_run = _G.hook.Run

local string_explode = _G.string.Explode
local string_gmatch = _G.string.gmatch
local string_replace = _G.string.Replace
local string_sub = _G.string.sub
local string_len = _G.string.len
local string_find = _G.string.find
local string_format = _G.string.format
local string_lower = _G.string.lower

local chat_GetPos = chat.GetChatBoxPos
local chat_GetSize = chat.GetChatBoxSize

--[[-----------------------------------------------------------------------------
	Base ChatHUD
]]-------------------------------------------------------------------------------
local chat_x, chat_y = chat.GetChatBoxPos()
local chat_w, chat_h = chat.GetChatBoxSize()

local chathud = {
	FadeTime = 16,
	Pos = { X = 25, Y = ScrH() - 150 },
	Size = { W = 550, H = 320 },
	Lines = {},
	Parts = {},
	TagPattern = "<(.-)=%[?(.-)%]?>",
	ShouldClean = false,
	DefaultColor = Color(255, 255, 255),
	DefaultFont = "DermaLarge",
}

local EC_HUD_TTL = GetConVar("easychat_hud_ttl")
local EC_HUD_FOLLOW = GetConVar("easychat_hud_follow")

chathud.FadeTime = EC_HUD_TTL:GetInt()
cvars.AddChangeCallback("easychat_hud_ttl", function(_, _, new)
    chathud.FadeTime = new
end)

local default_part = {
	Type = "default",
	Pos = { X = 0, Y = 0 },
	Size =  { W = 0, H = 0 },
	Usable = true,
}

function default_part:Ctor()
	self:ComputeSize()
	return self
end

-- meant to be overriden
function default_part:LineBreak() end

-- meant to be overriden
function default_part:ComputeSize() end

-- meant to be overriden
function default_part:Draw() end

function chathud:RegisterPart(name, part)
	if not name or not part then return end
	name = string_lower(name)

	local new_part = table_copy(default_part)
	for k, v in pairs(part) do
		new_part[k] = v
	end

	new_part.Type = name
	self.Parts[name] = new_part
end

--[[-----------------------------------------------------------------------------
	Stop Component

	/!\ NEVER EVER REMOVE OR THE CHATHUD WILL BREAK HORRIBLY /!\

	This guarantees all matrixes and generally every change made
	to the drawing context is set back to a "default" state.
]]-------------------------------------------------------------------------------
local stop_part = {
	Usable = false
}

function stop_part:Draw(ctx)
	while ctx.MatrixCount > 0 do
		ctx:PopMatrix()
	end

	ctx:ResetColors()
	ctx:ResetFont()
end

chathud:RegisterPart("stop", stop_part)

--[[-----------------------------------------------------------------------------
	Color Component

	Color modulation with rgb values.
]]-------------------------------------------------------------------------------
local color_part = {}

function color_part:Ctor(str)
	self:ComputeSize()
	local col_components = string_explode("%s*,%s*", str, true)
	local r, g, b =
		tonumber(col_components[1]) or 255,
		tonumber(col_components[2]) or 255,
		tonumber(col_components[3]) or 255
	self.Color = Color(r, g, b)

	return self
end

function color_part:Draw(ctx)
	self.Color.a = ctx.Alpha
	surface_SetDrawColor(self.Color)
	surface_SetTextColor(self.Color)
end

chathud:RegisterPart("color", color_part)

--[[-----------------------------------------------------------------------------
	Text Component

	Draws normal text.
]]-------------------------------------------------------------------------------
local text_part = {
	Content = "",
	Usable = false
}

function text_part:Ctor(content)
	self.Content = content
	self.Font = self:GetLastFont()
	self:ComputeSize()

	return self
end

function text_part:GetLastFont()
	--[[for i=self.Index, 1, -1 do
		local component = self.Line.Components[i]
		if component.Type == "font" then
			return component.Font
		end
	end]]--

	return chathud.DefaultFont
end

function text_part:ComputeSize()
	surface_SetFont(self.Font)
	local w, h = surface_GetTextSize(self.Content)
	self.Size = { W = w, H = h }
end

function text_part:Draw()
	surface_SetFont(self.Font)
	surface_SetTextPos(self.Pos.X, self.Pos.Y)
	surface_DrawText(self.Content)
end

function text_part:IsTextWider(text, width)
	surface_SetFont(self.Font)
	local w, _ = surface_GetTextSize(text)
	return w >= width
end

local hard_break_treshold = 10
local breaking_chars = {
	[" "] = true,
	[","] = true,
	["."] = true,
	["\t"] = true,
}

function text_part:FitWidth()
	local last_line = chathud:LastLine()
	local left_width = chathud.Size.W - last_line.Size.W
	local text = self.Content

	local len = string_len(text)
	for i=1, len do
		if self:IsTextWider(string_sub(text, 1, i), left_width) then
			local sub_str = string_sub(text, i, i)

			-- try n times before hard breaking
			for j=1, hard_break_treshold do
				if breaking_chars[sub_str] then
					-- we found a breaking char, break here
					self.Content = string_sub(text, 1, i - j)
					break
				else
					sub_str = string_sub(text, i - j, i - j)
				end
			end

			-- check if content is the same, and if it is, hard-break
			if text == self.Content then
				self.Content = string_sub(text, 1, i)
			end

			break -- we're done getting our first chunk of text to fit for the last line
		end
	end

	last_line:PushComponent(self)

	-- send back remaining text
	return string_sub(text, string_len(self.Content) + 1, len)
end

function text_part:LineBreak()
	local remaining_text = self:FitWidth()
	repeat
		local new_line = chathud:NewLine()
		local component = chathud:CreateComponent("text", remaining_text)
		remaining_text = component:FitWidth()
	until remaining_text == ""
end

chathud:RegisterPart("text", text_part)

--[[-----------------------------------------------------------------------------
	ChatHUD layouting
]]-------------------------------------------------------------------------------
local base_line = {
	Components = {},
	Pos = { X = 0, Y = 0 },
	Size = { W = 0, H = 0 },
	LifeTime = 0,
	Alpha = 255,
}

function base_line:Update()
	local time = RealFrameTime()
	self.LifeTime = self.LifeTime + time
	if self.LifeTime >= chathud.FadeTime then
		self.Alpha = math_floor(math_max(self.Alpha - (time * 10), 0))
		if self.Alpha == 0 then
			self.ShouldRemove = true
			chathud.ShouldClean = true
		end
	end
end

function base_line:Draw(ctx)
	self:Update()
	ctx.Alpha = self.Alpha
	for _, component in ipairs(self.Components) do
		component:Draw(ctx)
	end
end

function base_line:PushComponent(component)
	component.Line = self
	component.Pos = { X = self.Pos.X + self.Size.W, Y = self.Pos.Y }
	component.Index = table_insert(self.Components, component)

	-- need to update width for inserting next components properly
	self.Size.W = self.Size.W + component.Size.W
end

function chathud:NewLine()
	local new_line = table_copy(base_line)
	new_line.Index = table_insert(self.Lines, new_line)

	-- we never want to display that many lines
	if #self.Lines > 50 then
		table_remove(self.Lines, 1)
	end

	return new_line
end

function chathud:LastLine()
	return self.Lines[#self.Lines]
end

function chathud:InvalidateLayout()
	local line_count, total_height = #self.Lines, 0
	-- process from bottom to top (most recent to ancient)
	for i=line_count, 1, -1 do
		local line = self.Lines[i]
		line.Size.W = 0
		line.Index = i

		for _, component in ipairs(line.Components) do
			component:ComputeSize()

			component.Pos.X = chathud.Pos.X + line.Size.W
			line.Size.W = line.Size.W + component.Size.W

			-- update line height to the tallest possible
			if component.Size.H > line.Size.H then
				line.Size.H = component.Size.H
			end
		end

		total_height = total_height + line.Size.H
		line.Pos = { X = chathud.Pos.X, Y = chathud.Pos.Y + chathud.Size.H - total_height }

		for _, component in ipairs(line.Components) do
			component.Pos.Y = line.Pos.Y
		end
	end
end

function chathud:CreateComponent(name, ...)
	local part = self.Parts[name]
	if not part then return end

	return table_copy(part):Ctor(...)
end

function chathud:PushPartComponent(name, ...)
	local component = self:CreateComponent(name, ...)
	if not component then return end

	local line = self:LastLine()
	if line.Size.W + component.Size.W > self.Size.W then
		component:LineBreak()
	else
		line:PushComponent(component)
	end
end

function chathud:PushMultilineTextComponent(str)
	local str_lines = string_explode("\r?\n", str, true)
	self:PushPartComponent("text", str_lines[1])
	table_remove(str_lines, 1)

	for i=1, #str_lines do
		self:NewLine()
		self:PushPartComponent("text", str_lines[i])
	end
end

function chathud:PushString(str)
	local str_parts = string_explode(self.TagPattern, str, true)
	local enumerator = string_gmatch(str, self.TagPattern)
	local i = 1
	for tag, content in enumerator do
		self:PushMultilineTextComponent(str_parts[i])
		i = i + 1

		local part = self.Parts[tag]
		if part and part.Usable then
			self:PushPartComponent(tag, content)
		end
	end

	self:PushMultilineTextComponent(str_parts[#str_parts])
end

function chathud:Clear()
	self.Lines = {}
end

--[[-----------------------------------------------------------------------------
	Actual ChatHUD drawing here
]]-------------------------------------------------------------------------------
local draw_context = {
	MatrixCount = 0,
}

function draw_context:PushMatrix(mat)
	cam_PushModelMatrix(mat)
	self.MatrixCount = self.MatrixCount + 1
end

function draw_context:PopMatrix()
	if self.MatrixCount <= 0 then return end

	cam_PopModelMatrix()
	self.MatrixCount = self.MatrixCount - 1
end

function draw_context:ResetColors()
	surface_SetDrawColor(chathud.DefaultColor)
	surface_SetTextColor(chathud.DefaultColor)
end

function draw_context:ResetFont()
	surface_SetFont(chathud.DefaultFont)
end

chathud.DrawContext = draw_context

function chathud:ComputePos()
	if EC_HUD_FOLLOW:GetBool() then
		local chat_x, chat_y = chat_GetPos()
		local chat_w, chat_h = chat_GetSize()

		self.Pos = { X = chat_x, Y = chat_y }
		self.Size = { W = chat_w, H = chat_h }
	else
		self.Pos = { X = 25, Y = ScrH() - 150 }
		self.Size = { W = 550, H = 320 }
	end
end

function chathud:Draw()
	--if hook_run("HUDShouldDraw","CHudChat") == false then return end
	self:ComputePos()

	for _, line in ipairs(self.Lines) do
		line:Draw(draw_context)
	end

	-- this is done here so we can freely draw without odd behaviors
	if self.ShouldClean then
		for i, line in ipairs(self.Lines) do
			if line.ShouldRemove then
				table_remove(self.Lines, i)
			end
		end
		self.ShouldClean = false
		self:InvalidateLayout()
	end
end

hook.Add("HUDPaint", "EasyChat", function() chathud:Draw() end)

--[[-----------------------------------------------------------------------------
	Input into ChatHUD
]]-------------------------------------------------------------------------------
local function is_color(c)
	return c.r and c.g and c.b and c.a
end

local function color_to_expr(c)
	return string_replace(tostring(c), " ", ",")
end

function chathud:AppendText(txt)
	self:PushString(txt)
end

function chathud:InsertColorChange(r, g, b)
	local expr = ("%d,%d,%d"):format(r, g, b)
	self:PushPartComponent("color", expr)
end

--[[function chathud:AddText(...)
	local args = { ... }
	self:NewLine()
	for _, arg in ipairs(args) do
		local t = type(arg)
		if t == "Player" then
			local team_color = team.GetColor(arg:Team())
			self:PushPartComponent("color", color_to_expr(team_color))
			self:PushString(arg:Nick())
		elseif t == "table" and is_color(arg) then
			self:PushPartComponent("color", color_to_expr(arg))
		elseif t == "string" then
			self:PushString(arg)
		else
			self:PushString(tostring(arg))
		end
	end
	self:PushPartComponent("stop")
	self:InvalidateLayout()
end]]--

return chathud