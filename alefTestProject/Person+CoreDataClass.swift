//
//  Person+CoreDataClass.swift
//  alefTestProject
//
//  Created by Alibek Ismagulov on 03.08.2023.
//
//

import Foundation
import CoreData


public class Person: NSManagedObject {

}

extension Person {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Person> {
        return NSFetchRequest<Person>(entityName: "Person")
    }

    @NSManaged public var age: Int32
    @NSManaged public var name: String?
    @NSManaged public var kids: NSSet?

}

// MARK: Generated accessors for kids
extension Person {

    @objc(addKidsObject:)
    @NSManaged public func addToKids(_ value: Kids)

    @objc(removeKidsObject:)
    @NSManaged public func removeFromKids(_ value: Kids)

    @objc(addKids:)
    @NSManaged public func addToKids(_ values: NSSet)

    @objc(removeKids:)
    @NSManaged public func removeFromKids(_ values: NSSet)

}

extension Person : Identifiable {

}
