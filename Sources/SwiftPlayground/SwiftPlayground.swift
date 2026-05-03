// The Swift Programming Language
// https://docs.swift.org/swift-book
// OC Library Admin Panel
// Created on 4-22-2026
// Created by Sam Harford

import Foundation
import GRDB

// MARK: - CONSTANTS
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

// MARK: Customer Struct
/// A Customer is the registered client who is renting out a book from the system.
struct Customer: Identifiable, Codable, CustomStringConvertible, FetchableRecord, PersistableRecord,
    MutablePersistableRecord
{
    // A Customer's unique identifier
    let id: Int?

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

// MARK: Book Struct
/// A Book is an instance of a book that is inside the library.
struct Books: Identifiable, Codable, FetchableRecord, PersistableRecord, CustomStringConvertible {
    static let dataBaseTableName = "Books"

    // A Book's unique identifier.
    let id: Int?

    // The title of the book.
    let title: String

    // The author of the book.
    let author: String

    // The total amount of copies that the library has in it's collection.
    let totalCopies: Int

    // The amount of copies avaliable upon entry
    let avaliableCopies: Int

    // Syncs the names between swift variables and titles in the database
    enum CodingKeys: String, CodingKey {
        case id = "BookId"
        case title = "Title"
        case author = "Author"
        case totalCopies = "TotalCopies"
        case avaliableCopies = "AvaliableCopies"
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

// MARK: RentedBook Struct
struct RentedBooks: Codable, FetchableRecord, PersistableRecord {
    // bookID and CustomerID Imported from Books and Customer tables.
    var bookId: Int
    var customerId: Int
    // The date the book was rented out on
    var bookedDate: Date

    // The date the book is due on.
    var dueDate: Date

    enum CodingKeys: String, CodingKey {
        case bookId = "BookId"
        case customerId = "CustomerId"
        case bookedDate = "BookedDate"
        case dueDate = "DueDate"
    }
}

// MARK: clear()
/// clear()
///
/// use clear() anywhere to clear the terminal.
func clear() {
    system("clear")
}

//MARK: viewData()
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
                    if book.avaliableCopies > 0 {
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

// MARK: writeData()
/// writeData()
///
/// - Parameters
///     - tableChosen: The table selected
///     - dbQueue: The database queue path
///
/// This function allows you to write data to the table of your choice.
func writeData(tableChosen: String, dbQueue: DatabaseQueue) {
    clear()
    print("\(header) WRITE DATA")
    // This switch uses the tableCHosen to determine which table to display
    switch tableChosen {

    // Create a book instance and persist it to the database.
    case menuButtons[2]:
        do {
            print("Customer Name (Required):")
            var nameTyped = readLine()!

            print("Valid Customer Phone (Required):")
            var phoneTyped = readLine()!

            print("Customer Email (Optional):")
            var emailTyped = readLine()!

            // Attempt to read and display the data of the books table, ordered by id.
            try dbQueue.write { db in
                var newCustomer = Customer(
                    id: nil, name: nameTyped, phone: phoneTyped, email: emailTyped)
                try newCustomer.insert(db)
                print("Data written sucessfully.\n\(newCustomer)")
            }
        } catch {
            print(error)
        }
    case menuButtons[3]:
        do {
            print("Book title (Required):")
            var titleTyped = readLine()!

            print("Author's name:")
            var authorTyped = readLine()!

            print("How many copies do we own?")
            var totalCopiesTyped = readLine()!

            // Attempt to read and display the data of the books table, ordered by id.
            try dbQueue.write { db in
                var newBook = Books(
                    id: nil, title: titleTyped, author: authorTyped, totalCopies: 6,
                    avaliableCopies: 6)
                try newBook.insert(db)
                print("Data written sucessfully.\n\(newBook)")
            }
        } catch {
            print(error)
        }
    default:
        print("Error writing data to database. Please try again.")
    }
}

// MARK: deleteData()
/// deleteData(tableChosen: String, dbQueue: DatabaseQueue)
///
/// - Parameters
///     - tableChosen: The table selected
///     - dbQueue: The database queue path
///
/// Allows the removal of data from the database.
func deleteData(tableChosen: String, dbQueue: DatabaseQueue) {
    clear()
    print("\(header) DELETE DATA\n\nnil input to cancel operation.")
    // This switch uses the tableChosen to determine which table to delete
    switch tableChosen {

    // DELETE BOOK
    case menuButtons[9]:
        viewData(tableChosen: menuButtons[6], dbQueue: dbQueue)
        print("Please select a book to delete (by ID):")
        let userInput = readLine()

    // DELETE CUSTOMER
    case menuButtons[10]:
        viewData(tableChosen: menuButtons[7], dbQueue: dbQueue)
        print("Please select a record to delete (by ID)")

    default:
        print("Invalid table selected for data removal.")
    }

    // MARK: rentBook()
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

        guard let bookInput = readLine(),
            let selectedBookId = Int(bookInput)
        else {
            print("No such book ID found.")
            return
        }

        do {
            var chosenBook: Books?
            // Check if the book exists and confirm.
            try dbQueue.read { db in
                chosenBook = try Books.fetchOne(db, key: selectedBookId)
                if let chosenBook {
                    print("You have selected \(chosenBook) by \(chosenBook.author)")

                } else {
                    print("This book does not exist.")
                }
            }
            viewData(tableChosen: menuButtons[1], dbQueue: dbQueue)
            print("Please type the name of the customer renting out the book.")

            // the name of the customer renting the book.

            print("Enter customer name:")
            guard let customerName = readLine()
            else {
                print("No such customer with selected name found.")
                return
            }
            var chosenCustomer: Customer?
            try dbQueue.read { db in
                chosenCustomer = try Customer.fetchOne(db, key: customerName)
                if let chosenCustomer {
                    print("\(chosenCustomer) was selected.")
                } else {
                    print("This customer does not exist")
                }
            }
            let currentDate = Date()
            let dueDate = Calendar.current.date(byAdding: .day, value: 7, to: currentDate)!
            try dbQueue.write { db in
                var newRentedBook = RentedBooks(
                    bookId: bookId, customerId: customerId, bookedDate: Date(), dueDate: dueDate)
            }

        } catch {
            print(error)
        }
    }

    @main
    struct SwiftPlayground {
        // MARK: main()
        static func main() {
            print("\n\n\n\n\n")
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

                // MARK: inMainMenu
                // Holds the program inside the main menu screen when not displaying a function.
                var inMainMenu = true

                while inMainMenu == true {
                    clear()
                    print(
                        """
                        \(header) MAIN MENU
                        Welcome to the Onslow College Library admin panel. Please select an operation.
                        \(menuButtons[0]). Rent a book
                        \(menuButtons[1]). Return a book

                        \(menuButtons[2]). Create a customer record done
                        \(menuButtons[3]). Create a book record done

                        \(menuButtons[4]). Edit a customer
                        \(menuButtons[5]). View all customers done

                        \(menuButtons[6]). View all books done
                        \(menuButtons[7]). View avaliable books done
                        \(menuButtons[8]). View unavaliable books done

                        \(menuButtons[9]). Delete a book record
                        \(menuButtons[10]). Delete a customer record
                        \(menuButtons[11]). Shut down system. done
                        """)
                    // MARK: userInput Switch
                    let userInput = readLine()

                    switch userInput {
                    // RENT BOOK
                    case menuButtons[0]:
                        rentBook(dbQueue: dbQueue)

                    // RETURN BOOK
                    case menuButtons[1]:
                        rentBook(dbQueue: dbQueue)

                    // WRITE NEW CUSTOMER
                    case menuButtons[2]:
                        writeData(tableChosen: menuButtons[2], dbQueue: dbQueue)

                    // WRITE NEW BOOK
                    case menuButtons[3]:
                        writeData(tableChosen: menuButtons[3], dbQueue: dbQueue)

                    // VIEW CUSTOMERS (all)
                    case menuButtons[5]:
                        viewData(tableChosen: menuButtons[5], dbQueue: dbQueue)

                    // VIEW BOOKS (all)
                    case menuButtons[6]:
                        viewData(tableChosen: menuButtons[6], dbQueue: dbQueue)

                    // VIEW BOOKS (avaliable)
                    case menuButtons[7]:
                        viewData(tableChosen: menuButtons[7], dbQueue: dbQueue)

                    // VIEW BOOKS (unavaliable)
                    case menuButtons[8]:
                        viewData(tableChosen: menuButtons[8], dbQueue: dbQueue)

                    // Shut down system.
                    case menuButtons[11]:
                        clear()
                        print("Thank you for using the OC Library admin panel.")
                        sleep(1)
                        print("System shutting down...")
                        inMainMenu = false
                    default:
                        clear()
                        print("Please select an operation by typing \n\(menuButtons)")
                    }

                }
            } catch {
                print(error)
            }
        }
    }
}
