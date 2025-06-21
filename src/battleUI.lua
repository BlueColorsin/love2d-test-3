local battleUI = {}

local graphic = love.graphics.newImage("assets/battle_ui.png")

local function get_frame(element)
	if element.current_frame + 1 > #element then
		return 1
	end
	return element.current_frame + 1
end

local function get_frame_but_uhh(element)
	if element.current_frame + 1 > #element then
		return 3
	end
	return element.current_frame + 1
end

local elements = {
	box = {
		current_frame = 1,
		{quad = love.graphics.newQuad(182, 2, 131, 51, graphic), dimensions = { 131, 51 }, offset = { 0, 0 }},
		{quad = love.graphics.newQuad(182, 55, 131, 51, graphic), dimensions = { 131, 51 }, offset = { 0, 0 }}
	},
	sparkle = {
		current_frame = 1,
		{angle = 4.7123889803847, offset = { 21, 61 }, dimensions = { 64, 85 }, quad = love.graphics.newQuad(2, 193, 31, 30, graphic)},
		{quad = love.graphics.newQuad(115, 167, 64, 85, graphic), dimensions = { 64, 85 }, offset = { 0, 0 } },
		{angle = 4.7123889803847, offset = { 6, 77 }, dimensions = { 64, 85 }, quad = love.graphics.newQuad(122, 113, 57, 52, graphic)},
		{quad = love.graphics.newQuad(256, 282, 48, 61, graphic), dimensions = { 64, 85 }, offset = { 8, 19 } }
	},
	speechbubble = {
		current_frame = 1,
		{quad = love.graphics.newQuad(113, 254, 28, 76, graphic), dimensions = { 89, 76 }, offset = { 18, 0 } },
		{angle = 4.7123889803847, offset = { 0, 76 }, dimensions = { 89, 76 }, quad = love.graphics.newQuad(292, 146, 22, 89, graphic)},
		{angle = 4.7123889803847, offset = { 7, 74 }, dimensions = { 89, 76 }, quad = love.graphics.newQuad(207, 282, 47, 63, graphic)},
		{quad = love.graphics.newQuad(207, 230, 63, 50, graphic), dimensions = { 89, 76 }, offset = { 8, 25 } }
	},
	sword = {
		current_frame = 1,
		{angle = 4.7123889803847, offset = { 34, 178 }, dimensions = { 143, 207 }, quad = love.graphics.newQuad(2, 2, 178, 109, graphic)},
		{quad = love.graphics.newQuad(143, 254, 62, 69, graphic), dimensions = { 143, 207 }, offset = { 3, 137 }},
		{quad = love.graphics.newQuad(41, 276, 70, 79, graphic), dimensions = { 143, 207 }, offset = { 1, 126 }},
		{quad = love.graphics.newQuad(41, 193, 70, 81, graphic), dimensions = { 143, 207 }, offset = { 0, 126 }}
	}
}
elements.fight = {
	selected_element = elements.sword,
	current_frame = 1,
	{quad = love.graphics.newQuad(2, 113, 118, 38, graphic), dimensions = { 131, 51 }, offset = { 8, 6 }},
	{quad = love.graphics.newQuad(182, 108, 120, 36, graphic), dimensions = { 131, 51 }, offset = {6, 7}}
}
elements.act = {
	selected_element = elements.speechbubble,
	current_frame = 1,
	{quad = love.graphics.newQuad(2, 254, 37, 95, graphic), dimensions = { 131, 51 }, offset = { 20, 43 }, angle = 4.7123889803847},
	{quad = love.graphics.newQuad(181, 187, 107, 41, graphic), dimensions = { 131, 51 }, offset = { 19, 1 }}
}
elements.item = {
	selected_element = elements.sparkle,
	current_frame = 1,
	{quad = love.graphics.newQuad(181, 146, 109, 39, graphic), dimensions = { 131, 51 }, offset = {12, 6}},
	{quad = love.graphics.newQuad(2, 153, 111, 38, graphic), dimensions = { 131, 51 }, offset = {11, 6 }}
}

function battleUI:init()
	self.items = {"fight", "act", "item"}
	self.selected_anims = {"sword", "speechbubble", "sword"}

	self.anim_timer = 0

	self.playing = false

	self.x = 0
	self.y = 0

	self.batch = love.graphics.newSpriteBatch(graphic, 7) ---@type love.SpriteBatch

	self.frame_duration = 1/12

	self.current_selected = 1
end

function battleUI:select()
	
end

function battleUI:progress_animation(element)

end

function battleUI:render_element(element, x, y, r, sx, sy, ox, oy, kx, ky)
	local frame = element[element.current_frame]
	local quad = frame.quad

	self.batch:add(elements.box[1].quad, x, y)

	x = (x or 0) + frame.offset[1]
	y = (y or 0) + frame.offset[2]
	r = (r or 0)

	if frame.angle then
		r = r + frame.angle
	end

	local originX,originY = frame.dimensions[1], frame.dimensions[2]
	originX, originY = originX * 0.5, originY * 0.5
	
	self.batch:add(quad, x+originX, y+originY, r, 1, 1, originX, originY)
end

function battleUI:update(dt)
	if not self.playing then
		goto skip_animation
	end

	if self.anim_timer < self.frame_duration then
		for k,v in pairs(sprites) do
			self:progress_animation(v)
		end
	end

	self.anim_timer = self.anim_timer + dt

	::skip_animation::
end

function battleUI:render()
	local graphics = love.graphics ---@type love.graphics

	for index, value in pairs(self.items) do
		self:render_element(elements[value], 0, 100*index-1)
	end

	graphics.draw(self.batch)
	graphics.print(self.batch:getCount(), 0, 0, 0)
	self.batch:clear()
	
	graphics.points(0, 0)

end

return battleUI