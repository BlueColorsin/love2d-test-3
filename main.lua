-- well come to hell (the main file)

do -- setting up default require paths
	local paths = love.filesystem.getRequirePath()

	paths = "src/?.lua;src/?/init.lua;" -- src path
	.. "src/lib/?.lua;src/lib/?/init.lua;" -- lib paths
	.. paths -- chances are we are going to require from anywhere else the least so it's fine

	love.filesystem.setRequirePath(paths)
end

_G.object = require("classic")

_G.util = {
	point = require("backend.point")
}

_G.animation = require("backend.animation")
_G.sprite = require("backend.sprite")

_G.text = require("backend.text")

_G.audio = require("backend.audio")

_G.parsers = {
	json = require("json"),
	xml = require("xml")
}

_G.converters = {
	sparrow = require("coverters.sparrow")
}

--edited version of https://stackoverflow.com/a/65632110/21846847
function serialize_list(list)
	local str = ''
	str = str .. "{"
	for key, value in pairs(list) do
		local pr = (type(key) == "string") and ('["'..key..'"] = ') or ""

		if type(value) == "table" then
			str = str..pr..serialize_list(value)..', '
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

local test

local x = 0
local y = 0
local zoom = 1

local c_x, c_y = 0, 0

function love.load()
	love.filesystem.setIdentity("colorsin_testing")

	converters.sparrow("BOYFRIEND.xml", "BOYFRIEND.lua")

	test = sprite:new(0, 0, love.graphics.newImage("BOYFRIEND.png")) ---@type sprite
	test:loadFrames("BOYFRIEND.lua")
	test.animation:addByTag("idle"     , "BF idle dance", 24, false, {-5 ,  0})
	test.animation:addByTag("singLEFT" , "BF NOTE LEFT" , 24, false, { 5 , -6})
	test.animation:addByTag("singDOWN" , "BF NOTE DOWN" , 24, false, {-20, -51})
	test.animation:addByTag("singUP"   , "BF NOTE UP"   , 24, false, {-46,  27})
	test.animation:addByTag("singRIGHT", "BF NOTE RIGHT", 24, false, {-48, -7})
	
	test.animation:play("idle")

	love.graphics.setNewFont(18)

	print()
end

local fuckedUp = false

local elapsed = 0
function love.update(dt)
	test:update(dt)

	if fuckedUp then
		elapsed = elapsed + dt
		-- test:set("shear", math.sin(elapsed), math.sin(elapsed))
		test.angle = test.angle + math.rad(90) * dt
	end
end

function love.keypressed(key, scancode, isrepeat)
	if isrepeat then return end

	if key == "backspace" then
		fuckedUp = not fuckedUp
	end

	if key == "left" then
		test.animation:play("singLEFT", true)
	elseif key == "right" then
		test.animation:play("singRIGHT", true)
	elseif key == "down" then
		test.animation:play("singDOWN", true)
	elseif key == "up" then
		test.animation:play("singUP", true)
	elseif key == "space" then
		test.animation:play("idle", true)
	end
end

function love.wheelmoved(x, y)
	zoom = zoom + y * 0.1
end

function love.mousemoved(_x, _y, dx, dy, istouch)
	if love.mouse.isDown(3) then
		-- x, y = x + dx, y + dy
	end
end

local curIdx = 1
function updateIndex(val, length)
	curIdx = curIdx + val

	if (curIdx < 1) then
		curIdx = curIdx + (length - 1)
	elseif (curIdx >= length) then
		curIdx = curIdx % (length - 1)
	end

	test:setFrame(curIdx)
end

local last_x, last_y = 0, 0

function love.draw()
	local graphics = love.graphics ---@type love.graphics
	
	-- use this as the basis for the camera renderer later 
	graphics.push()
	graphics.clear(0.5, 0.5, 0.5, 1)

	c_x, c_y = graphics.inverseTransformPoint(love.graphics.getWidth()*0.5, love.graphics.getHeight()*0.5)

	graphics.translate(c_x, c_y)
		if fuckedUp then

			-- graphics.rotate(-test.angle)
		end
		graphics.scale(zoom)
	graphics.translate(-c_x, -c_y)

	local _x, _y = graphics.inverseTransformPoint(love.mouse.getPosition())
	if love.mouse.isDown(3) then
		local dx, dy = (_x - last_x), (_y - last_y)
		x, y = x + dx, y + dy
	end
	last_x, last_y = _x, _y

	graphics.translate(x, y)

	test:render()

	graphics.pop()

	graphics.print(x.."|"..y, 0, 100)
	graphics.print("zoom :" .. math.floor((zoom * 100)) * 0.01)
end
