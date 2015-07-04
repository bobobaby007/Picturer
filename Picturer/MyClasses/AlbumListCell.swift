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
    var _setuped:Bool=false
    
    override func didMoveToSuperview() {
        setUp()
    }
    
    func setUp(){
        if _setuped {
            return
        }
        _imageView=UIImageView(frame: CGRectMake(5, 5, self.bounds.height-10, self.bounds.height-10))
        _imageView?.contentMode=UIViewContentMode.ScaleAspectFill
        _imageView?.layer.cornerRadius=13
        _imageView?.layer.masksToBounds=true
        self.addSubview(_imageView!)
        
        _titleLable=UILabel(frame: CGRectMake(self.bounds.height+10, self.bounds.height/2-20, self.bounds.width-26, 30))
        self.addSubview(_titleLable!)
        
        
        _desLable=UILabel(frame: CGRectMake(self.bounds.height+10, self.bounds.height/2, self.bounds.width-26, 30))
        _desLable?.textColor=UIColor(white: 0.5, alpha: 1)
        _desLable?.font=UIFont(name: "Helvetica", size: 12)
        self.addSubview(_desLable!)
        
        _timeLable=UILabel(frame: CGRectMake(self.bounds.width-80, self.bounds.height/2-10, 60, 30))
        _timeLable?.textColor=UIColor(white: 0.5, alpha: 1)
        _timeLable?.font=UIFont(name: "Helvetica", size: 15)
         self.addSubview(_timeLable!)
        
        _setuped=true
    }
    
    func setThumbImage(_image:NSString)->Void{
        //setUp()
        _imageView?.image=UIImage(named: _image as String)
    }
    
    func setThumbImageByImage(_image:UIImage)->Void{
        _imageView?.image=_image
    }
    func setTitle(_text:NSString)->Void{
        _titleLable?.text=(_text as String)
    }
    func setDescription(_text:NSString)->Void{
         _desLable?.text=_text as String
    }
    func setTime(_text:NSString)->Void{
         _timeLable?.text=_text as String
    }

    
    override func awakeFromNib() {
        
        //println("awake")
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
    //    println("哈哈")
        //super.imageView?.hidden=true
    }
}
