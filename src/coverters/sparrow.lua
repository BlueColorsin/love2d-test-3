-- converts the sparrow V2 atlas format into a lua table I think

local function raw(string)
	return function(key, list)
		return string
	end
end

local function makeQuad(x, y, width, height)
	return "love.graphics.newQuad("..x..", "..y..", "..width..", "..height..", texture)"
end

return function(path, save_to)
	local file = love.filesystem.read(path)
	local data = parsers.xml.parse(file)

	local export = love.filesystem.newFile(save_to, "w")

	export:write("local texture = " .. "({...})[1]" .. " ")

	local frames = {
		texture = raw("texture"),
	}

	for index, value in ipairs(data.children[1].children) do --data.children[1].children
		value = value.attrs
		local frame = {}

		frame.name = value.name

		if value.flipX then
			frame.flipX = value.flipX or false
		end
		if value.flipY then
			frame.flipY = value.flipY or false
		end

		local trimmed = (value.frameX ~= nil)
		local rotated = value.rotated or false

		local size
		if trimmed then
			size = {value.frameX,value.frameY,value.frameWidth,value.frameHeight}
		else
			size = {0,0,value.width,value.height}
		end

		if not rotated or trimmed then
			frame.dimensions = raw("{"..size[3]..", "..size[4].."}")
		else
			frame.dimensions = raw("{"..size[4]..", "..size[3].."}")
		end

		size[1], size[2] = -size[1], -size[2]
		if rotated then
			size[2] = size[2] + value.width
			frame.rotation = rotated and math.rad(270) or 0
		end

		frame.offset = raw("{"..size[1]..", "..size[2].."}")
		frame.quad = raw(makeQuad(value.x, value.y, value.width, value.height))

		table.insert(frames, frame)
	end

	export:write("return " .. serialize_list(frames))

	export:flush()
	export:close()
	export:release()
end
