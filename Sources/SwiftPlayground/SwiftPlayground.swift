// The Swift Programming Language
// https://docs.swift.org/swift-book

// THe struct that defines all the student's variables.
struct Student {
    let id: Int
    var name: String
    var age: Int
    let nsn: Int
    var email: String

    func summary() -> String {
        return """
            ID: \(id)
            Name: \(name)
            Age: \(age)
            NSN: \(nsn)
            Email: \(email)
            """
    }
}

@main
struct SwiftPlayground {
    static func main() {
        // Creates student instance of sam
        let students = [
            Student(
                id: 22791, name: "Sam", age: 17, nsn: 987_654_321,
                email: "sam.harford@student.onslow.school.nz"),
            Student(
                id: 67, name: "Archie", age: 16, nsn: 12_345_678,
                email: " archie.domaneschi@student.onslow.school.nz"),
            Student(
                id: 2, name: "Cohen", age: 16, nsn: 1_300_000,
                email: "cohen.budden@student.onslow.school.nz"),
            Student(
                id: 12, name: "Lenny", age: 17, nsn: 067,
                email: "lenny.truman@student.onslow.school.nz"),
            Student(
                id: 22943, name: "John", age: 17, nsn: 9_472_871_842,
                email: "john.quimpo@student.onslow.school.nz"),
        ]

        let studentInTenYears = students.map({ Student in
        print("\(Student.name) will be \(Student.age + 10) year old in 10 years.") })
        
        for student in students{
            print("In tean years, \(student.name) will be \(student.age + 10)")
        }
    }
}
