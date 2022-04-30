import Foundation

private enum Constants {
    static let secondaryText = "Courses: %d"
}

class Teacher: ListObject {
    var id: UUID
    var name: String
    var surname: String
    var email: String
    var conductCourses = [Course]()
    var studyingСourses = [Course]()
    
    init(id: UUID, name: String, surname: String, email: String, conductCourses: [Course], studyingСourses: [Course]) {
        self.id = id
        self.name = name
        self.surname = surname
        self.email = email
        self.conductCourses = conductCourses
        self.studyingСourses = studyingСourses
    }
    
    convenience init() {
        self.init(id: UUID(), name: "", surname: "", email: "", conductCourses: [], studyingСourses: [])
    }
    
    var text: String {
        "\(name) \(surname)"
    }
    var secondaryText: String {
        String(format: Constants.secondaryText, conductCourses.count)
    }
}
