import RealmSwift

class RealmService {
    var realmManager: RealmManager
    
    init(realmManager: RealmManager = RealmManager()) {
        self.realmManager = realmManager
    }
    
    func getUsers() -> [User] {
        guard let usersRm = realmManager.object(UserRm.self) else { return [] }
        let users = Array(usersRm).compactMap { $0.toDataObject() }
        users.forEach {
            $0.conductCourses = getConductCourses(for: $0)
            $0.studyingСourses = getStudyingСourses(for: $0)
        }
        return users
    }
    
    func getCourses() -> [Course] {
        guard let coursesRm = realmManager.object(CourseRm.self) else { return [] }
        let courses = Array(coursesRm).compactMap { $0.toDataObject() }
        courses.forEach {
            $0.subscribers.forEach {
                $0.conductCourses = getConductCourses(for: $0)
                $0.studyingСourses = getStudyingСourses(for: $0)
            }
        }
        return courses
    }
    
    func getTeachers() -> [Teacher] {
        return getUsers()
            .filter { !$0.conductCourses.isEmpty }
            .map {
                Teacher(
                    id: $0.id,
                    name: $0.name,
                    surname: $0.surname,
                    email: $0.email,
                    conductCourses: $0.conductCourses,
                    studyingСourses: $0.studyingСourses
                )
            }
    }
    
    func getConductCourses(for user: User) -> [Course] {
        let conductCoursesRm = realmManager.object(UserRm.self, forPrimaryKey: user.id)?.conductCourses
        guard let conductCourses = conductCoursesRm else { return [] }
        return Array(conductCourses).compactMap { $0.toDataObject() }
    }
    
    func getStudyingСourses(for user: User) -> [Course] {
        let conductCoursesRm = realmManager.object(UserRm.self, forPrimaryKey: user.id)?.studyingCourses
        guard let conductCourses = conductCoursesRm else { return [] }
        return Array(conductCourses).compactMap { $0.toDataObject() }
    }
    
    func add(user: User) {
        realmManager.add(UserRm().fromData(model: user))
    }
    
    func update(user: User) {
        realmManager.update(UserRm().fromData(model: user), update: .modified)
    }
    
    func delete(user: User) {
        guard
            let userRm = realmManager.object(UserRm.self)?.where({ $0.id == user.id }),
            let user = userRm.first
        else { return }
        realmManager.delete(user)
    }
    
    func add(course: Course) {
        realmManager.update(CourseRm().fromData(model: course), update: .modified)
    }
    
    func update(course: Course) {
        realmManager.update(CourseRm().fromData(model: course), update: .modified)
    }
    
    func delete(course: Course) {
        guard
            let courseRm = realmManager.object(CourseRm.self)?.where({ $0.id == course.id }),
            let course = courseRm.first
        else { return }
        realmManager.delete(course)
    }
}
