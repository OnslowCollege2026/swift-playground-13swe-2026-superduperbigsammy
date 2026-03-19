// The Swift Programming Language
// https://docs.swift.org/swift-book
import Foundation
import GRDB

// Constants

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
        static let reservedTable = Column("ReservedTable")
        static let name = Column("Name")
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
struct Item: Identifiable, Codable, CustomStringConvertible, FetchableRecord, PersistableRecord {


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

    var description: String {
        return "Item \(id) (\(name)) costs $\(price)"
    }

    enum Columnns {
        static let id = "ItemId"
        static let name = "Name"
        static let price = "Price"
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

            // Finds a purchasers based on their purchaserId
            /// The ID Number that should be fetched
            let selectedPurchaserIds = 3
            try dbQueue.read { db in

                let purchaser = try Purchaser.fetchOne(db, key: selectedPurchaserIds)
                if let purchaser {
                    print("Selected purchaser is: \(purchaser.name)")
                } else {
                    print("nobody named \(purchaser)")
                }
            }

            // Finds all the people with the IDs in selectedPurchaserIdArray
            /// The ID Number that should be fetched
            print("witt array")
            let selectedPurchaserIdArray = [1, 2, 3]
            try dbQueue.read { db in

                let purchasers =
                    try Purchaser
                    .fetchAll(db, keys: selectedPurchaserIdArray)
                    print("People with the IDs: \(selectedPurchaserIdArray)")
                for purchaser in purchasers {
                    print(purchaser.name)
                }

            }

            // Find the purchasers with the reserved table
            print("FestchAll: Ordered by Name")
            let selectedReservedTable = "Rooftop Table 1"

            try dbQueue.read { db in

                let purchasers =
                    try Purchaser
                    .filter(Purchaser.Columns.reservedTable == selectedReservedTable)
                    .order(Purchaser.Columns.name)
                    .fetchAll(db)

                for purchaser in purchasers {
                    print("\(purchaser.name) has reserved \(selectedReservedTable)")
                }
            }

            // Item desc
            try dbQueue.read { db in
            
            /// The item youre tryna find
            let itemTrynaFind = 1

            let item = try Item.fetchOne(db, key:itemTrynaFind)

                if let item {
                    print(item.description)
                } else {
                    print("No item named \(itemTrynaFind)!")
                }
            
            }

            try dbQueue.read { db in
            
            let findingId = 1
            let item = try Item.fetchOne(db, id:findingId)
            let purchaser = try Purchaser.fetchOne(db, id: findingId)
            if let item, let purchaser{
                print("\(purchaser.name) has bought \(item)")
            }
            }


        } catch {
            /// If do fails, print the error out.
            print(error)
        }

    }
}
