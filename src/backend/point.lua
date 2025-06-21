--meant to be implimented in places where there is points and stuff
local point = {}

function point:add(key, x, y)
	local list = self[key]

	list[1] = list[1] + x
	list[2] = list[2] + y
end

function point:multiply(key, x, y)
	local list = self[key]

	list[1] = list[1] * x
	list[2] = list[2] * y
end

function point:set(key, x, y)
	self[key][1] =  x
	self[key][2] =  y
end

function point:puke(key)
	return table.unpack(self[key])
end

return point
