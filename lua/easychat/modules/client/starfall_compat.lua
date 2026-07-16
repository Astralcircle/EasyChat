-- this module is a hack for fixing the following issue:
-- https://github.com/Earu/EasyChat/issues/79
-- https://github.com/thegrb93/StarfallEx/issues/1232

local function is_starfall()
	return SF ~= nil and SF.runningOps ~= nil and SF.SafeStringLib ~= nil
end

local previous_ops_state = false

hook.Add("ECPreAddText", "EasyChatModuleSFCompat", function()
	if not is_starfall() then return end
	previous_ops_state = SF.runningOps
	SF.runningOps = false
end)

hook.Add("ECPostAddText", "EasyChatModuleSFCompat", function()
	if not is_starfall() then return end
	SF.runningOps = previous_ops_state
end)

return "SF Compat"
