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
    ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14" , "15"]

enum MenuOption: String {
    case rentBook = "1"
    case returnBook = "2"
    case createCustomer = "3"
    case createBook = "4"
    case editCustomer = "5"
    case editBook = "6"
    case viewAllBooks
}

/// These are used to differentiate between the different tables in easier to understand ways (With no magic String).
/// 0 = books, 1 = customers, 2= rentedBooks
let tableSelection = 
["books", "customers", "rentedbooks"]

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
struct RentedBooks: Codable, FetchableRecord, PersistableRecord, CustomStringConvertible, MutablePersistableRecord {
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
    var description: String {
        return """
            book #\(bookId), was rented by customer #\(customerId) on \(bookedDate). The book is due on \(dueDate).
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
///     - tableChosen: The table that is supposed to be displayed.
///         - tableChosen = menuButtons[0]: The Book table
///         - tableChosen = menuButtons[1]: the Customers table
///     - dbQueue: The database queue for the database
///     - userInput: The selection the user made.
///
/// viewData() is used to display tables from the dbPath
func viewData(tableChosen: String, dbQueue: DatabaseQueue, userInput: String?) {

    // This switch uses the tableCHosen to determine which table to display
    switch tableChosen {
    // BOOKS TABLE
    case tableSelection[0]:
        do {
            try dbQueue.read { db in
                let allBooks = try Book.order(Book.Columns.id).fetchAll(db)

                // Print the description for every book in the table.
                switch userInput{

                    // View all books
                    case menuButtons[5]:
                        for book in allBooks {
                            print(book.description)
                        }

                    // View available books
                    case menuButtons[6]:
                        for book in allBooks {
                            if book.availableCopies > 0 {
                                print(book.description)
                            }
                        }

                    // View unavaliable books
                    case menuButtons[7]:
                        for book in allBooks {
                            if book.availableCopies < 1 {
                                print(book.description)
                            }
                        }
            
            // SEARCH AUTHOR
            case menuButtons[10]:

                    print("Please enter the author's name:")
                    guard let bookAuthor = readLine()
                    else {
                        print("Invalid author given.")
                        return
                    }

                    // Attempt to read and display the data of the books table, ordered by title.
                    try dbQueue.read { db in
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
                            print("There are currently no rented books.")
                            return
                        }
                    }
                    
                
                default:
                    print("Error viewing Book table.")
                    return
                }
                    
            } 
    } catch{
        print(error)
    }

    // CUSTOMERS TABLE
    case tableSelection[1]:
        do {
            switch userInput {
                // SEARCH CUSTOMERS
                case menuButtons[9]:
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
                            print("There are currently no rented books.")
                            return
                        }
                    }

                    // PRINT ALL CUSTOMERS
                    case menuButtons[5]:
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
    case tableSelection[2]:
        do{
            // Show currently rented books
            try dbQueue.read { db in
                let rentedBooks = try RentedBooks.fetchAll(db)

                if rentedBooks.isEmpty {
                    print("There are currently no rented books.")
                    return
                }

                for rentedBook in rentedBooks{
                    print(rentedBook)
                }

            }
        } catch{ print(error)}




    // View rented books

    default:
        print("Error displaying data")
    }
    waitForUser()
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
            guard let nameTyped = readLine()
            else {
                print("Name is required.")
                return
            }

            print("Valid Customer Phone (Required):")
            guard let phoneTyped = readLine()
            else {
                print("Phone number is required")
                return
            }

            print("Customer Email (Optional):")
            guard let emailTyped = readLine()
            else {
                print("No email selected.")
                return
            }

            // Attempt to read and display the data of the books table, ordered by id.
            try dbQueue.write { db in
                let newCustomer = Customer(
                    id: nil, name: nameTyped, phone: phoneTyped, email: emailTyped)
                try newCustomer.insert(db)
                print("Data written sucessfully.\n\(newCustomer)")
            }
        } catch {
            print(error)
        }
    case menuButtons[3]:
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
            if intCopiesTyped > 0 && intCopiesTyped <= 99 {
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
                print("Please enter a valid integer between 0-99 ")
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
    do{
    print("\(header) DELETE DATA\n\nnil input to cancel operation.")
    // This switch uses the tableChosen to determine which table to delete
    switch tableChosen {

    // DELETE BOOK
    case menuButtons[11]:
        // Display the books table
        viewData(tableChosen: tableSelection[0], dbQueue: dbQueue, userInput:menuButtons[6])
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
    case menuButtons[12]:
        // Display the customers table
        viewData(tableChosen: tableSelection[1], dbQueue: dbQueue, userInput:menuButtons[5])
        
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

    }catch{
        print(error)
    }
    waitForUser()
}

// MARK: rentBook()
/// rentBook()
///
/// *This function is used when the admin is renting out a book on behalf of the customer.*
func rentBook(dbQueue: DatabaseQueue) {
    //clear()
    // STarts the loop which repeats if input not valid.

    print("Here are all the books currently available in the library.")
    // Displays all the books.
    viewData(tableChosen: tableSelection[0], dbQueue: dbQueue, userInput:menuButtons[6])

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

        viewData(tableChosen: tableSelection[0], dbQueue: dbQueue, userInput:menuButtons[5])
        print("Please type the name of the customer renting out the book.")

        // the name of the customer renting the book.

        print("Enter customer ID:")
        guard let selectedCustomerID = readLine(),
            let customerId = Int(selectedCustomerID)
        else {
            print("Invalid ID.")
            return
        }

        var chosenCustomer: Customer?
        try dbQueue.read { db in
            chosenCustomer = try Customer.fetchOne(db, key: customerId)
            if let chosenCustomer {
                print("\(chosenCustomer) was selected.")
            } else {
                print("This customer does not exist")
            }
        }

        // currentDate is used to create the date of the booking for the book.
        let currentDate = Date()

        // dueDate calculates a week from the currentDate, which is when the book is due.
        let dueDate = Calendar.current.date(byAdding: .day, value: 7, to: currentDate)!

        var validOrder = false
        try dbQueue.write { db in
            if let copies = chosenBook?.availableCopies,
            copies > 0 {
                validOrder = true
            }
        }
        if validOrder == true {
            try dbQueue.write { db in
                let newRentedBook = RentedBooks(
                    bookId: bookId, customerId: customerId, bookedDate: Date(),
                    dueDate: dueDate)
                print(newRentedBook)

                try newRentedBook.insert(db)
                book.availableCopies = book.availableCopies - 1
            try book.update(db)
                print(
                    """
                    Book rented sucessfully.

                    Your book is due on \(dueDate). a late fee will be issued if failure to return.
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
        case menuButtons[4]:

            // View the customers table
            viewData(tableChosen: tableSelection[1], dbQueue: dbQueue, userInput:menuButtons[5])
            print("Select the ID of the customer you wish to update.")

            guard let chosenCustomerId = readLine()
            else {
                print("Invalid customer ID value provided.")
                return
            }
            let chosenCustomerIdInt = Int(chosenCustomerId)

            print("The values you enter below will be all the updated values for the customer.")
            print("Enter customer's name:")
            guard let newCustomerName = readLine()
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

            print("Enter customer's phone:")
            guard let newCustomerPhone = readLine()
            else {
                print("Invalid value provided")
                return
            }

            try dbQueue.write { db in
                let updatedCustomerDetails = Customer(
                    id: chosenCustomerIdInt, name: newCustomerName, phone: newCustomerPhone,
                    email: newCustomerEmail)
                try updatedCustomerDetails.save(db)
            }

        // UPDATE BOOK RECORD
        case menuButtons[5]:

            // View the books table
            viewData(tableChosen: tableSelection[0], dbQueue: dbQueue, userInput:menuButtons[6])
            print("Select the ID of the book you wish to update.")

            guard let chosenBookId = readLine()
            else {
                print("Invalid book ID value provided.")
                return
            }
            let chosenBookIdInt = Int(chosenBookId)

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
                let updatedBookDetails = Book(id: chosenBookIdInt, title: newBookTitle, author: newBookAuthor, totalCopies: newTotalCopies, availableCopies: newavailableCopies)
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
func returnBook(dbQueue:DatabaseQueue){
    clear()
    print("\(header) RETURN BOOK")

    do{
    viewData(tableChosen: tableSelection[2], dbQueue: dbQueue, userInput:nil)

    // Find out which record to remove from the user
    print("Enter the ID # of the book to be returned.")
    guard let inputtedBookId = readLine(),
    // turn the input into an integer.
    let inputtedBookIdInt = Int(inputtedBookId)
    else{
        print("Error with Book # ID")
        return
    }

    // Find out which customer is aligned with the book record.
    print("Enter the ID # of the customer returning the book.")
    guard let inputtedCustomerId = readLine(),
    // turn the input into an integer.
    let inputtedCustomerIdInt = Int(inputtedCustomerId)
    else{
        print("Error with customer # ID")
        return
    }

    try dbQueue.write {db in
    // Find rented book record
        guard let rentedBook = try RentedBooks
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

        print("""
            Book returned successfully.

            \(book.title) now has \(book.availableCopies) available copies.
            """)
    }
    } catch{
        print(error)
    }
    waitForUser()
}



@main
struct SwiftPlayground {
    // MARK: main()
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

            // MARK: inMainMenu
            // Holds the program inside the main menu screen when not displaying a function.
            var inMainMenu = true

            while inMainMenu == true {
                clear()
                print(
                    """
                    \(header) MAIN MENU
                    Welcome to the Onslow College Library admin panel. Please select an operation using you numberpad.
                    📖 \(menuButtons[0]). Rent a book
                    📖 \(menuButtons[1]). Return a book

                    👥 \(menuButtons[2]). Create a new customer record
                    📖 \(menuButtons[3]). Create a new book record

                    👥 \(menuButtons[4]). Edit a customer
                    📖 \(menuButtons[14]). Edit a book
                    👥 \(menuButtons[5]). View all customers

                    📖 \(menuButtons[6]). View all books
                    📖 \(menuButtons[7]). View available books
                    📖 \(menuButtons[8]). View unavaliable books

                    👥 \(menuButtons[9]). Search for customer (By name)
                    📖 \(menuButtons[10]). Search for book by author

                    📖 \(menuButtons[11]). Delete a book record
                    👥 \(menuButtons[12]). Delete a customer record

                    ⚠️  \(menuButtons[13]). Shut down system ⚠️
                    """)
                let userInput = readLine()

                // MARK: userInput Switch
                // Filters the user's input using the menuButtons as shown before.
                switch userInput {
                // RENT BOOK
                case menuButtons[0]:
                    rentBook(dbQueue: dbQueue)

                // RETURN BOOK
                case menuButtons[1]:
                    returnBook(dbQueue: dbQueue)

                // WRITE NEW CUSTOMER
                case menuButtons[2]:
                    writeData(tableChosen: menuButtons[2], dbQueue: dbQueue)

                // WRITE NEW BOOK
                case menuButtons[3]:
                    writeData(tableChosen: menuButtons[3], dbQueue: dbQueue)

                // EDIT CUSTOMER
                case menuButtons[4]:
                    updateData(tableChosen: menuButtons[4], dbQueue: dbQueue)
                
                // EDIT BOOK
                case menuButtons[14]:
                    updateData(tableChosen: menuButtons[5], dbQueue: dbQueue)

                // VIEW CUSTOMERS (all)
                case menuButtons[5], menuButtons[9]:
                    viewData(tableChosen: tableSelection[1], dbQueue: dbQueue, userInput:userInput)

                // VIEW BOOKS
                case menuButtons[6], menuButtons[7], menuButtons[8], menuButtons[10]:
                    viewData(tableChosen: tableSelection[0], dbQueue: dbQueue, userInput:userInput)

                // DELETE BOOK
                case menuButtons[11]:
                    deleteData(tableChosen: menuButtons[11], dbQueue: dbQueue)

                    // DELETE AUTHOR
                case menuButtons[12]:
                    deleteData(tableChosen: menuButtons[12], dbQueue: dbQueue)

                // Shut down system.
                case menuButtons[13]:
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
                        Please select an operation by typing one of the following integers:
                        \(menuButtons)
                        """)
                }

            }
        } catch {
            print(error)
        }
    }
}
