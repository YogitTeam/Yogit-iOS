//
//  RealmManager.swift
//  Yogit
//
//  Created by Junseo Park on 2023/04/16.
//

import Foundation
import RealmSwift

protocol DataBase {
    func read<T: Object>(_ object: T.Type) -> Results<T>
    func write<T: Object>(_ object: T)
    func delete<T: Object>(_ object: T)
    func deleteAll<T: Object>(_ object: T.Type)
    func sort<T: Object>(_ object: T.Type, by keyPath: String, ascending: Bool) -> Results<T>
}

final class RealmManager: DataBase {

    static let shared = RealmManager()

    private let database: Realm

    private init() {
        self.database = try! Realm()
    }

    func getLocationOfDefaultRealm() {
        print("Realm is located at:", database.configuration.fileURL!)
    }

    func read<T: Object>(_ object: T.Type) -> Results<T> {
        print("RealmDB Read Success")
        return database.objects(object)
    }

    func write<T: Object>(_ object: T) {
        do {
            try database.write {
                database.add(object, update: .modified)
                print("RealmDB Write Success")
            }
        } catch let error {
            print(error)
        }
    }

    func update<T: Object>(_ object: T, completion: @escaping ((T) -> ())) {
        do {
            try database.write {
                completion(object)
                print("RealmDB Update Success")
            }
        } catch let error {
            print(error)
        }
    }
    
    func delete<T: Object>(_ object: T) {
        do {
            try database.write {
                database.delete(object)
                print("RealmDB Delete Success")
            }

        } catch let error {
            print(error)
        }
    }

    func deleteAll<T: Object>(_ object: T.Type) {
        do {
            let objectsToDelete = database.objects(object) // inherit object
            try database.write {
                database.delete(objectsToDelete)
                print("RealmDB Delete all Success")
            }

        } catch let error {
            print(error)
        }
    }

    func sort<T: Object>(_ object: T.Type, by keyPath: String, ascending: Bool = true) -> Results<T> {
        return database.objects(object).sorted(byKeyPath: keyPath, ascending: ascending)
    }
}
