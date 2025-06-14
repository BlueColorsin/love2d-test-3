local sprite = object:extend() ---@class sprite:object
sprite:implement(util.point)

-- I LOVE TURNINATIRES!

function sprite:_new(x, y, graphic)
	self.graphic = graphic or nil ---@type love.Image

	self.x = x or 0
	self.y = y or 0

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

	self.scrollFactor = {1, 1}

	self.transform = love.math.newTransform() ---@type love.Transform

	--animation bullshit that is nil by default because not everything is animated
	 -- I lowk gotta shake that belly!
	self.animation = nil ---@type animation

	self.frames = nil
	self.currentFrame = nil
	self.frameIndex = nil

	self.play_anim = nil
end

function sprite:set_origin(...)
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
		self.animation:update(dt)
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

	local anim = self.animation and self.animation.current_anim
	if anim and anim.offset then
		off_x, off_y = off_x - anim.offset[1], off_y - anim.offset[2]
	end

	transform:translate(off_x, off_y)

	if self.debug_draw then
		graphics.push()
		graphics.applyTransform(transform)
		graphics.rectangle("line", 0, 0, self.width, self.height)
		graphics.pop()
	end

	local r,g,b,a = graphics.getColor()
	graphics.setColor(r,g,b,a)
	graphics.setColor(self.color[1], self.color[2], self.color[3], self.alpha)

	local frame = self.currentFrame
	if frame then
		--relies that the spritesheet has the right angled offset
		transform:translate(frame.offset[1], frame.offset[2])

		if frame.angle then
			transform:rotate(frame.angle)
		end

		graphics.draw(self.graphic, frame.quad, transform)
	else
		graphics.draw(self.graphic, transform)
	end

	graphics.setColor(r,g,b,a)
end

function sprite:release()
	self.animation:release()
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

function sprite:setup_animation()
	self.frames = self.frames or {}

	self.currentFrame = self.frames[1]
	self.frameIndex = 1

	self.animation = animation:new(self)

	self.play_anim = self.animation.play
end

function sprite:set_frame(index)
	if self.frames[index] == nil or self.frameIndex == index then
		return
	end

	local frame = self.frames[index]

	self.width = frame.dimensions[1]
	self.height = frame.dimensions[2]

	self.currentFrame = frame
	self.frameIndex = index
end

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
	self:setup_animation()
	self:set_frame(1)
end

return sprite
