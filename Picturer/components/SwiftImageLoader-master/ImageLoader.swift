//
//  ImageLoader.swift
//  extension
//
//  Created by Nate Lyman on 7/5/14.
//  Copyright (c) 2014 NateLyman.com. All rights reserved.
//
import UIKit
import Foundation


class ImageLoader {
    
    let cache = NSCache()
    let _loadingTasks:NSMutableArray? = []
    class var sharedLoader : ImageLoader {
    struct Static {
        static let instance : ImageLoader = ImageLoader()
        }
        return Static.instance
    }
    func _removeTaskOf(urlString: String){
        if _loadingTasks == nil{
            return
        }
        for var i:Int = 0; i < _loadingTasks!.count ; ++i{
            let _task:NSURLSessionDataTask = _loadingTasks!.objectAtIndex(i) as! NSURLSessionDataTask
            if _task.currentRequest?.URL?.absoluteString == urlString{
                _loadingTasks!.removeObjectAtIndex(i)
                _task.cancel()
            }
        }
    }
    func _removeAllTask(){
        if _loadingTasks == nil{
            return
        }
        for var i:Int = 0; i < _loadingTasks!.count ; ++i{
            let _task:NSURLSessionDataTask = _loadingTasks!.objectAtIndex(i) as! NSURLSessionDataTask
            _task.cancel()
        }
        _loadingTasks?.removeAllObjects()
    }
    
    func imageForUrl(urlString: String, completionHandler:(image: UIImage?, url: String) -> ()) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {()in
            let data: NSData? = self.cache.objectForKey(urlString) as? NSData
            if let goodData = data {
                let image = UIImage(data: goodData)
                dispatch_async(dispatch_get_main_queue(), {() in
                    completionHandler(image: image, url: urlString)
                })
                return
            }
            
            let _localData:NSData?=ZYHWebImageChcheCenter.readCacheFromUrl(NSString(string: urlString))
            if let goodData = _localData {
                let image = UIImage(data: goodData)
                dispatch_async(dispatch_get_main_queue(), {() in
                    completionHandler(image: image, url: urlString)
                })
                return
            }
            
            
            
            let downloadTask: NSURLSessionDataTask = NSURLSession.sharedSession().dataTaskWithURL(NSURL(string: urlString)!, completionHandler: {(data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
                if (error != nil) {
                    completionHandler(image: nil, url: urlString)
                    
                    self._removeTaskOf(urlString)
                    return
                }
                
                if data != nil {
                    let image = UIImage(data: data!)
                    self.cache.setObject(data!, forKey: urlString)
                    ZYHWebImageChcheCenter.writeCacheToUrl(NSString(string: urlString), data: data!)
                    dispatch_async(dispatch_get_main_queue(), {() in
                        completionHandler(image: image, url: urlString)
                    })
                    self._removeTaskOf(urlString)
                    
                    return
                }
                
            })
            do{
                 self._loadingTasks?.addObject(downloadTask)
            }catch{
                
            }
            
            downloadTask.resume()
            
        })
        
    }
}