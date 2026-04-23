// The Swift Programming Language
// https://docs.swift.org/swift-book
// OC Library Admin Panel
// Created on 4-22-2026
// Created by Sam Harford

import Foundation
import GRDB

// Constants

// The current date when running the program - PUT INSIDE THE CODE LATER - HERE TEMP
let currentDate = Date()


// Structs

/// A Customer is the registered client who is renting out a book from the system.
struct Customer: Identifiable, Codable, CustomStringConvertible, FetchableRecord, PersistableRecord
{
    // A Customer's unique identifier
    let id: Int

    // A Customer's name
    let name: String

    // A Customer's phone number
    let phoneNumber: String

    // A Customer's email address (Optional)
    let email: String

    // Syncs the names between swift variables and titles in the database
    enum CodingKeys: String, CodingKey {
        case id = "CustomerId"
        case name = "Name"
        case phoneNumber = "Phone"
        case email = "Email"
    }


}

@main
struct SwiftPlayground {
    static func main() {
                let dbPath = "./library.db"
        guard let dbQueue = try? DatabaseQueue(path: dbPath) else {
            fatalError("Failed to connect to database.")
        }
        print(currentDate)
    }
}
