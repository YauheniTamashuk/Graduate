import RealmSwift

class CourseRm: Object {
    @Persisted(primaryKey: true) var id: UUID
    @Persisted var name: String
    @Persisted var subject: String
    @Persisted var department: String
    @Persisted var teacher: UserRm?
    @Persisted var subscribers: List<UserRm>
    
    func toDataObject() -> Course {
        return Course(
            id: id,
            name: name,
            subject: subject,
            department: department,
            teacher: teacher?.toDataObject(),
            subscribers: subscribers.compactMap { $0.toDataObject() }
        )
    }
    
    func fromData(model: Course) -> CourseRm {
        id = model.id
        name = model.name
        subject = model.subject
        department = model.department
        teacher = UserRm().fromData(model: model.teacher ?? User())
        subscribers.append(objectsIn: model.subscribers.compactMap { UserRm().fromData(model: $0) })
        return self

    }
}
