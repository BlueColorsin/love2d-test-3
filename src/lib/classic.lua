--
-- classic
--
-- Copyright (c) 2014, rxi
--
-- This module is free software; you can redistribute it and/or modify it under
-- the terms of the MIT license. See LICENSE for details.
--

local object = {} ---@class object
object.__index = object

function object:_new() end

function object:extend()
	local cls = {}
	for k, v in pairs(self) do
		if k:find("__") == 1 then
			cls[k] = v
		end
	end
	cls.__index = cls
	cls.super = self
	setmetatable(cls, self)
	return cls
end

function object:implement(...)
	for _, cls in pairs({...}) do
		for k, v in pairs(cls) do
			if self[k] == nil and type(v) == "function" and k ~= "append" then
				self[k] = v
			end
		end

		-- added functionality so I can make implements more at home easier
		if type(cls["append"]) == "function" then
			cls["append"](self)
		end
	end
end

function object:is(T)
	local mt = getmetatable(self)
	while mt do
		if mt == T then
			return true
		end
		mt = getmetatable(mt)
	end
	return false
end

function object:__tostring()
	return "Object"
end

---@generic T : table
---@return T
function object:new(...)
	local obj = setmetatable({}, self)
	obj:_new(...)
	return obj
end

return object
