local HttpService = game:GetService("HttpService")

local Class = require(script.Class)
local Enum = require(script.Enum)

local RobloxAPI_METATABLE = {}
RobloxAPI_METATABLE.__index = RobloxAPI_METATABLE

function RobloxAPI_METATABLE:HasPermission(permission)
    if permission == "None" then
        return true
    elseif permission == "PluginSecurity" then
        local success = pcall(function()
            script:GetDebugId()
        end)
        return success
    elseif permission == "LocalUserSecurity" then
        local success = pcall(function()
            return game:GetService("Players").MaxPlayersInternal
        end)
        return success
    elseif permission == "RobloxScriptSecurity" then
        local success = pcall(function()
            return game:GetService("RunService").ClientGitHash
        end)
        return success
    end
    error("Unknown permission: ".. permission)
end

function RobloxAPI_METATABLE:GetClasses()
    return self._classes
end

function RobloxAPI_METATABLE:GetEnums()
    return self._enums
end

function RobloxAPI_METATABLE:GetClass(className)
    return self._classes[className]
end

function RobloxAPI_METATABLE:GetEnum(enumName)
    return self._enums[enumName]
end

function RobloxAPI_METATABLE:GetProperties(instance)
    local class = self:GetClass(instance.ClassName)
    local properties = {}

    for propertyName, property in pairs(class:GetProperties()) do
        if property:IsScriptable() and property:CanLoad() and self:HasPermission(property:GetReadSecurity()) then
            properties[propertyName] = instance[propertyName]
        end
    end

    return properties
end

function RobloxAPI_METATABLE:GetFunctions(instance)
    local class = self:GetClass(instance.ClassName)
    local methods = {}

    for methodName, method in pairs(class:GetFunctions()) do
        if method:IsScriptable() then
            methods[methodName] = instance[methodName]
        end
    end

    return methods
end

function RobloxAPI_METATABLE:GetEvents(instance)
    local class = self:GetClass(instance.ClassName)
    local events = {}

    for eventName, event in pairs(class:GetEvents()) do
        if event:IsScriptable() then
            events[eventName] = instance[eventName]
        end
    end

    return events
end

local RobloxAPI = {}
RobloxAPI.__index = RobloxAPI

function RobloxAPI.__call(_,apiDump)
    apiDump = apiDump or RobloxAPI.dump()

    local self = {
        _classes = {},
        _enums = {},
    }

    for _,rawClass in ipairs(apiDump.Classes) do
        local class = Class(rawClass, self)
        self._classes[class.Name] = class
    end

    for _,rawEnum in ipairs(apiDump.Enums) do
        local enum = Enum(rawEnum, self)
        self._enums[enum.Name] = enum
    end

    return setmetatable(self, RobloxAPI_METATABLE)
end

function RobloxAPI.dump()
    -- TODO: Take in version argument

    return HttpService:JSONDecode(HttpService:RequestAsync({
        Url = "https://raw.githubusercontent.com/MaximumADHD/Roblox-Client-Tracker/roblox/API-Dump.json",
        Method = "GET",
    }).Body)
end

return setmetatable(RobloxAPI, RobloxAPI)