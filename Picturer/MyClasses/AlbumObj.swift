//
//  AlbumObj.swift
//  Picturers
//
//  Created by Bob Huang on 15/6/18.
//  Copyright (c) 2015年 4view. All rights reserved.
//

import Foundation

class AlbumObj:AnyObject {
    
    var thumbImage = String()
    var title = String()
    var cover = String()
    var images:NSMutableArray = NSMutableArray(array: [PicObj()])
}
