local ENUM_METATABLE = {}
ENUM_METATABLE.__index = ENUM_METATABLE

return function(rawEnum, api)
    local self = {
        _api = api,

        Name = rawEnum.Name,
    }

    return setmetatable(self, ENUM_METATABLE)
end