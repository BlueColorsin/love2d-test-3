local sprite = object:extend() ---@class sprite:object

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
	self.animation = nil -- I lowk gotta shake that belly!

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

	-- setup animation shit here
	self:setFrame(1)
end

function sprite:update(dt)

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
	end

	transform:translate(self.x, self.y)

	if self.animation then
		graphics.draw(self.graphic, frame.quad, transform)
	else
		graphics.draw(self.graphic, transform)
	end
end

function sprite:release()
	self.transform:release()
end

return sprite