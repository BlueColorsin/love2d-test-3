local animation = {} ---@class animation

--function used by the implement function to 
function animation:append()
	self.animation = true

	self.current_anim = nil
	self.anim_name = ""

	self.current_frame = nil

	self.anim_timer = 0
	self.anim_playing = false
	self.anim_finished = false

	self.anim_index = 1
	self.frame_index = 1

	self.anim_step = 1

	---signals (need to be implimented)
	self._anim_finish = nil
	self._anim_frame_change = nil

	self.frames = self.frames or {}
	self.anims = self.anims or {}
end

function animation:handle_animation(dt)
	local anim = self.current_anim

	if not self.playing or not anim then return end
	self.anim_timer = self.anim_timer + dt

	if self.anim_timer >= (1 / anim.fps) then
		self.anim_timer = 0

		if not (self.anim_index + self.anim_step > #anim.frames) then
			-- little trick I learned from the troll-engine repo
		elseif anim.loop then
			self:setAnimIndex(1)
		else
			self.playing = false
			self.finished = true
			--callback
		end

		self:setAnimIndex(self.anim_index + self.anim_step)
	end
end

---@param name string
---@param dynamic table | string
---@param fps number
---@param loop boolean
---@param offset table
---@param priority number
function animation:add_anim(name, dynamic, fps, loop, offset, priority)
	local frames

	if type(dynamic) == "string" then
		frames = self.frames.tags[dynamic]
		assert(frames, "ADD_ANIM ERROR <"..name..">: NO TAG CALLED ("..dynamic.."), GET TAG PLEASE!")
	elseif type(dynamic) == "table" then
		frames = dynamic
	end

	assert(frames or #frames == 0, "ADD_ANIM ERROR <"..name..">: NO FUCKING FRAMES, GET FRAMES PLEASE!")

	priority = math.abs(priority or frames.priority or 1)
	priority = priority < 255 and priority or 255

	self.anims[name] = {
		frames 	 = frames,
		fps    	 = fps    or frames.fps,
		--optional
		offset 	 = offset   or frames.offset,
		loop   	 = loop     or frames.loop     or false,
		priority = priority
	}
end

---
---@param name string | table
---@param priority number | boolean
---@param start_frame integer
function animation:play_anim(name, priority, start_frame)
	priority = (priority == true and 256 or priority)

	if self.playing and self.current_anim.priority > priority then return end
	if not self.anims[name] then return end

	self.current_anim = self.anims[name]
	self.anim_name = name
	self:setAnimIndex(start_frame or 1)

	self.playing = true
	self.finished = false
end

function animation:setAnimIndex(index)
	self.anim_index = index
	self:setFrame(self.current_anim.frames[index])
end

function animation:setFrame(index)
	if self.frames[index] == nil or self.frame_index == index then
		return
	end

	local frame = self.frames[index]

	self.width = frame.dimensions[1]
	self.height = frame.dimensions[2]

	self.current_frame = frame
	self.frame_index = index
end

return animation
