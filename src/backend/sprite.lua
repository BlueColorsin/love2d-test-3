local sprite = object:extend() ---@class sprite:object,animation
sprite:implement(util.point)

-- I LOVE TURNINATIRES!

function sprite:_new(x, y, graphic)
	self.graphic = graphic or nil ---@type love.Image
	-- just done to make the draw logic simanimser, could actually be used if not animated
	self.quad = nil

	self.x = x or 0
	self.y = y or 0

	self.transform = love.math.newTransform() ---@type love.Transform

	self.scrollFactor = {0.5, 0.5}

	self.color = {1, 1, 1}
	self.alpha = 1

	self.visible = true
	self.active = true

	self.width = self.graphic:getWidth()
	self.height = self.graphic:getHeight()

	self.origin = {self.width/2, self.height/2}

	self.offset = {1, 1}

	self.angle = 0
	self.scale = {1, 1}
	self.shear = {0, 0}

	-- I lowk gotta shake that belly!

	self.animation = false
end

function sprite:setOrigin(...)
	local values = {...}
	local args = #values

	-- fucked up and evil polymorphism
	if args == 1 and type(values[1]) == "number" then
		local dimensions = self.frames[values[1]].dimensions
		self:set("origin", dimensions[1]/2, dimensions[2]/2)
	elseif args == 2 then
		self:set("origin", values[1], values[2])
	elseif args == 0 then
		self:set("origin", self.height/2, self.width/2)
	end
end

function sprite:update(dt)
	if not self.active then return end

	if self.animation then
		self:handle_animation(dt)
	end
end

function sprite:render()
	if not self.visible or self.alpha == 0 then return end

	local graphics = love.graphics ---@type love.graphics

	local transform = self.transform:reset()

	local s_x, s_y = graphics.inverseTransformPoint(0, 0)
	transform:translate(s_x * (1 - self.scrollFactor[1]), s_y * (1 - self.scrollFactor[2]))

	transform:translate(self.x, self.y)

	transform:translate(self.origin[1], self.origin[2])
		transform:rotate(self.angle)
		transform:scale(self.scale[1], self.scale[2])
		transform:shear(self.shear[1], self.shear[2])
	transform:translate(-self.origin[1], -self.origin[2])

	local off_x, off_y = -self.offset[1], -self.offset[2]

	local anim = self.animation and self.current_anim
	if anim and anim.offset then
		off_x, off_y = off_x - anim.offset[1], off_y - anim.offset[2]
	end

	transform:translate(off_x, off_y)

	local quad = self.quad

	local frame = self.current_frame
	if frame then
		--relies that the spritesheet has the right angled offset
		transform:translate(frame.offset[1], frame.offset[2])

		if frame.angle then
			transform:rotate(frame.angle)
		end

		quad = frame.quad or quad
	end

	local r,g,b,a = graphics.getColor()
	graphics.setColor(self.color[1], self.color[2], self.color[3], self.alpha)

	if quad then
		graphics.draw(self.graphic, quad, transform)
	else
		graphics.draw(self.graphic, transform)
	end

	graphics.setColor(r,g,b,a)
end

function sprite:release()
	if self.animation then
		self.playing = false
	end

	self.transform:release()
	self.graphic:release()

	for key, value in ipairs(self.frames) do
		value.quad:release()
	end

	self.active = false
	self.visible = false

	---@diagnostic disable-next-line: missing-fields
	self = {}
end

-- as it turns out animation as a whole is easy enough to litterally just implement
-- so that's what I did 
function sprite:load_frames(path)
	local chunk, err = love.filesystem.load(path)
	if err then
		error("ERROR LOADING ATLAS! <"..path:upper().."> "..err)
	end

	local success, frames = pcall(chunk, self.graphic)
	if not success then
		error("ERROR LOADING ATLAS: <"..path:upper().."> "..ret)
	end

	if #frames == 0 then
		error("ERROR LOADING ATLAS: <"..path:upper().."> | YOUR ATLAS NEEDS FRAMES DUMBASS!")
	end

	self.frames = frames
	self:implement(animation)
	self:setFrame(1)
end

return sprite
