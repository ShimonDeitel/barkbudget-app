import XCTest
@testable import Barkbudget

@MainActor
final class BarkbudgetTests: XCTestCase {
    var store: Store!

    override func setUp() {
        super.setUp()
        store = Store()
    }

    func testSeedDataLoaded() {
        XCTAssertGreaterThanOrEqual(store.entries.count, 3)
    }

    func testFreeLimitAboveSeedCount() {
        XCTAssertGreaterThan(Store.freeLimit, 3)
    }

    func testAddEntryIncreasesCount() {
        let before = store.entries.count
        store.add(ExpenseEntry())
        XCTAssertEqual(store.entries.count, before + 1)
    }

    func testDeleteEntryDecreasesCount() {
        store.add(ExpenseEntry())
        let before = store.entries.count
        store.delete(at: IndexSet(integer: 0))
        XCTAssertEqual(store.entries.count, before - 1)
    }

    func testCanAddMoreWhenUnderLimit() {
        store.entries = []
        XCTAssertTrue(store.canAddMore)
    }

    func testCannotAddMoreWhenAtLimitAndNotPro() {
        store.entries = (0..<Store.freeLimit).map { _ in ExpenseEntry() }
        store.isPro = false
        XCTAssertFalse(store.canAddMore)
    }

    func testCanAddMoreWhenProEvenAtLimit() {
        store.entries = (0..<Store.freeLimit).map { _ in ExpenseEntry() }
        store.isPro = true
        XCTAssertTrue(store.canAddMore)
    }

    func testUpdateEntryPersistsChange() {
        let entry = ExpenseEntry()
        store.add(entry)
        let updated = entry
        store.update(updated)
        XCTAssertEqual(store.entries.first?.id, entry.id)
    }
}
