local MEMBER_METATABLE = {}
MEMBER_METATABLE.__index = MEMBER_METATABLE

function MEMBER_METATABLE:IsA(memberType)
    return memberType == self.MemberType
end

function MEMBER_METATABLE:GetTags()
    return {unpack(self._tags)}
end

function MEMBER_METATABLE:HasTag(tag)
    if table.find(self:GetTags(), tag) then
        return true
    end
    return false
end

function MEMBER_METATABLE:IsDeprecated()
    if self:HasTag("Deprecated") then
        return true
    end
    return false
end

function MEMBER_METATABLE:IsReadOnly()
    if self:HasTag("ReadOnly") then
        return true
    end
    return false
end

function MEMBER_METATABLE:IsReplicated()
    if self:HasTag("NotReplicated") then
        return false
    end
    return true
end

function MEMBER_METATABLE:IsScriptable()
    if self:HasTag("NotScriptable") then
        return false
    end
    return true
end

function MEMBER_METATABLE:GetReadSecurity()
    return self._security.Read
end

function MEMBER_METATABLE:GetWriteSecurity()
    return self._security.Write
end

local PROPERTY_METATABLE = setmetatable({}, MEMBER_METATABLE)
PROPERTY_METATABLE.__index = PROPERTY_METATABLE

function PROPERTY_METATABLE:GetValueType()
    return self._valueType
end

function PROPERTY_METATABLE:GetCategory()
    return self._category
end

function PROPERTY_METATABLE:CanLoad()
    return self._serialization.CanLoad
end

function PROPERTY_METATABLE:CanSave()
    return self._serialization.CanSave
end

local FUNCTION_METATABLE = setmetatable({}, MEMBER_METATABLE)
FUNCTION_METATABLE.__index = FUNCTION_METATABLE

function FUNCTION_METATABLE:Yields()
    if self:HasTag("Yields") then
        return true
    end
    return false
end

function FUNCTION_METATABLE:GetParameters()
    local parameters = {}

    for _,parameter in ipairs(self._parameters) do
        parameters[parameter.Name] = parameter.Type
    end

    return parameters
end

function FUNCTION_METATABLE:GetReturnType()
    return self._returnType
end

local EVENT_METATABLE = setmetatable({}, MEMBER_METATABLE)
EVENT_METATABLE.__index = EVENT_METATABLE

function EVENT_METATABLE:GetParameters()
    local parameters = {}

    for _,parameter in ipairs(self._parameters) do
        parameters[parameter.Name] = parameter.Type
    end

    return parameters
end

return function(rawMember)
    local memberType = rawMember.MemberType

    local self = {
        _tags = rawMember.Tags or {},
        _security = rawMember.Security,

        Name = rawMember.Name,
        MemberType = memberType,
        ThreadSafety = rawMember.ThreadSafety,
    }

    if memberType == "Property" then
        self._valueType = rawMember.ValueType
        self._category = rawMember.Category
        self._serialization = rawMember.Serialization

        return setmetatable(self, PROPERTY_METATABLE)
    elseif memberType == "Function" or memberType == "Callback" then
        self._returnType = rawMember.ReturnType
        self._parameters = rawMember.Parameters

        return setmetatable(self, FUNCTION_METATABLE)
    elseif memberType == "Event" then
        self._parameters = rawMember.Parameters

        return setmetatable(self, EVENT_METATABLE)
    end
end