//
//  AlbumListCell.swift
//  Picturers
//
//  Created by Bob Huang on 15/6/18.
//  Copyright (c) 2015年 4view. All rights reserved.
//

import Foundation
import UIKit

class AlbumListCell :  UITableViewCell{
    
    var _imageView:UIImageView?
    var _titleLable:UILabel?
    var _desLable:UILabel?
    var _timeLable:UILabel?
    
    
    
    func setThumbImage(_image:NSString)->Void{
        _imageView=UIImageView(frame: CGRectMake(5, 5, self.bounds.height-10, self.bounds.height-10))
        _imageView?.contentMode=UIViewContentMode.ScaleAspectFill
        _imageView?.layer.cornerRadius=5
        _imageView?.layer.masksToBounds=true
        _imageView?.image=UIImage(named: _image as String)
        self.addSubview(_imageView!)
    }
    
    func setThumbImageByImage(_image:UIImage)->Void{
        _imageView=UIImageView(frame: CGRectMake(5, 5, self.bounds.height-10, self.bounds.height-10))
        _imageView?.contentMode=UIViewContentMode.ScaleAspectFill
        _imageView?.layer.cornerRadius=5
        _imageView?.layer.masksToBounds=true
        _imageView?.image=_image
        self.addSubview(_imageView!)
    }
    func setTitle(_text:NSString)->Void{
        _titleLable=UILabel(frame: CGRectMake(self.bounds.height+10, self.bounds.height/2-20, self.bounds.width-26, 30))
        _titleLable?.text=(_text as String)
        self.addSubview(_titleLable!)
    }
    func setDescription(_text:NSString)->Void{
        _desLable=UILabel(frame: CGRectMake(self.bounds.height+10, self.bounds.height/2, self.bounds.width-26, 30))
        _desLable?.text=(_text as String)
        
        _desLable?.textColor=UIColor(white: 0.5, alpha: 1)
        _desLable?.font=UIFont(name: "Helvetica", size: 12)
         _desLable?.text=_text as String
        self.addSubview(_desLable!)
    }
    func setTime(_text:NSString)->Void{
        _timeLable=UILabel(frame: CGRectMake(self.bounds.width-80, self.bounds.height/2-10, 60, 30))
        _timeLable?.text=(_text as String)
        
        _timeLable?.textColor=UIColor(white: 0.5, alpha: 1)
        _timeLable?.font=UIFont(name: "Helvetica", size: 15)
        
        
         _timeLable?.text=_text as String
        self.addSubview(_timeLable!)
    }

    
    override func awakeFromNib() {
        self.imageView?.layer.cornerRadius=13
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
    //    println("哈哈")
        //super.imageView?.hidden=true
    }
}
