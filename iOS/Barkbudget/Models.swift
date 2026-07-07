import Foundation

struct ExpenseEntry: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var date: Date
    var amount: Double
    var category: String
    var createdAt: Date = Date()
}
