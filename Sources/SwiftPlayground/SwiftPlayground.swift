// The Swift Programming Language
// https://docs.swift.org/swift-book
// OC Library Admin Panel
// Created on 4-22-2026
// Created by Sam Harford

import Foundation
import GRDB

// Constants
let dbPath = "Sources/SwiftPlayground/library.db"

// This header goes at the top of each menu page.
let header: String = """
    ----------------------------------------------
    \(Date()) - ONSLOW COLLEGE LIBRARY - ADMIN PANEL -
    """

/// The buttons for the menus, used to make selections. Edit these for global change of menuButtons
let menuButtons =
    ["1", "2", "3", "4", "5"]

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

    enum Columns {
        static let name = Column("Name")
    }

    var description: String {
        return """
            User \(id) - \(name). Contact: \(email) \(phone)
            """
    }
}

/// A Book is an instance of a book that is inside the library.
struct Books: Identifiable, Codable, FetchableRecord, PersistableRecord, CustomStringConvertible {
    static let dataBaseTableName = "Books"

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
        static let id = Column("BookId")
    }
    var description: String {
        return """
            [BOOK ID: \(id)] - \(title) - \(author). - *(\(totalCopies) copies remaining.)*
            """
    }
}

/// clear()
///
/// use clear() anywhere to clear the terminal.
func clear() {
    system("clear")
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
    // This switch uses the tableCHosen to determine which table to display
    switch tableChosen {
    // View the "Books" data
    case menuButtons[0]:
        do {
            // Attempt to read and display the data of the books table, ordered by id.
            try dbQueue.read { db in
                let allBooks =
                    try Books
                    .order(Books.Columns.id)
                    .fetchAll(db)
                // Print the description for every book in the table.
                for book in allBooks {
                    if book.totalCopies > 0 {
                        print(book.description)
                    }
                }
            }
        } catch {
            print(error)
        }

    // menuButtons 1 is the customers table.
    case menuButtons[1]:
        do {
            // Attempt to read and display the data of the books table, ordered by title.
            try dbQueue.read { db in
                let allCustomers =
                    try Customer
                    .order(Customer.Columns.name)
                    .fetchAll(db)
                // Print the description for every book in the table.
                for customer in allCustomers {
                    print(customer)
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
func rentBook(dbQueue: DatabaseQueue) {
    clear()
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

        let userInput = readLine()

        switch userInput {
        // Display all the books and prompt the user to register a book.
        case menuButtons[1]:
            print("Here are all the books currently in the library.")
            // Displays all the books.
            viewData(tableChosen: menuButtons[0], dbQueue: dbQueue)
            do {
                print("Please type the ID number of the book you wish to rent.")

                // the ID that the admin types to select a book.
                let rentingId = readLine()

                // Check if the book exists and confirm.
                try dbQueue.read { db in
                    let chosenBook = try Books.fetchOne(db, key: rentingId)
                    if let chosenBook {
                        print("You have selected \(chosenBook) by \(chosenBook.author)")
                    } else {
                        print("No book found with id \(rentingId).")
                    }
                    viewData(tableChosen: menuButtons[1], dbQueue: dbQueue)
                    print("Please type the name of the customer renting out the book.")

                    // the name of the customer renting the book.
                    let customerName = readLine()

                    try dbQueue.read { db in
                        let chosenCustomer = try Books.fetchOne(db, key: customerName)
                        if let chosenCustomer {
                            print("\(chosenCustomer) is attempting to rent out \(chosenBook)")
                        } else {
                            print("""
                            No customer found with name: \(chosenCustomer).
                            
                            Register new customer?
                            \(menuButtons[0]). Register new customer
                            \(menuButtons[1]). Return to main menu.

                            """)
                            let userInput = readLine()
                            switch userInput {
                                case menuButtons[0]:
                                print("Register new customer")
                                //registerNewCustomer()
                                case menuButtons[1]:
                                return
                                default:
                                print("Returning to main menu.")
                            }
                        }
                    }
                }
            } catch {
                print(error)
            }

        // If the userInput = menuButtons2, cancel the operation.
        case menuButtons[2]:
            print("Operation Cancelled")
            inRentMenu = false

        default:
            print("There was an error with your operation.")
        }
    }
}

/// returnBook()
///
/// *This function is used when the customer wants to return a book.*
func returnBook() {
    clear()
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
    clear()
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
                try dbQueue.read { db in
                    let schema = try db.dumpSchema()
                    print(schema)
                }
            }
            var inMainMenu = true

            while inMainMenu == true {
                print(
                    """
                    \n\n\n\n\n
                    \(header) MAIN MENU
                    Welcome to the Onslow College Library admin panel. Please select an operation.
                    \(menuButtons[0]). Rent a book
                    \(menuButtons[1]). Return a book
                    \(menuButtons[2]). Edit a database
                    \(menuButtons[3]). View a database
                    \(menuButtons[4]). Shut down system.
                    """)
                let userInput = readLine()

                switch userInput {
                // Sends the user to the renBook function
                case menuButtons[0]:
                    rentBook(dbQueue: dbQueue)
                    inMainMenu = false

                // Sends the user to the returnBook function
                case menuButtons[1]:
                    returnBook()
                    inMainMenu = false

                // Sends the user to the editData function
                case menuButtons[2]:
                    rentBook(dbQueue: dbQueue)
                    inMainMenu = false

                // Sends the user to the viewData function
                case menuButtons[3]:
                    do {
                        viewData(tableChosen: menuButtons[0], dbQueue: dbQueue)
                    }
                    break
                // Sends the user to the viewData function
                case menuButtons[4]:
                    inMainMenu = false
                default:
                    print("Please select an operation by typing \(menuButtons)")
                }

            }
        } catch {
            print(error)
        }
    }
}
