//
//  Protocols.swift
//  Picturer
//
//  Created by Bob Huang on 15/7/9.
//  Copyright (c) 2015年 4view. All rights reserved.
//

import Foundation

protocol ControllerDelegate:NSObjectProtocol{
    func controllerCanceled(controller:AnyObject,dict:NSMutableDictionary)
    func controllerSaved(controller:AnyObject,dict:NSMutableDictionary)
}

