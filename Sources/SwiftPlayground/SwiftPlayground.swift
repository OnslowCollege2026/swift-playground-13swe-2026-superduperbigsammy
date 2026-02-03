// The Swift Programming Language
// https://docs.swift.org/swift-book

@main
struct SwiftPlayground {
let budget:[Double] = 35.00
let lunches = [6.50, 8.00, 5.75, 9.20, 7.10]


    static func main() {
        let lunches = [6.50, 8.00, 5.75, 9.20, 7.10]
        var day_counter:Int = 1
        for costs in lunches{
            print("Day \(day_counter): $\(costs)")
            day_counter += 1
        }
    }

    /// Total Cost Function
    /// 
    /// - Returns the total price of all lunches
    func totalCost(prices: [Double]) -> Double{
        var totalPrice:Double = 0
        for itemCosts in lunches{
            totalPrice = totalPrice + itemCosts
        }
        return totalPrice
    }
    
}
