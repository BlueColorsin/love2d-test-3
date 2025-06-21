-- well come to hell (the main file)

do -- setting up default require paths
	local paths = love.filesystem.getRequirePath()

	paths = "src/?.lua;src/?/init.lua;" -- src path
	.. "src/lib/?.lua;src/lib/?/init.lua;" -- lib paths
	.. paths -- chances are we are going to require from anywhere else the least so it's fine

	love.filesystem.setRequirePath(paths)
end


_G.object = require("classic")

_G.util = require("util")

_G.animation = require("backend.animation")
_G.sprite = require("backend.sprite")

_G.text = require("backend.text")

_G.audio = require("backend.audio")

_G.battle_ui = require("battleUI")

_G.parsers = {
	json = require("json"),
	xml = require("xml")
}

_G.converters = {
	sparrow = require("coverters.sparrow"),
	aseprite = require("coverters.aseprite"),
}

_G.void = function()end

_G.FALLBACK_GRAPHIC = love.graphics.newImage("fallback.png")

local bf ---@type sprite

local x = 0
local y = 0
local zoom = 1

local c_x, c_y = 0, 0

function love.load()
	love.filesystem.setIdentity("colorsin_testing")

	converters.sparrow("assets/battle_ui.xml", "battle_ui.lua")

	battle_ui:init()

	love.graphics.setNewFont(18)
end

local elapsed = 0
function love.update(dt)
	battle_ui:update(dt)
end

function love.keypressed(key, scancode, isrepeat)
	if isrepeat then return end


end

function love.wheelmoved(x, y)
	zoom = zoom + y * 0.1
end

function love.mousemoved(_x, _y, dx, dy, istouch) end

local last_x, last_y = 0, 0

function love.draw()
	local graphics = love.graphics ---@type love.graphics

	-- use this as the basis for the camera renderer later 
	graphics.push()
	graphics.clear(0.5, 0.5, 0.5, 1)

	c_x, c_y = graphics.inverseTransformPoint(love.graphics.getWidth()*0.5, love.graphics.getHeight()*0.5)

	graphics.translate(c_x, c_y)
		graphics.scale(zoom)
	graphics.translate(-c_x, -c_y)

	local _x, _y = graphics.inverseTransformPoint(love.mouse.getGlobalPosition())
	local dx, dy = (_x - last_x), (_y - last_y)

	if love.mouse.isDown(3) then
		x, y = x + dx, y + dy
	end
	if love.mouse.isDown(1) then
		bf.x, bf.y = bf.x + dx, bf.y + dy
	end
	last_x, last_y = _x, _y

	graphics.translate(x, y)

	battle_ui:render()

	graphics.pop()

	graphics.print("zoom :" .. math.floor((zoom * 100)) * 0.01)
end
