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
struct Customer: Identifiable, Codable, FetchableRecord, PersistableRecord {
    // A Customer's unique identifier
    let id: Int64

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

/// A Book is an instance of a book that is inside the library.
struct Books: Identifiable, Codable, FetchableRecord, PersistableRecord {
    // A Book's unique identifier.
    let id: Int64

    // The title of the book.
    let title: String

    // The author of the book.
    let author: String

    // The total amount of copies that the library has in it's collection.
    let totalCopies: Int

    // Syncs the names between swift variables and titles in the database
    enum CodingKeys: String, CodingKey {
        case id = "bookId"
        case title = "Title"
        case author = "Author"
        case totalCopies = "TotalCopies"
    }
}

@main
struct SwiftPlayground {
    static func main() {

        print("""
        Welcome to the Onslow College Library admin panel. Please select an operation.
        1. Rent a book
        2. Return a book
        3. Edit a database
        4. Generate report
        """)

        let dbPath = "./library.db"
        guard let dbQueue = try? DatabaseQueue(path: dbPath) else {
            fatalError("Failed to connect to database.")
        }
        print(currentDate)
    }
}
