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
}

func bookSummary(title: String, author: String, pages: Int) -> String {
    return """
        \(title) was written by \(author) and contains \(pages) pages.
        """

    //t2:
    struct Temperature {
        static func toFahrenheit(celsius: Double) -> Double {
            return (celsius*1.8) + 32
        }
        static func toCelsius(fahrenheit: Double) -> Double {
            return (fahrenheit - 32)/1.8
        }
    }

    // t3
    struct Timer {
        var isRunning: Bool
        var seconds: Int

        mutating func start() {
            isRunning = true
            print("isRunning =", isRunning)
        }
        mutating func tick() {
            seconds += 1
            print("seconds =", seconds)
        }

        mutating func reset() {
            seconds = 0
            isRunning = false

            print("isRunning =", isRunning)
            print("seconds =", seconds)
        }
        
        //t4
        struct Cart {
            var itemsCount: Int

        }

    }

    @main
    struct SwiftPlayground {
        static func main() {

            // Book Task
            let book1OpenFunc = Book(title: "Book 1 open func", author: "John Bookwrite", pages: 67)
            print(
                bookSummary(
                    title: book1OpenFunc.title, author: book1OpenFunc.title,
                    pages: book1OpenFunc.pages))

            let book2Method = Book(title: "Book 2 Method", author: "John Bookwrite", pages: 69)
            print(book2Method.summary())

            //Task 2:
            print(Temperature.toFahrenheit(celsius:22))
            print(Temperature.toCelsius(fahrenheit:11))
            print(Temperature.toFahrenheit(celsius:67))

            // Statics are better than instances as you dont need to create a new instance for something simple like this.

            //Task 3
            var timer = Timer(isRunning: false, seconds: 0)
            timer.start()
            timer.tick()
            timer.reset()

            // Task 4
    
        }

    }
}

//tung tung tung
