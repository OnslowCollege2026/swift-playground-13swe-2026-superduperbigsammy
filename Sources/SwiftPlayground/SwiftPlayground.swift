// The Swift Programming Language
// https://docs.swift.org/swift-book
// OC Library Admin Panel
// Created on 4-22-2026
// Created by Sam Harford

// Program overview
// OC Library admin panel
// Be able to view, edit, and manage data inside a database.

import Foundation
import GRDB

// MARK: - CONSTANTS
// Constants

// This is the path the database is located at
let dbPath = "Sources/SwiftPlayground/library.db"

// dateFormatter. lets us view the time in NZST
let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.timeZone = TimeZone(identifier: "Pacific/Auckland")
    dateFormatter.dateFormat = "yyyy-dd-MM HH:mm:ss zzz"
    return dateFormatter
}()

let date = dateFormatter.string(from: Date())

// This header goes at the top of each menu page.
let header: String = """
    ----------------------------------------------
    \(date) - ONSLOW COLLEGE LIBRARY - ADMIN PANEL -
    """

/// The buttons for the menus, used to make selections. Edit these to change the menu and all selections.
/// This enum let us create a more maintainable main menu for futureproofing-Edit a number and it doesnt break the code
enum MenuOption: String, CaseIterable {

    case rentBook = "1"
    case returnBook = "2"

    case createCustomer = "3"
    case createBook = "4"

    case editCustomer = "5"
    case editBook = "6"
    case viewCustomers = "7"

    case viewBooks = "8"
    case viewAvailableBooks = "9"
    case viewRentedBooks = "10"

    case searchCustomerByName = "11"
    case searchBookByAuthor = "12"

    case deleteBook = "13"
    case deleteCustomer = "14"

    case shutdown = "15"
}

/// These are used to differentiate between the different tables in easier to understand ways (With no magic String).
/// 0 = books, 1 = customers, 2= rentedBooks
let tableSelection =
    ["books", "customers", "rentedbooks"]

enum TableSelection: String, CaseIterable {
    case books = "books"
    case customers = "customers"
    case rentedBooks = "rentedBooks"
}

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
            [ID: \(id ?? 0)]. - \(name). [Contact: \(email), \(phone)]
            """
    }
}

// MARK: Book Struct
/// A Book is an instance of a book that is inside the library.
struct Book: Identifiable, Codable, FetchableRecord, PersistableRecord, MutablePersistableRecord,
    CustomStringConvertible
{
    static let dataBaseTableName = "Book"

    // A Book's unique identifier.
    let id: Int?

    // The title of the book.
    let title: String

    // The author of the book.
    let author: String

    // The total amount of copies that the library has in it's collection.
    let totalCopies: Int

    // The amount of copies available upon entry
    var availableCopies: Int

    // Syncs the names between swift variables and titles in the database
    enum CodingKeys: String, CodingKey {
        case id = "BookId"
        case title = "Title"
        case author = "Author"
        case totalCopies = "TotalCopies"
        case availableCopies = "AvailableCopies"
    }

    enum Columns {
        static let id = Column("BookId")
        static let author = Column("Author")
    }
    var description: String {
        return """
            [ID: \(id ?? 0)]. - \(title) - \(author). (\(availableCopies) copies remaining.)
            """
    }
}

// MARK: RentedBook Struct
struct RentedBooks: Codable, FetchableRecord, PersistableRecord, CustomStringConvertible,
    MutablePersistableRecord
{
    // bookID and CustomerID Imported from Book and Customer tables.
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

    enum Columns {
        static let bookId = Column("BookId")
        static let customerId = Column("CustomerId")
        static let bookedDate = Column("BookedDate")
        static let dueDate = Column("DueDate")
    }

    var description: String {
        return """
            book #\(bookId), was rented by customer #\(customerId) on \(dateFormatter.string(from:bookedDate)). The book is due on \(dateFormatter.string(from: dueDate)).
            """
    }
}

/// waitForUser()
///
/// Waits for the user's confirmation (Return/Enter) before continuing. This is required to make sure user can see data.
func waitForUser() {
    print("Press return to continue")
    _ = readLine()
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
///     - TableChosen: The table that is supposed to be displayed.
///     - dbQueue: The database queue for the database
///     - userInput: The selection the user made from the main menu (optional)
///
/// viewData() is used to display tables from the dbPath
func viewData(tableChosen: String, dbQueue: DatabaseQueue, userInput: String?) {

    // This switch uses the tableCHosen to determine which table to display
    switch tableChosen {
    // BOOKS TABLE
    case TableSelection.books.rawValue:
        do {
            try dbQueue.read { db in
                let allBooks = try Book.order(Book.Columns.id).fetchAll(db)

                // Print the description for every book in the table.
                switch userInput {

                // View all books
                case MenuOption.viewBooks.rawValue:
                    for book in allBooks {
                        print(book.description)
                    }

                // View available books
                case MenuOption.viewAvailableBooks.rawValue:
                    for book in allBooks {
                        if book.availableCopies > 0 {
                            print(book.description)
                        }
                    }

                // SEARCH AUTHOR
                case MenuOption.searchBookByAuthor.rawValue:

                    print("Please enter the author's name:")
                    guard let bookAuthor = readLine()
                    else {
                        print("Invalid author given.")
                        return
                    }

                    // Attempt to read and display the data of the books table, ordered by title.

                    let allBooksWithAuthor =
                        try Book
                        .filter(Book.Columns.author.like("%\(bookAuthor)%"))
                        .fetchAll(db)
                    // Print the description for every book in the table.
                    print("Here are all the books written by \(bookAuthor)")
                    for book in allBooksWithAuthor {
                        print(book)
                    }
                    if allBooksWithAuthor.isEmpty {
                        print("There are currently no books by this author.")
                    }
                    waitForUser()
                default:
                    print("Error viewing Book table.")
                }

            }
        } catch {
            print(error)
        }

    // CUSTOMERS TABLE
    case TableSelection.customers.rawValue:
        do {
            switch userInput {
            // SEARCH CUSTOMERS
            case MenuOption.searchCustomerByName.rawValue:
                print("Please enter the customer name:")
                guard let customerName = readLine()
                else {
                    print("Invalid name given.")
                    return
                }
                // Attempt to read and display the data of the books table, ordered by title.
                try dbQueue.read { db in
                    let allCustomersWithName =
                        try Customer
                        .filter(Customer.Columns.name.like("%\(customerName)%"))
                        .fetchAll(db)
                    // Print the description for every book in the table.
                    print("Matching results for: \(customerName)")
                    for customer in allCustomersWithName {
                        print(customer)
                    }

                    if allCustomersWithName.isEmpty {
                        print("There are currently no customers with this name.")
                    }
                    waitForUser()
                }

            // PRINT ALL CUSTOMERS
            case MenuOption.viewCustomers.rawValue:
                // Attempt to read and display the data of the customers table, ordered by name.
                try dbQueue.read { db in
                    let allCustomers =
                        try Customer.order(Customer.Columns.name).fetchAll(db)

                    // Print the description for every book in the table.
                    for customer in allCustomers {
                        print(customer)
                    }
                }
            default:
                print("error displaying customers.")
            }
        } catch {
            print(error)
        }

    // RENTEDBOOK TABLE
    case TableSelection.rentedBooks.rawValue:
        print("All currently rented books - ordered by Oldest - > Newest:")
        do {
            try dbQueue.read { db in
                let allRentedBooks = try RentedBooks.order(RentedBooks.Columns.bookedDate).fetchAll(
                    db)

                // Print the description for every book in the table.
                switch userInput {

                // View all rented books
                case MenuOption.viewRentedBooks.rawValue:
                    for book in allRentedBooks {
                        print(book.description)
                    }

                default:
                    print("Unsucsesful viewing of table RentedBooks.")

                }

            }
        } catch { print(error) }

    // View rented books

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

    // Create a Customer instance and persist it to the database.
    case MenuOption.createCustomer.rawValue:
        do {

            var validName: Bool = false
            var validPhone: Bool = false
            var validEmail: Bool = false

            print("Customer Name (Required):")
            guard let nameTyped = readLine()
            else {
                print("Name is Invalid.")
                return
            }

            // Verifies the customer's name is between 1-20 characters
            if !nameTyped.isEmpty && nameTyped.count <= 20 {
                validName = true
            } else {
                print("Name must be between 1-20 Characters")
                waitForUser()
                return
            }
            print("Valid Customer Phone (Required):")
            guard let phoneTyped = readLine()
            else {
                print("Phone number is Invalid")
                return
            }

            let phoneTypedHasNumber = phoneTyped.rangeOfCharacter(from: .decimalDigits) != nil

            // Verify phone is between 4-15 characters long and includes a number (No just strings allowed)
            if phoneTyped.count >= 4 && phoneTyped.count <= 15 && phoneTypedHasNumber {
                validPhone = true
            } else {
                print("Phone must be between 4-15 characters and include digits.")
                waitForUser()
                return
            }
            print("Customer Email (Optional):")
            guard let emailTyped = readLine()
            else {
                print("No email selected.")
                return
            }

            // Validate if the email exists, It is optional - so if it does, verify it includes an @ symbol.
            if !emailTyped.isEmpty {
                if emailTyped.count <= 30 {
                    if emailTyped.contains("@") {
                        validEmail = true
                    } else {
                        print("Email MUST include an @ symbol.")
                        waitForUser()
                        return
                    }
                } else {
                    print("email must be between 1 - 30 characters.")
                    waitForUser()
                    return
                }
            }

            // Ensures tables all filled correclty
            if validName && validPhone && (validEmail || emailTyped.isEmpty) {
                // Attempt to read and display the data of the books table, ordered by id.
                try dbQueue.write { db in
                    let newCustomer = Customer(
                        id: nil, name: nameTyped, phone: phoneTyped, email: emailTyped)
                    try newCustomer.insert(db)
                    print("Data written sucessfully.\n\(newCustomer)")
                }
            } else {
                print(
                    """
                    Please ensure all tables are filled in correctly.

                    Name must be below 20 characters.
                    Phone must be between 4-15 characters
                    Email must be below 30 characters & include a @.
                    """)

            }
        } catch {
            print(error)
        }

    // Create a book instance and persist it to the database.
    case MenuOption.createBook.rawValue:
        do {
            print("New book title: (Required):")
            guard let titleTyped = readLine()
            else {
                print("Title is required.")
                return
            }

            print("New Book Author (Required):")
            guard let authorTyped = readLine()
            else {
                print("Phone number is required")
                return
            }

            print("Total copies in system:")
            guard let copiesTyped = readLine(),
                let intCopiesTyped = Int(copiesTyped)
            else {
                print("Please enter a valid integer between 0-64")
                return
            }
            if intCopiesTyped > 0 && intCopiesTyped <= 99 && titleTyped.count > 0
                && authorTyped.count > 0 && titleTyped.count <= 30 && authorTyped.count <= 30
            {
                // Attempt to read and display the data of the books table, ordered by id.
                try dbQueue.write { db in
                    let newBook = Book(
                        id: nil, title: titleTyped, author: authorTyped,
                        totalCopies: intCopiesTyped,
                        availableCopies: intCopiesTyped)
                    try newBook.insert(db)
                    print("Data written sucessfully.\n\(newBook)")
                }
            } else {
                print(
                    """
                    Please enter a valid copies amount between 0-99.
                    Please ensure all tables are filled correclty.
                    Title and author must be between 1-30 characters.
                    """)
            }
        } catch {
            print(error)
        }
    default:
        print("Error writing data to database. Please try again.")
    }
    waitForUser()
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
    do {
        print("\(header) DELETE DATA\n\nnil input to cancel operation.")
        // This switch uses the tableChosen to determine which table to delete
        switch tableChosen {

        // DELETE BOOK
        case MenuOption.deleteBook.rawValue:
            // Display the books table
            viewData(
                tableChosen: tableSelection[0], dbQueue: dbQueue,
                userInput: MenuOption.viewBooks.rawValue)
            print("Please select a book to delete (by ID):")

            // Ask for inputted ID, If error, show error message.
            guard let selectedBookIdInput = readLine(),
                let selectedBookId = Int(selectedBookIdInput)
            else {
                print("Invalid ID.")
                return
            }

            // Find the book record from the table
            try dbQueue.write { db in
                guard let selectedBook = try Book.fetchOne(db, key: selectedBookId)
                else {
                    // If the book doesn't exist, show an error message.
                    print("A book with this ID doesn't exist.")
                    return
                }

                try selectedBook.delete(db)
                print("Book has been deleted succesfully.")
            }

        // DELETE CUSTOMER
        case MenuOption.deleteCustomer.rawValue:
            // Display the customers table
            viewData(
                tableChosen: tableSelection[1], dbQueue: dbQueue,
                userInput: MenuOption.viewCustomers.rawValue)

            print("Please select a customer to delete (by ID):")

            // Ask for inputted ID, If error, show error message.
            guard let selectedCustomerIdInput = readLine(),
                let selectedCustomerId = Int(selectedCustomerIdInput)
            else {
                print("Invalid ID.")
                return
            }

            // Find the book record from the table
            try dbQueue.write { db in
                guard let selectedBook = try Customer.fetchOne(db, key: selectedCustomerId)
                else {
                    // If the book doesn't exist, show an error message.
                    print("A customer with this ID doesn't exist.")
                    return
                }

                try selectedBook.delete(db)
                print("Customer record has been deleted succesfully.")
            }

        default:
            print("Operation cancelled. (nil input)")
        }

    } catch {
        print(error)
    }
    waitForUser()
}

// MARK: rentBook()
/// rentBook()
///
/// *This function is used when the admin is renting out a book on behalf of the customer.*
func rentBook(dbQueue: DatabaseQueue) {
    clear()
    print("\(header) RENT BOOK\nleave input blank to cancel operation")
    // STarts the loop which repeats if input not valid.

    print("Here are all the books currently available in the library.")
    // Displays all the books.
    viewData(
        tableChosen: tableSelection[0], dbQueue: dbQueue, userInput: MenuOption.viewBooks.rawValue)

    print("Please type the ID number of the book you wish to rent.")
    guard let selectedBookId = readLine(),
        let bookId = Int(selectedBookId)
    else {
        print("No such book ID found.")
        return
    }

    do {
        var chosenBook: Book?
        // Check if the book exists and confirm.
        try dbQueue.read { db in
            chosenBook = try Book.fetchOne(db, key: bookId)
        }

        guard var book = chosenBook else {
            print("This book does not exist.")
            return
        }

        print("You have selected \(book.title) by \(book.author)")

        viewData(
            tableChosen: tableSelection[1], dbQueue: dbQueue,
            userInput: MenuOption.viewCustomers.rawValue)
        print("Please type the name of the customer renting out the book.")

        // the name of the customer renting the book.

        print("Enter customer ID:")
        guard let selectedCustomerID = readLine(),
            let customerId = Int(selectedCustomerID)
        else {
            print("Invalid ID.")
            return
        }

        /// The customer that is selected for renting
        var chosenCustomer: Customer?

        // Finds the customer
        try dbQueue.read { db in
            chosenCustomer = try Customer.fetchOne(db, key: customerId)
        }
        // Ensured the customer exists.
        guard chosenCustomer != nil
        else {
            print("This customer does not exist.")
            return
        }

        // currentDate is used to create the date of the booking for the book. Is a date object, not a string.
        let currentDate = Date()

        // dueDate calculates a week from the currentDate, which is when the book is due.
        guard let dueDate = Calendar.current.date(byAdding: .day, value: 7, to: currentDate)
        else {
            return
        }

        var validOrder = false
        try dbQueue.write { db in
            if let copies = chosenBook?.availableCopies,
                copies > 0
            {
                validOrder = true
            }
        }
        if validOrder == true {
            try dbQueue.write { db in
                let newRentedBook = RentedBooks(
                    bookId: bookId, customerId: customerId, bookedDate: currentDate,
                    dueDate: dueDate)
                print(newRentedBook)

                try newRentedBook.insert(db)
                book.availableCopies = book.availableCopies - 1
                try book.update(db)
                print(
                    """
                    Book rented sucessfully.

                    Your book is due on \(dateFormatter.string(from: dueDate)). a late fee will be issued if failure to return.
                    there are \(book.availableCopies) left of this book.
                    """)
            }
        } else {
            print(
                """
                Sorry. There are no available copies left of \(book.title).

                (\(book))
                """)
        }

    } catch {
        print(error)
    }
    waitForUser()
}

// MARK: updateData()
/// updateData(tableChosen: String, dbQueue: DatabaseQueue)
///
/// - Parameters
///     - tableChosen: The table selected
///     - dbQueue: The database queue path
///
/// Allows the updating of data of specified table within the database.
func updateData(tableChosen: String, dbQueue: DatabaseQueue) {
    do {
        switch tableChosen {

        // UPDATE CUSTOMER RECORD
        case MenuOption.editCustomer.rawValue:

            // View the customers table
            viewData(
                tableChosen: tableSelection[1], dbQueue: dbQueue,
                userInput: MenuOption.viewCustomers.rawValue)
            print("Select the ID of the customer you wish to update.")

            guard let chosenCustomerId = readLine(),
                let chosenCustomerIdInt = Int(chosenCustomerId)
            else {
                print("Invalid customer ID value provided.")
                return
            }

            print("The values you enter below will be all the updated values for the customer.")
            print("Enter customer's name:")
            guard let newCustomerName = readLine()
            else {
                print("Invalid value provided")
                return
            }

            print("Enter customer's phone:")
            guard let newCustomerPhone = readLine()
            else {
                print("Invalid value provided")
                return
            }

            print("Enter customer's email:")
            guard let newCustomerEmail = readLine()
            else {
                print("Invalid value provided")
                return
            }

            // Actually write the data to the database.
            try dbQueue.write { db in
                let updatedCustomerDetails = Customer(
                    id: chosenCustomerIdInt, name: newCustomerName, phone: newCustomerPhone,
                    email: newCustomerEmail)
                // Used save as it allows me to update multiple data points at once.
                try updatedCustomerDetails.save(db)
            }

        // UPDATE BOOK RECORD
        case MenuOption.editBook.rawValue:

            // View the books table
            viewData(
                tableChosen: tableSelection[0], dbQueue: dbQueue,
                userInput: MenuOption.viewBooks.rawValue)
            print("Select the ID of the book you wish to update.")

            guard let chosenBookId = readLine(),
                let chosenBookIdInt = Int(chosenBookId)
            else {
                print("Invalid book ID value provided.")
                return
            }

            print("The values you enter below will be all the updated values for the book.")
            print("Enter book's title:")
            guard let newBookTitle = readLine()
            else {
                print("Invalid value provided")
                return
            }

            print("Enter book's Author:")
            guard let newBookAuthor = readLine()
            else {
                print("Invalid value provided")
                return
            }

            print("How many total copies does the library own?:")
            guard let newTotalCopiesTyped = readLine(),
                let newTotalCopies = Int(newTotalCopiesTyped)
            else {
                print("Invalid value provided")
                return
            }
            print("How many total copies are avalaible right now?:")
            guard let newavailableCopiesTyped = readLine(),
                let newavailableCopies = Int(newavailableCopiesTyped)
            else {
                print("Invalid value provided")
                return
            }

            try dbQueue.write { db in
                let updatedBookDetails = Book(
                    id: chosenBookIdInt, title: newBookTitle, author: newBookAuthor,
                    totalCopies: newTotalCopies, availableCopies: newavailableCopies)
                try updatedBookDetails.save(db)
            }

        default:
            print("Invalid table selected for updating of data.")
        }
    } catch { print(error) }
    waitForUser()
}

// MARK: returnBook()
/// updateData(dbQueue: DatabaseQueue)
///
/// - Parameters
///     - dbQueue: The database queue path
///
/// Allows the user to return a book. Deletes the data from RentedBooks and increases available copies by 1
func returnBook(dbQueue: DatabaseQueue) {
    clear()
    print("\(header) RETURN BOOK")

    do {
        viewData(tableChosen: tableSelection[2], dbQueue: dbQueue, userInput: nil)

        // Find out which record to remove from the user
        print("Enter the ID # of the book to be returned.")
        guard let inputtedBookId = readLine(),
            // turn the input into an integer.
            let inputtedBookIdInt = Int(inputtedBookId)
        else {
            print("Error with Book # ID")
            return
        }

        // Find out which customer is aligned with the book record.
        print("Enter the ID # of the customer returning the book.")
        guard let inputtedCustomerId = readLine(),
            // turn the input into an integer.
            let inputtedCustomerIdInt = Int(inputtedCustomerId)
        else {
            print("Error with customer # ID")
            return
        }

        try dbQueue.write { db in
            // Find rented book record
            guard
                let rentedBook =
                    try RentedBooks
                    .filter(Column("BookId") == inputtedBookIdInt)
                    .filter(Column("CustomerId") == inputtedCustomerIdInt)
                    .fetchOne(db)
            else {
                print("No matching rented book record found.")
                return
            }

            // Find actual book
            guard var book = try Book.fetchOne(db, key: inputtedBookIdInt)
            else {
                print("Book doesnt exist.")
                return
            }
            print("\(book.title) is being returned.")
            // Remove rented record
            try rentedBook.delete(db)

            // add 1 to available copies
            book.availableCopies += 1
            try book.update(db)

            print(
                """
                Book returned successfully.

                \(book.title) now has \(book.availableCopies) available copies.
                """)
        }
    } catch {
        print(error)
    }
    waitForUser()
}

@main
struct SwiftPlayground {
    // MARK: main()
    static func main() {

        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "Pacific/Auckland")
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .medium
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
            } catch { print(error) }

            // Clear the terminal of the database schema, Comment this out for debugging.
            clear()

            // MARK: inMainMenu
            // Holds the program inside the main menu screen when not displaying a function.
            var inMainMenu = true

            while inMainMenu == true {

                print(
                    """
                    \(header) MAIN MENU
                    Welcome to the Onslow College Library admin panel. Please select an operation using you numberpad.
                    📖 \(MenuOption.rentBook.rawValue). Rent a book
                    📖 \(MenuOption.returnBook.rawValue). Return a book

                    👥 \(MenuOption.createCustomer.rawValue). Create a new customer record
                    📖 \(MenuOption.createBook.rawValue). Create a new book record

                    👥 \(MenuOption.editCustomer.rawValue). Edit a customer
                    📖 \(MenuOption.editBook.rawValue). Edit a book
                    👥 \(MenuOption.viewCustomers.rawValue). View all customers

                    📖 \(MenuOption.viewBooks.rawValue). View all books
                    📖 \(MenuOption.viewAvailableBooks.rawValue). View avaliable books
                    📖 \(MenuOption.viewRentedBooks.rawValue). View all currently rented out books

                    👥 \(MenuOption.searchCustomerByName.rawValue). Search for customer by name
                    📖 \(MenuOption.searchBookByAuthor.rawValue). Search for book by author

                    📖 \(MenuOption.deleteBook.rawValue). Delete a book record
                    👥 \(MenuOption.deleteCustomer.rawValue). Delete a customer record

                    ⚠️  \(MenuOption.shutdown.rawValue). Shut down system  ⚠️
                    """)

                // checks user input with MenuOption
                // If it fails, send error message and request for new userInput
                guard let userInput = readLine(),
                // returns nil is menuOption doesnt exist.
                    let option = MenuOption(rawValue: userInput)
                else {
                    clear()
                    print(
                        """
                        -----
                        Please select an operation by typing a valid integer.
                        """)
                    continue
                }

                // MARK: userInput Switch
                // Filters the user's input using the menunButtons as shown before.
                switch option {
                // RENT BOOK
                case .rentBook:
                    rentBook(dbQueue: dbQueue)

                // RETURN BOOK
                case .returnBook:
                    returnBook(dbQueue: dbQueue)

                // WRITE NEW CUSTOMER
                case .createCustomer:
                    writeData(tableChosen: MenuOption.createCustomer.rawValue, dbQueue: dbQueue)

                // WRITE NEW BOOK
                case .createBook:
                    writeData(tableChosen: MenuOption.createBook.rawValue, dbQueue: dbQueue)

                // EDIT CUSTOMER
                case .editCustomer:
                    updateData(tableChosen: MenuOption.editCustomer.rawValue, dbQueue: dbQueue)

                // EDIT BOOK
                case .editBook:
                    updateData(tableChosen: MenuOption.editBook.rawValue, dbQueue: dbQueue)

                // VIEW CUSTOMERS (all, and search)
                case .viewCustomers, .searchCustomerByName:
                    viewData(
                        tableChosen: TableSelection.customers.rawValue, dbQueue: dbQueue,
                        userInput: userInput)
                    waitForUser()

                // VIEW BOOKS - All, Avaliable, and Search
                case .viewBooks, .viewAvailableBooks, .searchBookByAuthor:
                    viewData(
                        tableChosen: TableSelection.books.rawValue, dbQueue: dbQueue,
                        userInput: userInput)
                    waitForUser()

                // VIEW RENTEDBOOKS
                case .viewRentedBooks:
                    viewData(
                        tableChosen: TableSelection.rentedBooks.rawValue, dbQueue: dbQueue,
                        userInput: userInput)
                    // Wiats here in case of future upgrades, can display table without waiting.
                    waitForUser()

                // DELETE BOOK
                case .deleteBook:
                    deleteData(tableChosen: MenuOption.deleteBook.rawValue, dbQueue: dbQueue)

                // DELETE AUTHOR
                case .deleteCustomer:
                    deleteData(tableChosen: MenuOption.deleteCustomer.rawValue, dbQueue: dbQueue)

                // Shut down system.
                case .shutdown:
                    clear()
                    print(
                        """
                        Thank you for using the OC Library admin panel.

                        System shutting down...
                        See you later!
                        """)
                    inMainMenu = false
                default:
                    clear()

                    print(
                        """
                        -----
                        Please select an operation by typing a valid integer.
                        """)
                }

            }
        } catch {
            print(error)
        }
    }
}
