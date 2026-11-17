local JSON_URL = "https://classic-box.org/emojis/emojis.json"
local GIFTOVTF_URL = "https://classic-box.org/vtf/get"

local function material_data(path)
	return Material("../data/" .. path)
end

local UNCACHED = false
local PROCESSING = true

local cache = {}
local framerate_cache = {}
local lookup = {}

local FOLDER = "easychat/emojis/classicbox"
local FRAMERATE_FILE = FOLDER .. "/framerate.txt"
file.CreateDir(FOLDER, "DATA")

if file.Exists(FRAMERATE_FILE, "DATA") then
	framerate_cache = util.JSONToTable(file.Read(FRAMERATE_FILE, "DATA")) or {}
end

http.Fetch(JSON_URL, function(body, _, _, code)
	if code ~= 200 then
		EasyChat.Print(true, "Could not get the lookup table for ClassicBox emojis: HTTP " .. tostring(code))
		return
	end

	local tbl = util.JSONToTable(body)
	if not tbl then
		EasyChat.Print(true, "Could not get the lookup table for ClassicBox emojis")
		return
	end

	for name, url in pairs(tbl) do
		lookup[name] = url
		if cache[name] == nil then
			cache[name] = UNCACHED
		end
	end

	EasyChat.Print(string.format("Loaded %d ClassicBox emoji references", table.Count(lookup)))
end, function(err)
	EasyChat.Print(true, "Could not get the lookup table for ClassicBox emojis: " .. tostring(err))
end)

local function gif_material(name, path)
	return CreateMaterial("ecclassicbox_" .. name, "UnlitGeneric", {
		["$basetexture"] = "../data/" .. path,
		["$vertexcolor"] = 1,
		["$vertexalpha"] = 1,
		["$transparent"] = 1,
		["Proxies"] = {
			AnimatedTexture = {
				animatedtexturevar = "$basetexture",
				animatedtextureframenumvar = "$frame",
				animatedtextureframerate = framerate_cache[name] or 8,
			}
		},
	})
end

local function get_vtf_url(name, gif_url, callback, attempt)
	attempt = attempt or 1

	http.Post(GIFTOVTF_URL, { url = gif_url }, function(data, _, _, http_code)
		if http_code ~= 200 or not data or #data < 10 then
			EasyChat.Print(true, "Could not get GIF info for ", name, ": " .. tostring(http_code))
			return
		end

		local info = util.JSONToTable(data)
		if not info or info.status == 0 then
			if attempt >= 15 then
				EasyChat.Print(true, "GIF conversion timed out for ", name)
				return
			end

			timer.Simple(2, function()
				get_vtf_url(name, gif_url, callback, attempt + 1)
			end)
			return
		end

		if info.status < 0 then
			EasyChat.Print(true, "Error getting GIF info for ", name, " (", tostring(info.status), "): " .. tostring(info.status_text))
			return
		end

		framerate_cache[name] = tonumber(info.frame_rate) or 8
		file.Write(FRAMERATE_FILE, util.TableToJSON(framerate_cache))

		callback(info.url)
	end, function(err)
		EasyChat.Print(true, "Could not get GIF info for ", name, ": " .. tostring(err))
	end)
end

local function get_classicbox_emoji(name)
	local url = lookup[name]
	if not url then
		return false
	end

	local c = cache[name]
	if c then
		if c == true then
			return
		end
		return c
	else
		if c == nil then
			return false
		end
	end

	cache[name] = PROCESSING

	local animated = string.EndsWith(url, ".gif")
	local path = FOLDER .. "/" .. name .. (animated and ".vtf" or ".png")

	if file.Exists(path, "DATA") then
		local mat = animated and gif_material(name, path) or material_data(path)
		if mat and not mat:IsError() then
			cache[name] = mat
			return mat
		end
	end

	local function fail(err)
		EasyChat.Print(true, "Http fetch failed for ", name, ": " .. tostring(err))
	end

	local function download(download_url)
		http.Fetch(download_url, function(data, len, _, code)
			if code ~= 200 or len <= 0 then
				return fail(code)
			end

			file.Write(path, data)
			local mat = animated and gif_material(name, path) or material_data(path)
			if not mat or mat:IsError() then
				file.Delete(path)
				return
			end

			cache[name] = mat
		end, fail)
	end

	if animated then
		get_vtf_url(name, url, download)
	else
		download(url)
	end
end

EasyChat.ChatHUD:RegisterEmoteProvider("classicbox", get_classicbox_emoji, 1)
EasyChat.AddEmoteLookupTable("classicbox", cache)

return "ClassicBox Emojis"
