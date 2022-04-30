import RealmSwift

private enum Constants {
    static let teacher = "teacher"
    static let subscribers = "subscribers"
}

class UserRm: Object {
    @Persisted(primaryKey: true) var id: UUID
    @Persisted var name: String
    @Persisted var surname: String
    @Persisted var email: String
    @Persisted(originProperty: Constants.teacher) var conductCourses: LinkingObjects<CourseRm>
    @Persisted(originProperty: Constants.subscribers) var studyingCourses: LinkingObjects<CourseRm>
    
    func toDataObject() -> User {
        return User(id: id, name: name, surname: surname, email: email)
    }
    
    func fromData(model: User) -> UserRm {
        id = model.id
        name = model.name
        surname = model.surname
        email = model.email
        return self
    }
}
