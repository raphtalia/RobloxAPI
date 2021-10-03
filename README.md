# RobloxAPI

Library for parsing MaximumADHD's [Roblox-Client-Tracker](https://github.com/MaximumADHD/Roblox-Client-Tracker) API
dumps.

## Example

```lua
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RobloxAPI = require(ReplicatedStorage.RobloxAPI)
local API = RobloxAPI()

local classes = API:GetClasses()
print(classes.BasePart)
print(API:GetClass("BasePart")) -- Identical to above

--[[
    These will include deprecated members but will exclude members not
    accessible by the current script identity.
]]
print(API:GetProperties(workspace))
print(API:GetFunctions(workspace))
print(API:GetEvents(workspace))

-- To get members not accessible by the current script identity
print(API:GetClass("BasePart"):GetProperties())
print(API:GetClass("BasePart"):GetFunctions())
print(API:GetClass("BasePart"):GetEvents())
```

## Members

```lua
-- All members have the following properties & methods
local member = API:GetClass("Instance"):GetProperties().Name
print(member.Name) --> "Name"
print(member.MemberType) --> "Property"
print(member.ThreadSafety) --> "ReadSafe"

print(member:IsA("Property")) --> true
print(member:GetTags()) --> string[]
print(member:HasTag("Deprecated")) --> false

-- Short-hand methods for HasTag()
print(member:IsDeprecated()) --> false
print(member:IsReadOnly()) --> false
print(member:IsReplicated()) --> true
print(member:IsScriptable()) --> true

print(member:GetReadSecurity()) --> "None"
print(member:GetWriteSecurity()) --> "None"
```

## Property members

```lua
local member = API:GetClass("Instance"):GetProperties().Name
print(member:GetValueType()) --> { Category: string, Name: string }
print(member:GetCategory()) --> String
print(member:CanLoad()) --> true
print(member:CanSave()) --> true
```

## Function members

```lua
local member = API:GetClass("Instance"):GetFunctions().Destroy
print(member:Yields()) --> false
print(member:GetParameters()) --> { Category: string, Name: string }[]
print(member:GetReturnType()) --> { Category: string, Name: string }
```

## Event members

```lua
local member = API:GetClass("Instance"):GetFunctions().Changed
print(member:GetParameters()) --> { Category: string, Name: string }[]
```
