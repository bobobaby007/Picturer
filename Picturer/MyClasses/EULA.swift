//
//  MyImageList.swift
//  JPoint
//
//  Created by Bob Huang on 15/9/24.
//  Copyright © 2015年 4view. All rights reserved.
//

import Foundation
import UIKit

protocol EULA_delegate:NSObjectProtocol{
   func _EULA_accepted()
}

class EULA:UIViewController{
    weak var _delegate:EULA_delegate?
    var _setuped:Bool = false
    var _topView:UIView?
    let _barH:CGFloat = 60
    
    let _gap:CGFloat=15
    var _topBar:UIView?
    var _btn_cancel:UIButton?
    var _title_label:UILabel?
    
    var _btn_accept:UIButton?
    
    var _contentText:UITextView?
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup(){
        if _setuped{
            return
        }
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.view.backgroundColor=UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        
        self.view.backgroundColor=Config._color_bg_gray
        _topBar=UIView(frame:CGRect(x: 0, y: 0, width: self.view.frame.width, height: Config._barH ))
        _topBar?.backgroundColor=Config._color_black_bar
        
        
        
        _btn_cancel=UIButton(frame:CGRect(x: 0, y: 20, width: 44, height: 44))
        _btn_cancel?.setImage(UIImage(named: "back_icon.png"), forState: UIControlState.Normal)
        
        _btn_cancel?.addTarget(self, action: #selector(EULA.btnHander(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        _title_label=UILabel(frame:CGRect(x: 50, y: 12, width: self.view.frame.width-100, height: 60))
        _title_label?.textColor=UIColor.whiteColor()
        _title_label?.font = Config._font_topbarTitle
        _title_label?.textAlignment=NSTextAlignment.Center
        _title_label?.text="用户协议"
        self.view.addSubview(_topBar!)
        
        
       
        
        _topBar?.addSubview(_btn_cancel!)
        _topBar?.addSubview(_title_label!)
        
        // _tableView?.tableHeaderView = _topView
        self.view.addSubview(_topBar!)
        
        _contentText = UITextView(frame: CGRect(x: 10, y: _barH + 10, width: self.view.frame.width - 20, height: self.view.frame.height - _barH))
        self.view.addSubview(_contentText!)
        
        _contentText?.backgroundColor = UIColor.clearColor() // UIColor(white: 1, alpha: 0.4)
        _contentText?.textColor = UIColor.whiteColor()
        _contentText?.editable = false
        _contentText?.selectable = false
        
        
        let fileURL = NSBundle.mainBundle().URLForResource("EULA", withExtension: "rtf")
        
        do{
           let attributedText = try NSAttributedString(fileURL: fileURL!, options: [NSDocumentTypeDocumentAttribute:NSRTFTextDocumentType], documentAttributes:nil)
            _contentText!.attributedText = attributedText
        }catch{
            print(error)
        }
        
        _setuped=true
    }
    
    func btnHander(sender:UIButton){
        
        switch sender{
        case _btn_cancel!:
            self.dismissViewControllerAnimated(true, completion: { () -> Void in
                
            })
            break
        default:
            break
            
        }
    }
    
    
}
