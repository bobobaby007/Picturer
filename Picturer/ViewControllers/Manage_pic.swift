//
//  Manage_pic.swift
//  Picturers
//
//  Created by Bob Huang on 15/6/19.
//  Copyright (c) 2015年 4view. All rights reserved.
//

import Foundation
import UIKit

class Manage_pic: UIViewController{
    
    @IBOutlet weak var _btn_back:UIButton?
    @IBOutlet weak var _imgView:UIImageView?

    var _imgPath:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _imgView!.image=UIImage(named: _imgPath!)
    }
    
    @IBAction func clickAction(_btn:UIButton)->Void{
        if _btn == _btn_back{
            self.navigationController?.popViewControllerAnimated(true)
        }
    }    
    
    func _setImage(_img:String){
        
        _imgPath=_img
       
    }
    
}