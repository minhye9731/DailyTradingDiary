//
//  Realm+Extension.swift
//  DailyTradingDiary
//
//  Created by 강민혜 on 11/5/22.
//

import Foundation
import RealmSwift

extension Realm {
    func writeAsync<T: ThreadConfined>(_ passedObject: T, errorHandler: @escaping ((_ error: Swift.Error) -> Void) = { _ in return }, block: @escaping ((Realm, T?) -> Void)) {
        let objectReference = ThreadSafeReference(to: passedObject)
        let configuration = self.configuration
        DispatchQueue(label: "background").async {
            autoreleasepool {
                do {
                    let realm = try Realm(configuration: configuration)
                    try realm.write {
                        // Resolve within the transaction to ensure you get the latest changes from other threads
                        let object = realm.resolve(objectReference)
                        block(realm, object)
                    }
                } catch {
                    errorHandler(error)
                }
            }
        }
    }
}
