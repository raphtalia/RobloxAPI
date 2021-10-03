local RobloxAPI = require(script.Parent)

return function()
    local api = RobloxAPI()

    describe("RobloxAPI", function()
        it("should be able to check permissions", function()
            expect(api:HasPermission("None")).to.be.equal(true)
            expect(api:HasPermission("PluginSecurity")).to.be.equal(false)
            expect(api:HasPermission("LocalUserSecurity")).to.be.equal(false)
            expect(api:HasPermission("RobloxScriptSecurity")).to.be.equal(false)
        end)

        it("should be able to get a class and its members", function()
            expect(api:GetClass("Instance")).to.be.a("table")
            expect(api:GetClass("Instance"):GetProperties()).to.be.a("table")
            expect(api:GetClass("Instance"):GetFunctions()).to.be.a("table")
            expect(api:GetClass("Instance"):GetEvents()).to.be.a("table")
        end)

        it("should be able to get members of an Instance", function()
            expect(api:GetProperties(workspace)).to.be.a("table")
            expect(api:GetFunctions(workspace)).to.be.a("table")
            expect(api:GetEvents(workspace)).to.be.a("table")
        end)

        it("should be able to return all classes", function()
            expect(api:GetClasses()).to.be.a("table")
        end)

        it("should be able t oreturn all enums", function()
            expect(api:GetEnums()).to.be.a("table")
        end)
    end)
end