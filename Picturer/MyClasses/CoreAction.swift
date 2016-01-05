//
//  CoreAction.swift
//  JPoint
//
//  Created by Bob Huang on 15/10/1.
//  Copyright © 2015年 4view. All rights reserved.
//

import Foundation
import UIKit
class CoreAction {
    //---打印所有的字体
    static func _printAllFonts(){
        let fontFamilyNames = UIFont.familyNames()
        for familyName in fontFamilyNames {
            print("------------------------------")
            print("Font Family Name = [\(familyName)]")
            let names = UIFont.fontNamesForFamilyName(familyName)
            print("Font Names = [\(names)]")
        }
    }
    //----从网页查找图片
    static func _getImagesFromUrl(__url:String,__block:(NSDictionary)->Void){
        let request = NSMutableURLRequest(URL: NSURL(string:__url)!)
        request.HTTPMethod = "GET"
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, response, erro) -> Void in
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            if erro != nil{
                print("链接失败:",__url,erro)
                __block(NSDictionary(objects: [erro!.code], forKeys: ["recode"]))//--- -1009
                return
            }
            let _str = NSString(data: data!, encoding: NSUTF8StringEncoding)
            let str:String = String(_str)
           let pattern = "(http://+?|https://+?)([^(>|\"|<|'|,|;)]+)(.png|.jpg|.gif)"
            do{
                let _images:NSMutableArray = []
                let regex = try NSRegularExpression(pattern: pattern, options: NSRegularExpressionOptions.CaseInsensitive)
                let res = regex.matchesInString(str, options: NSMatchingOptions(rawValue: 0), range: NSMakeRange(0, str.characters.count))
                var count = res.count
               // print("链接成功:",count)
                while count > 0 {
                    let checkingRes = res[--count]
                    let tempStr = (str as NSString).substringWithRange(checkingRes.range)
                
                    _images.addObject(tempStr)
                    print("图片:",tempStr)
                }
                __block(NSDictionary(objects: [200,_images], forKeys: ["recode","images"]))//--- 200成功
            }catch{
                print(error)
                __block(NSDictionary(objects: [0], forKeys: ["recode"]))//--- -1009
            }
        })
        task.resume()
    }
    //-----当前时间串转换成字符串
    static func _timeStrOfCurrent()->String {
        //let timestamp = NSDateFormatter.localizedStringFromDate(NSDate(), dateStyle: .MediumStyle, timeStyle: .ShortStyle)
        let formatter = NSDateFormatter()
        //formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        formatter.dateFormat = "yyyy-M-dd'T'HH:mm:ss.SSSZZZ"
        formatter.timeZone = NSTimeZone.localTimeZone()
        //let _date:NSDate = formatter.dateFromString(__timeStr)!
        let timestamp = formatter.stringFromDate(NSDate())
        //let timestamp = formatter.stringFromDate(_date)
        //print(_date,__timeStr,timestamp,dateDiff(__timeStr))
        return timestamp
    }
    //-----date转换成字符串
    static func _timeStrFromDate(_date:NSDate)->String {
        //let timestamp = NSDateFormatter.localizedStringFromDate(NSDate(), dateStyle: .MediumStyle, timeStyle: .ShortStyle)
        let formatter = NSDateFormatter()
        //formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        formatter.dateFormat = "yyyy-M-dd'T'HH:mm:ss.SSSZZZ"
        formatter.timeZone = NSTimeZone.localTimeZone()
        //let _date:NSDate = formatter.dateFromString(__timeStr)!
        //let timestamp = formatter.stringFromDate(NSDate())
        let timestamp = formatter.stringFromDate(_date)
        //print(_date,__timeStr,timestamp,dateDiff(__timeStr))
        return timestamp
    }
    //-----返回相距当前时间
    static func _dateDiff(dateStr:String) -> String {
        let f:NSDateFormatter = NSDateFormatter()
        f.timeZone = NSTimeZone.localTimeZone()
        f.dateFormat = "yyyy-M-dd'T'HH:mm:ss.SSSZZZ"
        let now = f.stringFromDate(NSDate())
        let startDate = f.dateFromString(dateStr)
        let endDate = f.dateFromString(now)
        let calendar: NSCalendar = NSCalendar.currentCalendar()
        //let calendarUnits =
        let dateComponents = calendar.components([NSCalendarUnit.WeekOfMonth,NSCalendarUnit.Day,NSCalendarUnit.Hour,NSCalendarUnit.Minute,NSCalendarUnit.Second], fromDate: startDate!, toDate: endDate!, options: NSCalendarOptions.init(rawValue: 0))
        let weeks = abs(dateComponents.weekOfMonth)
        let days = abs(dateComponents.day)
        let hours = abs(dateComponents.hour)
        let min = abs(dateComponents.minute)
        let sec = abs(dateComponents.second)        
        var timeAgo = ""
        if (sec > 0){
            if (sec > 1) {
                timeAgo = "\(sec)秒前"// Seconds Ago"
            } else {
                timeAgo = "\(sec)秒前"// Seconds Ago"
            }
        }
        if (min > 0){
            if (min > 1) {
                timeAgo = "\(min)分钟前"// Minutes Ago"
            } else {
                timeAgo = "\(min)分钟前"// Minute Ago"
            }
        }
        if(hours > 0){
            if (hours > 1) {
                timeAgo = "\(hours)小时前"// Hours Ago"
            } else {
                timeAgo = "\(hours)小时前"// Hour Ago"
            }
        }
        if (days > 0) {
            if (days > 1) {
                timeAgo = "\(days)天前"// Days Ago"
            } else {
                timeAgo = "\(days)天前"// Day Ago"
            }
        }
        if(weeks > 0){
            if (weeks > 1) {
                timeAgo = "\(weeks)周前"// Weeks Ago"
            } else {
                timeAgo = "\(weeks)周前"// Week Ago"
            }
        }
        return timeAgo;
    }
    //－－－－－－－把图片变成灰色
    static func _converImageToGray(__inImage:UIImage)->UIImage{
        let _rect:CGRect = CGRectMake(0, 0, __inImage.size.width, __inImage.size.height)
        let _colorSpace:CGColorSpaceRef = CGColorSpaceCreateDeviceGray()!
        //let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.None.rawValue)
        // Create bitmap content with current image size and grayscale colorspace
        let _context:CGContextRef = CGBitmapContextCreate(nil, Int(__inImage.size.width), Int(__inImage.size.height), 8, 0, _colorSpace,CGImageAlphaInfo.None.rawValue)!
        // Draw image into current context, with specified rectangle
        // using previously defined context (with grayscale colorspace)
        CGContextDrawImage(_context, _rect, __inImage.CGImage)
        // Create bitmap image info from pixel data in current context
        let _imageRef:CGImageRef = CGBitmapContextCreateImage(_context)!
        
        let img:UIImage = UIImage(CGImage: _imageRef)
        
        return img;
    }
    //－－－－获取图片像素alpha值
    static func _getPixelAlphaFromImage(pos: CGPoint,__inImage:UIImage) -> CGFloat {
        let pixelData = CGDataProviderCopyData(CGImageGetDataProvider(__inImage.CGImage))
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        let pixelInfo: Int = ((Int(__inImage.size.width) * Int(pos.y)) + Int(pos.x)) * 4
        //        let r = CGFloat(data[pixelInfo]) / CGFloat(255.0)
        //        let g = CGFloat(data[pixelInfo+1]) / CGFloat(255.0)
        //        let b = CGFloat(data[pixelInfo+2]) / CGFloat(255.0)
        let a = CGFloat(data[pixelInfo+3]) / CGFloat(255.0)
        // print(UIScreen.mainScreen().scale,__inImage.size.width)
        return a
    }
    //------截图
    static func _captureImage(__view:UIView)->UIImage{
        UIGraphicsBeginImageContextWithOptions(__view.frame.size,false, 0.0);
        __view.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let img:UIImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return img;
    }
    //-----获取版本号
    static func _version() -> String {
        let dictionary = NSBundle.mainBundle().infoDictionary!
        let version = dictionary["CFBundleShortVersionString"] as! String
        let build = dictionary["CFBundleVersion"] as! String
        return "\(version) build \(build)"
    }
    //-----保存字典到文件
    static func _saveDictToFile(__dict:NSDictionary,__fileName:String){
        let _paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true) as NSArray
        let _documentDirectory = _paths.objectAtIndex(0) as! NSString
        let _path = _documentDirectory.stringByAppendingPathComponent(__fileName)
        __dict.writeToFile(_path, atomically: false)
    }
    //-----从文件获取字典
    static func _getDictFromFile(__fileName:String)->NSDictionary?{
        let _paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true) as NSArray
        let _documentDirectory = _paths.objectAtIndex(0) as! NSString
        let _path = _documentDirectory.stringByAppendingPathComponent(__fileName)
        if let _dict = NSDictionary(contentsOfFile: _path){
            return _dict
        }else{
            return nil
        }
    }
    //-----保存数组到文件
    static func _saveArrayToFile(__array:NSArray,__fileName:String){
        let _paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true) as NSArray
        let _documentDirectory = _paths.objectAtIndex(0) as! NSString
        let _path = _documentDirectory.stringByAppendingPathComponent(__fileName)
        __array.writeToFile(_path, atomically: false)
    }
    //-----从文件获取数组
    static func _getArrayFromFile(__fileName:String)->NSArray?{
        let _paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true) as NSArray
        let _documentDirectory = _paths.objectAtIndex(0) as! NSString
        let _path = _documentDirectory.stringByAppendingPathComponent(__fileName)
        if let _array = NSArray(contentsOfFile: _path){
            return _array
        }else{
            return nil
        }
    }
    //-----删除文件
    static func _deleteFile(__fileName:String){
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
        let documentsDirectory = paths.objectAtIndex(0) as! NSString
        let path = documentsDirectory.stringByAppendingPathComponent(__fileName)
        let fileManager = NSFileManager.defaultManager()
        do{
            try fileManager.removeItemAtPath(path)
        }catch{
            print(error)
        }
    }
    //----复制默认文件到
    static func _copyDefaultFile(__fileName:String, __toFile:String){
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
        let documentsDirectory = paths.objectAtIndex(0) as! NSString
        let path = documentsDirectory.stringByAppendingPathComponent(__fileName)
        let fileManager = NSFileManager.defaultManager()
        // If it doesn't, copy it from the default file in the Bundle
        if let bundlePath = NSBundle.mainBundle().pathForResource(__fileName, ofType: "plist") {
            let resultDictionary = NSMutableDictionary(contentsOfFile: bundlePath)
            print("Bundle \(__fileName).plist file is --> \(resultDictionary?.description)")
            do{
                try fileManager.copyItemAtPath(bundlePath, toPath: path)
            }catch{
                print(error)
            }
        } else {
            print("\(__fileName).plist not found. Please, make sure it is part of the bundle.")
        }
        
    }
    //----判断文件是否存在于文档文件夹中
    static func _fileExistAtDocument(__fileName:String)->Bool{
        let _paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true) as NSArray
        let _documentDirectory = _paths.objectAtIndex(0) as! NSString
        let _path = _documentDirectory.stringByAppendingPathComponent(__fileName)
        let _fileManager = NSFileManager.defaultManager()
        return _fileManager.fileExistsAtPath(_path)
    }
    //----image转换成可发送字符串
    static func _imageToString(__image:UIImage)->String{
        //let imageData = UIImagePNGRepresentation(UIImage(named: "test.png")!)
        let imageData = UIImageJPEGRepresentation(__image, 0.9)
        var string:String = (imageData?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.EncodingEndLineWithCarriageReturn))!
        string = string.stringByReplacingOccurrencesOfString("+", withString: "%2B")
        return string
    }
    //----image转换成可发送字符串
    static func _imageToString_PNG(__image:UIImage)->String{
        //let imageData = UIImagePNGRepresentation(UIImage(named: "test.png")!)
        let imageData = UIImagePNGRepresentation(__image)
        var string:String = (imageData?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.EncodingEndLineWithCarriageReturn))!
        string = string.stringByReplacingOccurrencesOfString("+", withString: "%2B")
        return string
    }
    //----发送参数到url
    static func _sendToUrl(__postString:String,__url:String,__block:(NSDictionary)->Void){
        //print("sending====",__url,__postString)
        let request = NSMutableURLRequest(URL: NSURL(string:__url)!)
        request.HTTPMethod = "POST"
        request.HTTPBody = __postString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, response, erro) -> Void in
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            if erro != nil{
                print("链接失败:",__url,erro)
                //__block(NSDictionary(objects: [1009], forKeys: ["recode"]))//--- -1009
                __block(NSDictionary(objects: [erro!.code], forKeys: ["recode"]))//--- -1009
                return
            }
            var _str = NSString(data: data!, encoding: NSUTF8StringEncoding)
            
            _str = _str?.stringByReplacingOccurrencesOfString(":null", withString: ":\"\"")
             print("链接成功:",__url,_str)
            
            do{
                let jsonResult = try NSJSONSerialization.JSONObjectWithData((_str?.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true))!, options: NSJSONReadingOptions.MutableContainers)
                __block(jsonResult as! NSDictionary)
            }catch{
                print("failed with url:",__url,"respone:",_str)
                __block(NSDictionary(objects: [0], forKeys: ["recode"]))
            }
        })
        task.resume()
    }
}
