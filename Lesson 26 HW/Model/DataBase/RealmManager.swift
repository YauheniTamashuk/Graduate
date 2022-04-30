import RealmSwift

class RealmManager {
    private func getRealm() -> Realm? {
        do { return try Realm() } catch { return nil }
    }
    
    func object<T: Object, KeyType>(_ type: T.Type, forPrimaryKey: KeyType) -> T? {
        guard let realm = getRealm() else { return nil }
        return realm.object(ofType: type, forPrimaryKey: forPrimaryKey)
    }
    
    func object<T: Object>(_ type: T.Type) -> Results<T>? {
        guard let realm = getRealm() else { return nil }
        return realm.objects(type)
    }
    
    func add(_ object: Object) {
        guard let realm = getRealm() else { return }
        try? realm.write {
            realm.add(object)
        }
    }
    
    func update(_ object: Object, update: Realm.UpdatePolicy) {
        guard let realm = getRealm() else { return }
        try? realm.write {
            realm.add(object, update: update)
        }
    }
    
    func delete(_ object: Object) {
        guard let realm = getRealm() else { return }
        try? realm.write {
            realm.delete(object)
        }
    }
}
