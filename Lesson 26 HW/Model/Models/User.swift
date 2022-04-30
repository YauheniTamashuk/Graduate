import Foundation

class User: ListObject {

    var id: UUID
    var name: String
    var surname: String
    var email: String
    var conductCourses = [Course]()
    var studyingСourses = [Course]()
    
    init(id: UUID, name: String, surname: String, email: String) {
        self.id = id
        self.name = name
        self.surname = surname
        self.email = email
    }
    
    convenience init() {
        self.init(id: UUID(), name: "", surname: "", email: "")
    }
    
    var text: String {
        "\(name) \(surname)"
    }
    
    var secondaryText: String {
        email
    }
}
