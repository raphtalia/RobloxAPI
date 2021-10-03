local Member = require(script.Parent.Member)

local CLASS_METATABLE = {}
CLASS_METATABLE.__index = CLASS_METATABLE

function CLASS_METATABLE:GetProperties()
    local properties = {}

    local class = self
    repeat
        for _,member in pairs(class._members) do
            if member.MemberType == "Property" then
                properties[member.Name] = member
            end
        end
        class = class:GetSuperclass()
    until not class

    return properties
end

function CLASS_METATABLE:GetFunctions()
    local functions = {}

    local class = self
    repeat
        for _,member in pairs(class._members) do
            if member.MemberType == "Function" then
                functions[member.Name] = member
            end
        end
        class = class:GetSuperclass()
    until not class

    return functions
end

function CLASS_METATABLE:GetEvents()
    local events = {}

    local class = self
    repeat
        for _,member in pairs(class._members) do
            if member.MemberType == "Event" then
                events[member.Name] = member
            end
        end
        class = class:GetSuperclass()
    until not class

    return events
end

function CLASS_METATABLE:GetTags()
    return {unpack(self._tags)}
end

function CLASS_METATABLE:GetSuperclass()
    local superclass = self._superclass
    if superclass then
        return self._api:GetClass(superclass)
    end
end

function CLASS_METATABLE:GetProperty(propertyName)
    local member = self:GetProperties()[propertyName]
    if member.MemberType == "Property" then
        return member
    end
end

function CLASS_METATABLE:GetFunction(functionName)
    local member = self:GetFunctions()[functionName]
    if member.MemberType == "Function" then
        return member
    end
end

function CLASS_METATABLE:GetEvent(eventName)
    local member = self:GetEvents()[eventName]
    if member.MemberType == "Event" then
        return member
    end
end

function CLASS_METATABLE:HasTag(tag)
    if table.find(self._tags, tag) then
        return true
    end
    return false
end

function CLASS_METATABLE:IsDeprecated()
    if self:HasTag("Deprecated") then
        return true
    end
    return false
end

function CLASS_METATABLE:IsReplicated()
    if self:HasTag("NotReplicated") then
        return false
    end
    return true
end

function CLASS_METATABLE:IsService()
    if self:HasTag("Service") then
        return true
    end
    return false
end

function CLASS_METATABLE:IsCreatable()
    if self:HasTag("NotCreatable") then
        return false
    end
    return true
end

return function(rawClass, api)
    local self = {
        _api = api,
        _members = {},
        _tags = rawClass.Tags or {},
        _superclass = rawClass.Superclass ~= "<<<ROOT>>>" and rawClass.Superclass or nil,

        Name = rawClass.Name,
        MemoryCategory = rawClass.MemoryCategory,
    }

    for _,rawMember in ipairs(rawClass.Members) do
        local member = Member(rawMember)
        self._members[member.Name] = member
    end

    return setmetatable(self, CLASS_METATABLE)
end