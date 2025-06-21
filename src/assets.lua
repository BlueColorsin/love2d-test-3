local cache = {
	images = {},
	audio = {},
	atlases = {}
}

function cache:get(tag)

end

function cache:atlas(tag)

end

function cache:image(image, tag)
	if self.images[tag] then return true end
	self.images[tag] = image
	return false
end

function cache:audio(tag)

end

return cache
