// The Swift Programming Language
// https://docs.swift.org/swift-book

struct Car {
    let brand: String
    let model: String
    let year: Int

    func carDetails() -> String {
        return """
            This \(brand) \(model) was built in \(year).
            """
    }
}

struct BankAccount {
    var owner: String
    var balance: Double

    func description() -> String {
        return """
            \(owner)'s account currently has a balance of $\(balance).
            """
    }
}

struct Rectangle {
    var width: Double
    var height: Double

    func area() -> Double {
        width * height
    }
}

struct Quest {
    let title: String
    let difficulty: Double
    let reward: Double

    func printBadge() -> String {
        return """
            \(title) - Difficulty: \(difficulty). You have earned \(reward) XP.
            """
    }
}

@main
struct SwiftPlayground {
    static func main() {

        // CAR TASK
        print(
            """

            CAR TASK

            """)

        let carsInGarage = [
            Car(brand: "Holden", model: "Mango", year: 2000),
            Car(brand: "Archiecar", model: "6", year: 1954),
        ]

        print(carsInGarage[0].carDetails())
        print(carsInGarage[1].carDetails())

        // BANK ACCOUNT TASK
        print(
            """

            BANK ACCOUNT TASK

            """)

        let bankAccounts = [
            BankAccount(owner: "Archie D", balance: 0.00000),
            BankAccount(owner: "Sam H", balance: 9_999_999_999_999),
        ]
        print(bankAccounts[0].description())
        print(bankAccounts[1].description())

        // RECTANGLE TASK
                print(
            """

            RECTANGLE TASK

            """)

        let rectangle1 = (Rectangle(width: 6, height: 7))
        let rectangle2 = (Rectangle(width: 9, height: 8))

        print(
            """
            The rectangle's areas are:
            \(rectangle1.area())m and \(rectangle2.area())m.
            """)

        if rectangle1.area() > rectangle2.area() {
            print("Rectangle 1 has the larger area.")
        } else {
            print("Rectangle 2 has the larger area.")
        }

        // QUEST TASK
        print(
            """

            QUEST TASK

            """)

        let quests = [
            Quest(title: "Archie Fight", difficulty: 5, reward: 500),
            Quest(title: "Sam Fight", difficulty: 10, reward: 1000),
            Quest(title: "Cohen Fight", difficulty: 15, reward: 1500),
        ]

        // Prints the print badges.
        for quest in quests {
            print(quest.printBadge())
        }
        let hardestQuest = max(quests[0].difficulty, quests[1].difficulty, quests[2].difficulty)
        print("The hardest quest is ___ with a difficulty of \(hardestQuest) ")
    }
}
