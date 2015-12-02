//
//  CoreDataLite.swift
//  Picturer
//
//  Created by Bob Huang on 15/11/30.
//  Copyright © 2015年 4view. All rights reserved.
//

//-----

import Foundation
import CoreData

class CoreDataLite: NSObject {
    
    static func _getAlbumList()->[Album]{
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = delegate.managedObjectContext
        let request = NSFetchRequest(entityName: "Album")
        do {
            let entitys = try context!.executeFetchRequest(request) as! [Album]
            return entitys
            } catch {
            //fatalError("Failed to fetch employees: \(error)")
            return[]
        }
    }
    static func _newAlum()->Album{
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = delegate.managedObjectContext
        let entity = NSEntityDescription.insertNewObjectForEntityForName("Album", inManagedObjectContext: context!) as! Album
        return entity
    }
    static func _getAlbumOfId(__id:String)->Album?{
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = delegate.managedObjectContext
        
        
        let request = NSFetchRequest(entityName: "Album")
        
       // print(request)
        //request.predicate = NSPredicate(format: "id=%@", __id)
        do {
            let entitys = try context!.executeFetchRequest(request) as! [Album]
            if entitys.count < 1{
                return nil
            }
            return entitys[0]
        } catch {
            //fatalError("Failed to fetch employees: \(error)")
            return nil
        }
    }
    static func _getAlbumOfLocalId(__id:String)->Album?{
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = delegate.managedObjectContext
        let request = NSFetchRequest(entityName: "Album")
        request.predicate = NSPredicate(format: "id=%@", __id)
        do {
            let entitys = try context!.executeFetchRequest(request) as! [Album]
            if entitys.count < 1{
                return nil
            }
            return entitys[0]
        } catch {
            //fatalError("Failed to fetch employees: \(error)")
            return nil
        }
    }
    static func _getImageOfId(__id:String)->Image?{
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = delegate.managedObjectContext
        let request = NSFetchRequest(entityName: "Image")
        request.predicate = NSPredicate(format: "id=%@", __id)
        do {
            let entitys = try context!.executeFetchRequest(request) as! [Image]
            if entitys.count < 1{
                return nil
            }
            return entitys[0]
        } catch {
            //fatalError("Failed to fetch employees: \(error)")
            return nil
        }
    }
    static func _newImage()->Image{
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = delegate.managedObjectContext
        let entity = NSEntityDescription.insertNewObjectForEntityForName("Image", inManagedObjectContext: context!) as! Image
        return entity
    }
    static func _getImageOfLocalId(__id:String)->Image?{
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = delegate.managedObjectContext
        let request = NSFetchRequest(entityName: "Image")
        request.predicate = NSPredicate(format: "localId=%@", __id)
        do {
            let entitys = try context!.executeFetchRequest(request) as! [Image]
            if entitys.count < 1{
                return nil
            }
            return entitys[0]
        } catch {
            //fatalError("Failed to fetch employees: \(error)")
            return nil
        }
    }
    static func _getImageOfAlbumId(__id:String)->Image?{
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = delegate.managedObjectContext
        let request = NSFetchRequest(entityName: "Image")
        request.predicate = NSPredicate(format: "albumId=%@", __id)
        do {
            let entitys = try context!.executeFetchRequest(request) as! [Image]
            return entitys[0]
        } catch {
            //fatalError("Failed to fetch employees: \(error)")
            return nil
        }
    }
    
    static func _getImageOfAlbumLocalId(__id:String)->Image?{
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = delegate.managedObjectContext
        let request = NSFetchRequest(entityName: "Image")
        request.predicate = NSPredicate(format: "albumLocalId=%@", __id)
        do {
            let entitys = try context!.executeFetchRequest(request) as! [Image]
            return entitys[0]
        } catch {
            //fatalError("Failed to fetch employees: \(error)")
            return nil
        }
    }
    
    static func _update(){
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = delegate.managedObjectContext
        do{
            try context?.save()
            
        }catch{
            fatalError("Failure to save context: \(error)")
        }
    }
}

//-------set your classes here

