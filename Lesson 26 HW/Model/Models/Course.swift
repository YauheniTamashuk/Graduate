import Foundation

class Course: ListObject {
    var id: UUID
    var name: String
    var subject: String
    var department: String
    var teacher: User?
    var subscribers = [User]()
    
    init(id: UUID, name: String, subject: String, department: String, teacher: User?, subscribers: [User]) {
        self.id = id
        self.name = name
        self.subject = subject
        self.department = department
        self.teacher = teacher
        self.subscribers = subscribers
    }
    
    convenience init() {
        self.init(id: UUID(), name: "", subject: "", department: "", teacher: nil, subscribers: [])
    }
    
    var text: String {
        name
    }
    
    var secondaryText: String {
        "\(subject) - \(department)"
    }
}
