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

    enum Columns{
        static let name = Column("Name")
    }
    var description: String {
        return """
            Book \(id) - \(title) - \(author). Library holds \(totalCopies) copies.
            """
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
            do {dbQueue.read({ database in
                try database.dumpSchema()
            })} catch

            var isProgramRunning: Bool = true

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
                if readLine() == menuButtons[0] {
                    //registerCustomer()
                }
                if readLine() == menuButtons[1] {
                    print("Here are all the books currently held in the library:")
                    print()
                    for book in Books {
                        Books.description
                    }
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

            /// viewData()
            ///
            /// *This function is used when the customer wants to return a book.*
            func viewData() {
                // STarts the loop which repeats if input not valid.
                var inViewDataMenu = true
                while inViewDataMenu {
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

            while isProgramRunning == true {

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
                if userInput == menuButtons[0] {
                    rentBook()
                    break

                } else if userInput == menuButtons[1] {
                    returnBook()
                    break
                } else if userInput == menuButtons[2] {
                    rentBook()
                    break
                } else if userInput == menuButtons[3] {
                    viewData()
                    break
                } else {
                    print("Please select an operation by typing \(menuButtons)")
                }

            }
        } catch {
            print(error)
        }
    }
}
