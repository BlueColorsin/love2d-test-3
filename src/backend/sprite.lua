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

	self.currentFrame = frame
	self.frameIndex = index
end

--sets the 
function sprite:setOrigin(...)
	local values = {...}
	local args = #values

	-- fucked up and evil polymorphism
	if args == 1 and type(values[1]) == "number" then
		local dimensions = self.frames[values[1]].dimensions
		self:set("origin", dimensions[1]/2, dimensions[2]/2)
	elseif args == 2 then
		self:set("origin", values[1], values[2])
	end
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

	graphics.setPointSize(8);

	transform:translate(self.x, self.y)

	local anim = self.animation.currentAnimation
	if anim.offset then
		transform:translate(-anim.offset[1], -anim.offset[2])
	end

	local centerx,centery = 0, 0
	transform:translate(self.origin[1] + anim.offset[1], self.origin[2] + anim.offset[2])
		transform:rotate(self.angle)
		transform:scale(self.scale[1], self.scale[2])
		transform:shear(self.shear[1], self.shear[2])
		centerx,centery = transform:transformPoint(0, 0)
	transform:translate(-self.origin[1] - anim.offset[1], -self.origin[2] - anim.offset[2])

	graphics.push()
		graphics.applyTransform(transform)
		graphics.rectangle("line", 0, 0, self.width, self.height)
	graphics.pop()
	
	local frame
	if self.animation then
		frame = self.currentFrame
		--relies that the spritesheet has the right angled offset
		transform:translate(frame.offset[1], frame.offset[2])

		if frame.angle then
			transform:rotate(frame.angle)
		end
	end

	if self.animation then
		graphics.draw(self.graphic, frame.quad, transform)
	else
		graphics.draw(self.graphic, transform)
	end

	love.graphics.points(centerx,centery)
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
