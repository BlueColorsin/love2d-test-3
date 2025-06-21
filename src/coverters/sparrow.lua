-- converts the sparrow V2 atlas format into a lua table I think
-- OH MY FUCKING GOD THIS FORMAT SUCKS ASS, I HATE IT AHHHH
-- thank god lua allows me to do stupid shit like this

local function raw(string)
	return function(key, list)
		return string
	end
end

local function makeQuad(x, y, width, height)
	return "quad("..x..", "..y..", "..width..", "..height..", texture)"
end

return function(path, save_to)
	local file = love.filesystem.read(path)
	local data = parsers.xml.parse(file)

	local export = love.filesystem.openFile(save_to, "w")

	export:write("local texture = " .. "({...})[1]" .. " ")
	export:write("local quad = love.graphics.newQuad ")

	local frames = {
		texture = raw("texture"),
		tags = {}
	}

	table.sort(data.children[1].children, function (a, b)
		return a.attrs.name < b.attrs.name -- oh right I forgot this language is goated
	end)

	-- no way fnf monsters of monsters reference
	-- used to index the first instance of a frame so it can be used in 
	local first_instance = {}

	for index, value in ipairs(data.children[1].children) do --data.children[1].children
		local frame

		value = value.attrs

		local sub_num = value.name:sub(0, #value.name - 4)
		if frames.tags[sub_num] == nil then
			frames.tags[sub_num] = {}
		end

		local tag = frames.tags[sub_num]

		local trimmed = (value.frameX ~= nil)
		local rotated = value.rotated or false

		local size
		if trimmed then
			size = {value.frameX,value.frameY,value.frameWidth,value.frameHeight}
		else
			size = {0,0,value.width,value.height}
		end

		size[1], size[2] = -size[1], -size[2]
		if rotated then
			size[2] = size[2] + value.width
		end

		local key = value.x..value.y..value.width..value.height..size[1]..size[2]..size[3]..size[4]
		if not first_instance[key] then
			first_instance[key] = #frames+1
		else
			goto atomic_rizzler
		end

		--HONESTLY, fuck flipX and flipY

		frame = {}

		if not rotated or trimmed then
			frame.dimensions = raw("{"..size[3]..", "..size[4].."}")
		else
			frame.dimensions = raw("{"..size[4]..", "..size[3].."}")
		end

		frame.offset = raw("{"..size[1]..", "..size[2].."}")
		frame.quad = raw(makeQuad(value.x, value.y, value.width, value.height))
		frame.texture = raw("texture")

		if rotated then
			frame.angle = math.rad(270)
		end

		table.insert(frames, frame)

		::atomic_rizzler::

		table.insert(tag, first_instance[key])
	end

	export:write("return " .. util.serialize_list(frames))

	export:flush()
	export:close()
	export:release()
end

-- offtopic but vs sonic (rewrite) round 2 is pretty cool