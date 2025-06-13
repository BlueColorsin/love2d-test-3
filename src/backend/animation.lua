local animation = object:extend()

local templateAnimation = {
	fps = 24,
	loop = false,

	--optional
	offset = {0, 0},
	flipX = false,
	flipY = false
}

function animation:_new(parent)
	self.parent = parent
	self.frames = parent.frames

	self.currentAnimation = nil

	self.animTimer = 0
	self.playing = false

	self.animations = {}
end

function animation:addByTag(name, tag, fps, loop, offset, flipX, flipY)
	assert(self.frames.tags[tag], "ADDBYTAG ERROR <"..name..">: NO FUCKING TAG CALLED ("..tag.."), GET TAG PLEASE!")


end

function animation:addByIndices(name, tag, indices, fps, loop, offset, flipX, flipY)
	assert(self.frames.tags[tag], "ADDBYINDICES ERROR <"..name..">: NO FUCKING TAG CALLED ("..tag.."), GET TAG PLEASE!")
	assert(indices or #indices == 0, "ADDBYINDICES ERROR <"..name..">: *sigh*, you used the addByIndices function, and you didn't even add any indices")

	
end

function animation:add(name, frames, fps, loop, offset, flipX, flipY)
	assert(frames, "ADD ANIMATION ERROR <"..name..">: NO FUCKING FRAMES, GET FRAMES PLEASE!")


end

function animation:update(dt)
	if self.playing then
		self.animTimer = self.animTimer + dt
		
	end
end

function animation:play(tag, forced)
	
end

return animation
