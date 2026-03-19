import Foundation
import Testing
@testable import Klawty

@Suite(.serialized) struct NodeServiceManagerTests {
    @Test func `builds node service commands with current CLI shape`() throws {
        let tmp = try makeTempDirForTests()
        CommandResolver.setProjectRoot(tmp.path)

        let klawtyPath = tmp.appendingPathComponent("node_modules/.bin/klawty")
        try makeExecutableForTests(at: klawtyPath)

        let start = NodeServiceManager._testServiceCommand(["start"])
        #expect(start == [klawtyPath.path, "node", "start", "--json"])

        let stop = NodeServiceManager._testServiceCommand(["stop"])
        #expect(stop == [klawtyPath.path, "node", "stop", "--json"])
    }
}
