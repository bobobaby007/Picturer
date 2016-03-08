//
//  AlbumListCell.swift
//  Picturers
//
//  Created by Bob Huang on 15/6/18.
//  Copyright (c) 2015年 4view. All rights reserved.
//

import Foundation
import UIKit
import AssetsLibrary

class AlbumListCell :  UITableViewCell{
    
    var _image:PicView?
    var _titleLable:UILabel?
    var _desLable:UILabel?
    var _timeLable:UILabel?
    var _setuped:Bool=false
    var _arrowV:UIImageView?
    var _mySize:CGSize?
    func setUp(__size:CGSize){
        if _setuped {
            return
        }
        _mySize = __size
       // _imageView=UIImageView(frame: CGRectMake(10, 5, self.bounds.height-10, self.bounds.height-10))
        _image=PicView(frame: CGRectMake(10, 8, 75, 75))
        _image?._isThumb = true
        _image?._scaleType = PicView._ScaleType_Full
        //_image!._imgView?.contentMode=UIViewContentMode.ScaleAspectFill
//        _image!._imgView?.layer.cornerRadius=5
//        _image!._imgView?.layer.masksToBounds=true
        
        _image?.layer.cornerRadius = 5
        _image?.layer.masksToBounds=true
        
        _image?.userInteractionEnabled = false
        
        self.addSubview(_image!)
        
        //_titleLable=UILabel(frame: CGRectMake(self.bounds.height+10, self.bounds.height/2-22, self.bounds.width-26, 30))
        _titleLable=UILabel(frame: CGRectMake(100, 24, _mySize!.width-100-61, 20))
        _titleLable?.textAlignment = NSTextAlignment.Left
        _titleLable?.textColor = Config._color_black_title
        
        _titleLable?.font = Config._font_cell_title
        
        
        //_titleLable?.font = UIFont(name: "Heiti SC Medium", size: 17)
        
        self.addSubview(_titleLable!)
        
        //_desLable=UILabel(frame: CGRectMake(self.bounds.height+10, self.bounds.height/2-2, self.bounds.width-26, 30))
        _desLable=UILabel(frame: CGRectMake(100, 51, _mySize!.width-100-61, 14))
        _desLable?.textAlignment = NSTextAlignment.Left
        _desLable?.textColor=Config._color_gray_subTitle
        _desLable?.font=Config._font_cell_subTitle
        self.addSubview(_desLable!)
        
        _timeLable=UILabel(frame: CGRectMake(_mySize!.width-14-50, 27.5, 50, 12))
        _timeLable?.textAlignment = NSTextAlignment.Right
        _timeLable?.textColor=Config._color_gray_time
        _timeLable?.font=Config._font_cell_time
        
        _arrowV = UIImageView(image: UIImage(named: "list_arrow.png"))
        _arrowV?.frame = CGRect(x: _mySize!.width-21.5, y: 51, width: 7.5, height: 12.72)
        self.addSubview(_arrowV!)
        self.addSubview(_timeLable!)
        _setuped=true
        //print(self.bounds)
    }
    
    func _changeToNew()->Void{
        _setPic(NSDictionary(objects: ["newAlbum.png","file"], forKeys: ["url","type"]))
        _arrowV?.hidden=true
        _timeLable?.hidden=true
        _titleLable?.text="开始，"
        _desLable?.frame = CGRectMake(100, 45, self.bounds.width-100-61, 14)
        _desLable?.text="创建一个新图册"
        _desLable?.textColor=UIColor(white: 0, alpha: 1)
        _desLable?.font=UIFont(name: "Helvetica", size: 17)
    }
    func _changeToNormal()->Void{
        _desLable?.frame = CGRectMake(100, 51, _mySize!.width-100-61, 14)
        _desLable?.textColor=Config._color_gray_subTitle
        _desLable?.font=Config._font_cell_subTitle
    }
    
    func _setPic(__pic:NSDictionary){
        if let _url = __pic.objectForKey("thumbnail") as? String{
            _image!._setPic(NSDictionary(objects:[MainInterface._imageUrl(_url),"file"], forKeys: ["url","type"]), __block:{_ in
            })
            return
        }else{
            _image!._setPic(__pic, __block:{_ in
            })
        }
        
    }

    func setTitle(_text:NSString)->Void{
        var _str:String = _text as String
        if _str==""{
            _str = "未命名图册"
        }
        _titleLable?.text=(_str)
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
