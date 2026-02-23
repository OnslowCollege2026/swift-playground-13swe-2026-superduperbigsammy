// The Swift Programming Language
// https://docs.swift.org/swift-book

        struct Book {
            let title: String
            let author: String
            let pages: Int

            func bookSummary() -> String {
                    return """
                    \(title) was written by \(author) and contains \(pages) pages.
                    """
            }

@main
struct SwiftPlayground {
    static func main() {

        bookSummary(title:author:pages:) -> String {
            print("\(Book.title) was written by \(Book.author) and contains \(Book.pages) pages.")
        }


        let book1OpenFunc = Book(title: "Book 1 open func", author: "John Bookwrite", pages:67)
        bookSummary(book1OpenFunc)
        let book2Method = Book(title: "Book 2 Method", author: "John Bookwrite", pages:69)
        book1OpenFunc.bookSummary()
        }

    }
}

//tung tung tung 