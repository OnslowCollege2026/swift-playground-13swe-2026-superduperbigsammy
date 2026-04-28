// The Swift Programming Language
// https://docs.swift.org/swift-book
// OC Library Admin Panel
// Created on 4-22-2026
// Created by Sam Harford

import Foundation
import GRDB

// Constants
let dbPath = "./library.db"

// This header goes at the top of each menu page.
let header: String = """
    ----------------------------------------------
    \(Date()) - ONSLOW COLLEGE LIBRARY - ADMIN PANEL -
    """

// The buttons for the menus, used to make selections. Edit here for global change of menuButtons
let menuButtons =
    ["1", "2", "3", "4"]

// Structs

/// A Customer is the registered client who is renting out a book from the system.
struct Customer: Identifiable, Codable, CustomStringConvertible, FetchableRecord, PersistableRecord
{
    // A Customer's unique identifier
    let id: Int64

    // A Customer's name
    let name: String

    // A Customer's phone number
    let phone: String

    // A Customer's email address (Optional)
    let email: String

    // Syncs the names between swift variables and titles in the database
    enum CodingKeys: String, CodingKey {
        case id = "CustomerId"
        case name = "Name"
        case phone = "Phone"
        case email = "Email"
    }

    var description: String {
        return """
            User \(id) - \(name). Contact: \(email) \(phone)
            """
    }
}

/// A Book is an instance of a book that is inside the library.
struct Books: Identifiable, Codable, FetchableRecord, PersistableRecord, CustomStringConvertible {
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

    enum Columns {
        static let name = Column("Name")
    }
    var description: String {
        return """
            Book \(id) - \(title) - \(author). Library holds \(totalCopies) copies.
            """
    }
}

/// viewData()
///
/// - Parameters:
///     - tableChosen: The table that is supposed to be displayed.
///         - tableChosen = menuButtons[0]: The Books table
///         - tableChosen = menuButtons[1]: the Customers table
///     - dbQueue: The database queue for the database
/// 
/// viewData() is used to display tables from the dbPath
func viewData(tableChosen: String, dbQueue: DatabaseQueue) {

    switch tableChosen {
    // View the "Books" data
    case menuButtons[0]:
        do {
            // Attempt to read the data of the books table
            try dbQueue.read { db in
                let allBooks = try Books.fetchAll(db)
                // Print the description for every book in the table.
                for book in allBooks {
                    print(book.description)
                }
            }
        } catch {
            print(error)
        }

    // menuButtons 1 is the customers table.
    case menuButtons[1]:
                do {
            // Attempt to read the data of the books table
            try dbQueue.read { db in
                let allBooks = try Books.fetchAll(db)
                // Print the description for every book in the table.
                for book in allBooks {
                    print(book.description)
                }
            }
        } catch {
            print(error)
        }

    default:
        print("Please try again.")

    }
}

/// rentBook()
///
/// *This function is used when the admin is renting out a book on behalf of the customer.*
func rentBook() {
    // STarts the loop which repeats if input not valid.
    var inRentMenu = true
    while inRentMenu {
        // Displays a menu
        print(
            """
            \(header) RENT A BOOK
            Please select an operation.
            \(menuButtons[0]). Register a customer (Required)
            \(menuButtons[1]). Rent a book
            \(menuButtons[2]). Cancel Operation
            """)
    }

}

/// returnBook()
///
/// *This function is used when the customer wants to return a book.*
func returnBook() {
    // STarts the loop which repeats if input not valid.
    var inReturnMenu = true
    while inReturnMenu {
        // Displays a menu
        print(
            """
            \(header) RENT A BOOK
            Please select an operation.
            \(menuButtons[0]). Register a customer (Required)
            \(menuButtons[1]). Rent a book
            \(menuButtons[2]). Cancel Operation
            """)
    }
}

/// editData()
///
/// *This function is used when the customer wants to return a book.*
func editData() {
    // STarts the loop which repeats if input not valid.
    var inEditDataMenu = true
    while inEditDataMenu {
        // Displays a menu
        print(
            """
            \(header) RENT A BOOK
            Please select an operation.
            \(menuButtons[0]). Register a customer (Required)
            \(menuButtons[1]). Rent a book
            \(menuButtons[2]). Cancel Operation
            """)
    }
}

@main
struct SwiftPlayground {

    static func main() {
        do {

            // Stores the database queue, which is where the list of operations go.
            let dbQueue = try DatabaseQueue(path: dbPath)
            print("Connected to database.")

            // Dump the schema to ensure we are connected to the correct database file.
            do {
                try? dbQueue.read({ database in
                    try database.dumpSchema()
                })
            }

            var inMainMenu = true

            while inMainMenu == true {
                viewData(tableChosen: menuButtons[0], dbQueue: dbQueue)
                print(
                    """
                    \(header) MAIN MENU
                    Welcome to the Onslow College Library admin panel. Please select an operation.
                    \(menuButtons[0]). Rent a book
                    \(menuButtons[1]). Return a book
                    \(menuButtons[2]). Edit a database
                    \(menuButtons[3]). View a database
                    """)
                var userInput = readLine()

                switch userInput {
                case menuButtons[0]:
                    rentBook()
                    break

                case menuButtons[1]:
                    returnBook()
                    break
                case menuButtons[2]:
                    rentBook()
                    break
                case menuButtons[3]:
                    let tableChosen = userInput
                    viewData(tableChosen: "placeholder", dbQueue: dbQueue)
                    break
                default:
                    print("Please select an operation by typing \(menuButtons)")

                }

            }
        } catch {
            print(error)
        }
    }
}
