//
//  Kids+CoreDataClass.swift
//  alefTestProject
//
//  Created by Alibek Ismagulov on 03.08.2023.
//
//

import Foundation
import CoreData


public class Kids: Person {

}

extension Kids {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Kids> {
        return NSFetchRequest<Kids>(entityName: "Kids")
    }

    @NSManaged public var kidAge: Int32
    @NSManaged public var kidName: String?

}
