local dialog = {}

local curDialog = 1
local timeline = nil

-- "<b>" pause indicator
-- "-" new bulletpoint
-- "<s>" skips till the next bulletpoint
-- "<p>" litterally progresses the dialog right then and there
-- "[]" seperators for colors
-- "-woah<b><s>-this may be [2]crazy[/2]..."
local dialog_template = {
	text = "",
	char = "",
	speed = 0.005,
	styles = {{1,1,1,1,"font"}}, -- (always will assume [5] is font, if nil then used default)
	effect = ""
}

function dialog:loadTimeline(_timeline)
	curDialog = 1


end

-- this is where the magic happends
local curText = 1
local texts = {{text = {}, font = nil, x = 0, y = 20}}

local textIndex = 0 -- for the next function

function dialog:update(dt)
	if prev_time+0.05 < love.timer.getTime() then
	end
end

local graphics = love.graphics ---@type love.graphics

local function drawText(data)
	local font = data.font or love.graphics.getFont()

	love.graphics.printf(data.text, data.x, data.y)
end

function dialog:draw()
end

function dialog:progress()

end

return dialog
