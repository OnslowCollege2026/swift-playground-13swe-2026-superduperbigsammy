// The Swift Programming Language
// https://docs.swift.org/swift-book

@main
struct SwiftPlayground {
    static func main() {
        let list = [3, 7, 8, 18]

        let addedAll = list.reduce(0) { $0 + $1 }  // equals 36
        print(addedAll)

        let oddNum = list.filter { $0 % 2 != 0 }
        print(oddNum)

        let highestNum = list.reduce(0){Swift.max($0,$1)}
        print(highestNum)

        let under15 = list.filter{$0 - 15 <= 0}
        print(under15)

        let nearestTen = list.map {$0 + ($0-10)}
        print(nearestTen)

    }

}

