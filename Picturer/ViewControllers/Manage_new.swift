//
//  Manage_new.swift
//  Picturers
//
//  Created by Bob Huang on 15/6/20.
//  Copyright (c) 2015年 4view. All rights reserved.
//

import Foundation
import UIKit

class Manage_new:UIViewController{
    @IBOutlet weak var _btn_back:UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func clickAction(_btn:UIButton)->Void{
        if _btn == _btn_back{
            self.navigationController?.popViewControllerAnimated(true)
        }
    }

}
