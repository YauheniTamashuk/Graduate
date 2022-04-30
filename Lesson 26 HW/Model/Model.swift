import Foundation

class Model {
    private let realmService = RealmService()
    private let type: DataType
    var data = [ListObject]()
    
    init(type: DataType) {
        self.type = type
        update()
    }
    
    func update() {
        switch type {
        case .users:
            data = realmService.getUsers()
        case .courses:
            data = realmService.getCourses()
        case .teachers:
            data = realmService.getTeachers()
        }
    }
    
    func deleteObject(_ object: ListObject) {
        switch type {
        case .users:
            guard let user = object as? User else { break }
            realmService.delete(user: user)
            data = realmService.getUsers()
        case .courses:
            guard let course = object as? Course else { break }
            realmService.delete(course: course)
            data = realmService.getCourses()
        case .teachers:
            break
        }
    }
    
    func addObject(_ object: ListObject) {
        switch type {
        case .users:
            guard let user = object as? User else { break }
            realmService.add(user: user)
            data = realmService.getUsers()
        case .courses:
            guard let course = object as? Course else { break }
            realmService.add(course: course)
            data = realmService.getCourses()
        case .teachers:
            break
        }
    }
    
    func updateObject(_ object: ListObject) {
        switch type {
        case .users:
            guard let user = object as? User else { break }
            realmService.update(user: user)
            data = realmService.getUsers()
        case .courses:
            guard let course = object as? Course else { break }
            realmService.update(course: course)
            data = realmService.getCourses()
        case .teachers:
            break
        }
    }
}
