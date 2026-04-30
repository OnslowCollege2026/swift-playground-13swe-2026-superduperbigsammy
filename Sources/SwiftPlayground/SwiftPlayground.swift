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
    ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"]

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
            [ID: \(id)]. - \(name). [Contact: \(email), \(phone)]
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
            [ID: \(id)]. - \(title) - \(author). (\(totalCopies) copies remaining.)
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

    // View all "Books" records
    case menuButtons[6]:
        do {
            // Attempt to read and display the data of the books table, ordered by id.
            try dbQueue.read { db in
                let allBooks =
                    try Books
                    .order(Books.Columns.id)
                    .fetchAll(db)
                // Print the description for every book in the table.
                for book in allBooks {
                    print(book.description)
                }
            }
        } catch {
            print(error)
        }

    // View avalible books
    case menuButtons[7]:
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

    // View unavalible books
    case menuButtons[8]:
        do {
            // Attempt to read and display the data of the books table, ordered by id.
            try dbQueue.read { db in
                let allBooks =
                    try Books
                    .order(Books.Columns.id)
                    .fetchAll(db)

                // Print the description for every book in the table.
                for book in allBooks {
                    if book.totalCopies <= 0 {
                        print(book.description)
                    }
                }

            }
        } catch {
            print(error)
        }

    // menuButtons 5 is the customers table.
    case menuButtons[5]:
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
        print("Error displaying data")
    }
}

/// rentBook()
///
/// *This function is used when the admin is renting out a book on behalf of the customer.*
func rentBook(dbQueue: DatabaseQueue) {
    clear()
    // STarts the loop which repeats if input not valid.

    print("Here are all the books currently avaliable in the library.")
    // Displays all the books.
    viewData(tableChosen: menuButtons[7], dbQueue: dbQueue)
    print("Please type the ID number of the book you wish to rent.")
    let selectedBookId = readLine()

    do {

        // Check if the book exists and confirm.
        try dbQueue.read { db in
            let chosenBook = try Books.fetchOne(db, key: selectedBookId)
            if let chosenBook {
                print("You have selected \(chosenBook) by \(chosenBook.author)")
            }
        }
        viewData(tableChosen: menuButtons[1], dbQueue: dbQueue)
        print("Please type the name of the customer renting out the book.")
        // the name of the customer renting the book.
    } catch { print(error) }
    do {
        let customerName = readLine()
        try dbQueue.read { db in
            let chosenCustomer = try Customer.fetchOne(db, key: customerName)
            if let chosenCustomer {
                print("\(chosenCustomer) was selected.")
            } else {
                print("No customer found with \(customerName)")
            }
        }

    } catch {
        print(error)
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

                    \(menuButtons[2]). Create a customer record
                    \(menuButtons[3]). Create a book record

                    \(menuButtons[4]). Edit a customer
                    \(menuButtons[5]). View all customers

                    \(menuButtons[6]). View all books done
                    \(menuButtons[7]). View avaliable books done
                    \(menuButtons[8]). View unavaliable books done

                    \(menuButtons[9]). Delete a book record
                    \(menuButtons[10]). Delete a customer record
                    \(menuButtons[11]). Shut down system.
                    """)
                let userInput = readLine()

                switch userInput {
                // Sends the user to the renBook function
                case menuButtons[0]:
                    rentBook(dbQueue: dbQueue)

                // Views all customers
                case menuButtons[5]:
                    viewData(tableChosen: menuButtons[5], dbQueue: dbQueue)

                // Views all books
                case menuButtons[6]:
                    viewData(tableChosen: menuButtons[6], dbQueue: dbQueue)
                // Views all avalible books
                case menuButtons[7]:
                    viewData(tableChosen: menuButtons[7], dbQueue: dbQueue)
                // Views all unavalible books
                case menuButtons[8]:
                    viewData(tableChosen: menuButtons[8], dbQueue: dbQueue)

                // Shut down system.
                case menuButtons[11]:
                    print("Thank you for using OC Library admin panel.")
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
