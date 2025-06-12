local sprite = object:extend() ---@class sprite:object

-- I LOVE TURNINATIRES!

function sprite:_new(x, y, graphic)
	self.x = x or 0
	self.y = y or 0

	self.graphic = graphic or nil ---@type love.Image

	self.animation = nil -- I lowk gotta shake that belly!

	self.frames = {}

	self.width = self.graphic:getWidth()
	self.height = self.graphic:getHeight()

	self.curFrame = nil
	self.frameIndex = nil
end

function sprite:setFrame(index)
	if self.frames[index] == nil then return end

	local frame = self.frames[index]

	self.width = frame.dimensions[1]
	self.height = frame.dimensions[2]

	self.curFrame = frame
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
	self:setFrame(1)
end

function sprite:update(dt)

end

function sprite:render()
	local graphics = love.graphics ---@type love.graphics

	local frame = self.curFrame

	graphics.push()

	graphics.translate(frame.offset[1], frame.offset[2])

	if frame.rotation then
		graphics.rotate(frame.rotation)
	end

	graphics.draw(self.graphic, frame.quad, self.x+self.width/2, self.y+self.height/2, 0, 1, 1, self.width / 2, self.height / 2)

	graphics.pop()

	graphics.setPointSize(4)
	graphics.points(frame.offset[1], frame.offset[2])
end

function sprite:release()

end

return sprite