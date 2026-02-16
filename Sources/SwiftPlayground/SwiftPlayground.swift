// The Swift Programming Language
// https://docs.swift.org/swift-book

@main
struct SwiftPlayground {
    static func main() {
        
        // Task 1: Numbers
        let numbers:[Int] = [7, 14, 21, 28, 35]

        // Add all the numbers together
        let total = numbers.reduce(0) { result, numberInString in
            return result + numberInString
        }
        print(total)



        // Task 2: Strings
        // The array with all the possible words
        let words:[String] = ["apple", "banana", "grape", "strawberry", "kiwi"]
        
        // Finds the longest word. longest = current result, word = current point in the string
        let longestWord = words.reduce("") {
            longest, word in
            // if the selected string is longer than current result, return selected string
            if word.count > longest.count {
                return word
            }
            else{ return longest}
        }

        // prints resu.t
        print(longestWord)


        // task: analyzing setudent scorews
        let scores:[Int] = [45, 78, 89, 32, 50, 92, 67, 41, 99, 56]

        let finalScores = scores.map { score in
        // Adds 5 to every score 
        return score + 5
        }
        .filter {score in
        // Only keeps scores >= 50
        return score > 50}
        .reduce(0){score, number in
        // Adds all the scores together
        return score + number
        }


        print(finalScores/scores.count)
    }
}
