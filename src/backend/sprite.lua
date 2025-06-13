local sprite = object:extend() ---@class sprite:object
sprite:implement(util.point)

-- I LOVE TURNINATIRES!

function sprite:_new(x, y, graphic)
	self.graphic = graphic or nil ---@type love.Image

	self.x = x or 0
	self.y = y or 0

	self.width = self.graphic:getWidth()
	self.height = self.graphic:getHeight()

	self.origin = {self.width/2, self.height/2}

	self.angle = 0
	self.scale = {1, 1}
	self.shear = {0, 0}

	self.transform = love.math.newTransform() ---@type love.Transform

	--animation bullshit that is nil by default because not everything is animated
	 -- I lowk gotta shake that belly!
	self.animation = nil ---@type animation

	self.frames = nil
	self.currentFrame = nil
	self.frameIndex = nil
end

function sprite:setFrame(index)
	if self.frames[index] == nil or self.frameIndex == index then
		return
	end

	local frame = self.frames[index]

	self.width = frame.dimensions[1]
	self.height = frame.dimensions[2]
	self.origin = {self.width/2, self.height/2}

	self.currentFrame = frame
	self.frameIndex = frame
end

function sprite:loadFrames(path)
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
	self.animation = animation:new(self)

	self:setFrame(1)
end

function sprite:update(dt)
	if self.animation then
		self.animation:update(dt)
	end
end

function sprite:render()
	local graphics = love.graphics ---@type love.graphics

	local transform = self.transform:reset()

	transform:translate(self.origin[1], self.origin[2])
		transform:rotate(self.angle)
		transform:scale(self.scale[1], self.scale[2])
		transform:shear(self.shear[1], self.shear[2])
	transform:translate(-self.origin[1], -self.origin[2])

	local frame
	if self.animation then
		frame = self.currentFrame
		--relies that the spritesheet has the right angled offset
		transform:translate(frame.offset[1], frame.offset[2])

		if frame.angle then
			transform:rotate(frame.angle)
		end

		local anim = self.animation.currentAnimation
		if anim.offset then
			-- the offset is BROKEN at angles for some unFORSAKEN reason
			transform:translate(-anim.offset[1], -anim.offset[2])
		end
	end

	transform:translate(self.x, self.y)

	if self.animation then
		graphics.draw(self.graphic, frame.quad, transform)
	else
		graphics.draw(self.graphic, transform)
	end
end

function sprite:release()
	self.animation:release()
	self.transform:release()
	self.graphic:release()

	for key, value in pairs(self.frames) do
		value.quad:release()
	end

	for key, value in pairs(self) do
		rawset(self, key, nil)
	end

	self = nil
end

return sprite
