// The Swift Programming Language
// https://docs.swift.org/swift-book
import Foundation

struct Student: Identifiable, Codable {
    var id: Int
    var name: String
    var age: Int
}
struct Course: CustomStringConvertible {
    let id: Int()
    let title: String()
    let courseDescription: String()

    var description: String { "Course \(title) (\(id)):\n\(courseDescription)"}
}

struct Enrolment: Codable {
    let studentId: Int
    let courseId: Int
}

@main
struct SwiftPlayground {
    static func main() {
        let archieee = Student(id: 12, name: "Archie D", age: 17)
        print(archieee)
let enrolledStudent = Enrolment(studentId: 12, courseId: 16)
print(enrolledStudent)
let encodedStudent = try! JSONEncoder().encode(enrolledStudent)
print(encodedStudent)
let decodedStudent = try! JSONDecoder().decode(Student.self, from: encodedStudent)
print(decodedStudent)
    }
}
