// The Swift Programming Language
// https://docs.swift.org/swift-book
import Foundation
import GRDB

// Constants

/// The ID Number that should be fetched
let selectedPurchaserIds = [1,2,3,4,5,6,7,8,9,10]

/// A Purchaser is the name for the reservation or purchaser at the cafe.
struct Purchaser: Identifiable, Codable, FetchableRecord, PersistableRecord {
    /// Idendifier for the Purchaser
    let id: Int

    /// Name of purchaser
    var name: String

    /// Count of people in the reservation
    var count: Int

    /// The name of the table reserved.
    var reservedTable: String

    // Links up the names for the database
    enum CodingKeys: String, CodingKey {
        case id = "PurchaserId"
        case name = "Name"
        case count = "Count"
        case reservedTable = "ReservedTable"
    }
	enum Columns {
		static let id = Column("PurchaserId")
	}
}

/// The order is the order sent to the kitchen
struct Order: Identifiable, Codable, FetchableRecord, PersistableRecord {
    /// Idendifier for the order
    let id: Int

    /// ID of the purchaser connected to the order
    let purchaserId: Int

    /// The cost of the order
    var amount: Double

    // Links up the names for the database
    enum CodingKeys: String, CodingKey {
        case id = "OrderId"
        case purchaserId = "PurchaserId"
        case amount = "amount"
    }
}

/// The item is the purchasable item that can be added to an order/orderLine
struct Item: Identifiable, Codable, FetchableRecord, PersistableRecord {
    /// Idendifier for the order
    let id: Int

    /// ID of the purchaser connected to the order
    let name: String

    /// The cost of the order
    var price: Double

    // Links up the names for the database
    enum CodingKeys: String, CodingKey {
        case id = "itemId"
        case name = "Name"
        case price = "Price"
    }
}

/// The orderLine is the order sent to the kitchen
struct OrderLine: Codable, FetchableRecord, PersistableRecord {
    /// Idendifier for the Purchaser
    let orderId: Int

    /// Name of purchaser
    let itemId: Int

    /// Count of people in the reservation
    var quantity: Int

    // Links up the names for the database
    enum CodingKeys: String, CodingKey {
        case orderId = "OrderId"
        case itemId = "ItemId"
        case quantity = "Quantity"
    }
}

@main
struct SwiftPlayground {
    static func main() {
        let dbpath = "Sources/SwiftPlayground/cafe.db"
        do {
            let dbQueue = try DatabaseQueue(path: dbpath)
            print("Connected to database.")

            // Dump the schema to ensure we are connected to the correct database file.
            try dbQueue.read({ database in
                try database.dumpSchema()
            })

            try dbQueue.read { db in

            // Finds a purchasers based on their purchaserId
	let purchaser = try Purchaser.fetchAll(db, ids: selectedPurchaserIds)


	if let purchaser {
		print("purchaser: \(purchaser.name)")
	} else {
		print("No purchaser with id \(selectedPurchaserIds)")
	}
}
        } catch {
            print(error)
        }

    }
}
