// The Swift Programming Language
// https://docs.swift.org/swift-book

        struct Book {
            let title: String
            let author: String
            let pages: Int

            func summary() -> String {
                    return """
                    \(title) was written by \(author) and contains \(pages) pages.
                    """
            }


        func bookSummary(for: Book,) -> String {
            return "\(title) was written by \(author) and contains \(pages) pages."
        }
@main
struct SwiftPlayground {
    static func main() {



        let book1OpenFunc = Book(title: "Book 1 open func", author: "John Bookwrite", pages:67)
        print(bookSummary(book1OpenFunc))

        let book2Method = Book(title: "Book 2 Method", author: "John Bookwrite", pages:69)
        print(book2Method.summary())


        }

    }
}

//tung tung tung 