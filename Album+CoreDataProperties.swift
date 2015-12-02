//
//  Album+CoreDataProperties.swift
//  Picturer
//
//  Created by Bob Huang on 15/12/1.
//  Copyright © 2015年 4view. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Album {

    @NSManaged var id: String?
    @NSManaged var localId: String?
    @NSManaged var tags: String?
    @NSManaged var likeNum: NSNumber?
    @NSManaged var commentNum: NSNumber?
    @NSManaged var imagesNum: NSNumber?
    @NSManaged var permissionType: NSNumber?
    @NSManaged var title: String?
    @NSManaged var des: String?
    @NSManaged var cover: String?
    @NSManaged var permissionPeople: String?
    @NSManaged var other: String?
    @NSManaged var createTime: NSDate?
    @NSManaged var updateTime: NSDate?
    @NSManaged var author: String?

}
