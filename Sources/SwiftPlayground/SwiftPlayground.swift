// The Swift Programming Language
// https://docs.swift.org/swift-book

@main
struct SwiftPlayground {
    static func main() {
        let numbers = [1, 2, 3, 4, 5]


        let total = numbers.map { number in
            return number * number * number
        }.filter { number in
            return number % 2 == 0
        }.reduce(0) { result, number in
            return result + number
        }
        print(total)


        // task Nalyzing setudent scorews
        let scores = [45, 78, 89, 32, 50, 92, 67, 41, 99, 56]

        let finalScores = scores.map { score in
        return score + 5}
        .filter { score in
        return score >= 50 }
        .reduce(0) {average, score in
        return average + score}

        print(finalScores / scores.count)
    }   
}
