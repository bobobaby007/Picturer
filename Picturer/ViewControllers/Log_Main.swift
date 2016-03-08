//
//  File.swift
//  Picturer
//
//  Created by Bob Huang on 16/1/11.
//  Copyright © 2016年 4view. All rights reserved.
//

import Foundation
import UIKit

protocol Log_Main_delegate:NSObjectProtocol{
    func _logHided()
}



class Log_Main: UIViewController {
    
    var _inited:Bool = false
    
    var _navigateController:UINavigationController?
    
    var _log_home:Log_home?
    weak var _delegate:Log_Main_delegate?
    
    static var _self:Log_Main?
    
    override func viewDidLoad() {
        _init()
        _showLogHome()
    }
    func _init(){
        if _inited{
            return
        }
        Log_Main._self = self
        _navigateController = UINavigationController()
        _navigateController?.navigationBarHidden = true
        self.view.addSubview(_navigateController!.view)
        _inited = true
    }
    func _showLogHome(){
        if _log_home == nil{
            _log_home = Log_home()
        }
        //_navigateController?.addChildViewController(_log_home!)
        _navigateController?.pushViewController(_log_home!, animated: false)
    }
    
    func _hide(){
        if _delegate != nil{
            _delegate?._logHided()
        }
        self.dismissViewControllerAnimated(false) { () -> Void in
            
        }
    }
    
}
