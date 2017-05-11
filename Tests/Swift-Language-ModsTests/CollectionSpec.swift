import Spec
import Nimble
@testable import Swift_Language_Mods

class CollectionSpec : Spec {
    func testEachWithObject() {
        let array = [1, 2, 3, 4]

        describe("given a value type") {
            it("returns the argument given if it was unmodified") {
                expect(array.eachWithObject("string") { _ in } )
                    .to(equal("string"))
            }

            it("allows the argument to be modified in the block") {
                expect(array.eachWithObject("string") { $0 += "\($1)" })
                    .to(equal("string1234"))
            }

            it("works with hashes") {
                expect(array.eachWithObject([Int : String]()) { $0[$1] = "hello" })
                    .to(equal([ 1 : "hello", 2 : "hello", 3 : "hello", 4 : "hello" ]))
            }
        }

        describe("given a reference type") {
            class DummyRefType {
                var property: Int
                init(property: Int = 0) { self.property = property }
            }

            it("returns the passed object given if it was unmodified") {
                let r = DummyRefType()
                expect(array.eachWithObject(r) { _ in } ).to(beIdenticalTo(r))
            }

            it("allows the passed object to be modified in the block") {
                let r = DummyRefType()
                array.eachWithObject(r) { $0.property = $1 }
                expect(r.property).to(equal(4))
            }

            it("allows a new object to be created, though this is an unwise practice") {
                let r = DummyRefType()
                let new: DummyRefType = array.eachWithObject(r) { $0 = DummyRefType(property: $1) }
                expect(new).notTo(beIdenticalTo(r))
            }
        }
    }
}
