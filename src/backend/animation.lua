local animation = object:extend() ---@class animation:object

local templateAnimation = {
	fps = 24,
	frames = {},
	
	--optional
	loop = false,
	offset = {0, 0},
	flipX = false,
	flipY = false
}

function animation:_new(parent)
	self.parent = parent
	self.frames = parent.frames

	self.currentAnimation = nil
	self.animationName = ""

	self.animTimer = 0
	self.playing = false
	self.finished = false

	self.onFinish = nil
	self.onFrameChange = nil

	-- just stop the controller and manually change the offset 
	self._index = 1

	self.animations = {}
end

function animation:addByTag(name, tag, fps, loop, offset, flipX, flipY)
	local frames = self.frames.tags[tag]

	assert(frames, "ADDBYTAG ERROR <"..name..">: NO FUCKING TAG CALLED ("..tag.."), GET TAG PLEASE!")

	self:add(name, frames, fps, loop, offset, flipX, flipY)
end

function animation:addByIndices(name, tag, indices, fps, loop, offset, flipX, flipY)
	local _frames = self.frames.tags[tag]

	assert(_frames, "ADDBYINDICES ERROR <"..name..">: NO FUCKING TAG CALLED ("..tag.."), GET TAG PLEASE!")
	assert(indices or #indices == 0, "ADDBYINDICES ERROR <"..name..">: *sigh*, you used the addByIndices function, and you didn't even add any indices")

	local frames = {}
	for key, value in pairs(_frames) do
		if tonumber(key) == nil or indices[key] then
			frames[key] = value
		end
	end

	self:add(name, frames, fps, loop, offset, flipX, flipY)
end

function animation:add(name, frames, fps, loop, offset, flipX, flipY)
	assert(frames, "ADD ANIMATION ERROR <"..name..">: NO FUCKING FRAMES, GET FRAMES PLEASE!")

	self.animations[name] = {
		frames = frames,
		fps    = fps    or frames.fps,
		--optional
		offset = offset or frames.offset,
		loop   = loop   or frames.loop,
		flipX  = flipX  or frames.flipX,
		flipY  = flipY  or frames.flipY
	}
end

local function set_index(self, index)
	self._index = index
	self.parent:setFrame(self.currentAnimation.frames[index])
end

function animation:update(dt)
	if self.playing then
		self.animTimer = self.animTimer + dt
	end

	local anim = self.currentAnimation

	if self.animTimer >= (1 / anim.fps) then
		self.animTimer = 0

		if not (self._index + 1 > #anim.frames) then
			-- little trick I learned from the troll-engine repo
		elseif anim.loop then
			set_index(self, 1)
		else
			self.playing = false
			self.finished = true
			--callback
		end

		set_index(self, self._index + 1)
	end
end

function animation:play(tag, forced, startFrame)
	if self.playing and not forced then return end
	if not self.animations[tag] then return end

	self.currentAnimation = self.animations[tag]
	self.animationName = tag
	set_index(self, startFrame or 1)

	self.playing = true
	self.finished = false
end

function animation:release()
	for key, value in pairs(self) do
		rawset(self, key, nil)
	end

	self = nil
end

return animation
