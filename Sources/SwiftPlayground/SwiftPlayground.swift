import Foundation

    // MARK: - 1. Rank Struct
    struct Rank: Comparable, CustomStringConvertible {
        let label: String
        let level: Int 

        var description: String {
            return label
        }

        static func < (lhs: Rank, rhs: Rank) -> Bool {
            return lhs.level > rhs.level 
        }

        static func == (lhs: Rank, rhs: Rank) -> Bool {
            return lhs.level == rhs.level
        }

        static func from(amount: Double) -> Rank {
            if amount >= 250 { return Rank(label: "S Tier", level: 5) } // Should be S
            if amount >= 100 { return Rank(label: "A Tier", level: 4) } // Should be A
            if amount >= 50  { return Rank(label: "B Tier", level: 3) } 
            if amount >= 25  { return Rank(label: "C Tier", level: 2) } 
            if amount >= 10  { return Rank(label: "D Tier", level: 1) } 
            return Rank(label: "F Tier", level: 0) // Should be F
        }
    }

    // MARK: - 2. Contribution Struct
    struct Contribution: Equatable {
        let amount: Double
        let rank: Rank

        init(amount: Double) {
            self.amount = amount
            self.rank = Rank.from(amount: amount)
        }

        static func == (lhs: Contribution, rhs: Contribution) -> Bool {
            return lhs.amount == rhs.amount
        }
    }

    // MARK: - 3. Guest Struct
    struct Guest: CustomStringConvertible, Equatable, Comparable {
        let name: String
        let contribution: Contribution

        var description: String {
            return "[\(contribution.rank)] \(name) | $\(contribution.amount)"
        }

        static func == (lhs: Guest, rhs: Guest) -> Bool {
            return lhs.name == rhs.name && lhs.contribution == rhs.contribution
        }

        static func < (lhs: Guest, rhs: Guest) -> Bool {
            if lhs.contribution.rank != rhs.contribution.rank {
                return lhs.contribution.rank < rhs.contribution.rank
            }
            return lhs.name > rhs.name 
        }
    }

    // MARK: - 4. Party Logic
    struct PartyOrganizer {
        var guestList: [Guest] = []

        mutating func addPreMadeGuests() {
            // Pre-made guests to help you test.
            guestList.append(Guest(name: "Rich Richard", contribution: Contribution(amount: 500.0)))
            guestList.append(Guest(name: "Broke Bob", contribution: Contribution(amount: 2.0)))
        }

        func printTierList() {
            print("\n--- BROKEN PARTY TIER LIST ---")
            let sortedList = guestList.sorted(by: <)
            
            for guest in sortedList {
                print(guest)
            }
        }
    }

    @main
    struct SwiftPlayground {
        static func main() {
            var app = PartyOrganizer()
            app.addPreMadeGuests()
            var isRunning = true

            while isRunning {

                var amountInput: Double = 0.0
                var nameInput: String = ""

                while nameInput.count < 1 && nameInput.lowercased() != "done" {
                print("\nEnter Name (or 'done'): ", terminator: "")
                nameInput = readLine()! 
            }
                    if nameInput.lowercased() == "done" {
                    isRunning = false
                    break
                }
                while amountInput < 1 {
                print("Enter Amount: ", terminator: "")
                amountInput = Double(readLine()!) ?? 0
                }

                let amount = amountInput

                let newGuest = Guest(name: nameInput, contribution: Contribution(amount: amount))
                app.guestList.append(newGuest)
                print("Added \(nameInput).")
            }

            app.printTierList()
        }
    }