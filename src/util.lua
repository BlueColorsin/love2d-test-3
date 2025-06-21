local util = {}

--edited version of https://stackoverflow.com/a/65632110/21846847
function util.serialize_list(list)
	local str = ''
	str = str .. "{"
	for key, value in pairs(list) do
		local pr = (type(key) == "string") and ('["'..key..'"] = ') or ""

		if type(value) == "table" then
			str = str..pr..util.serialize_list(value)..', '
		elseif type(value) == "function" then
			str = str..pr..value(list, key)..', '
		elseif type(value) == "string" then
			if tonumber(value) ~= nil then
				str = str..pr..'"'..tonumber(value)..'", '			
			else
				str = str..pr..'"'..tostring(value)..'", '
			end
		else
			str = str..pr..tostring(value)..', '
		end
	end

	str = str:sub(1, #str-2) -- remove last symbols
	str = str.."}"
	return str
end

util.point = require("backend.point")

return util