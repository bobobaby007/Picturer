//
//  Manage_imagePicker.swift
//  Picturer
//
//  Created by Bob Huang on 15/6/20.
//  Copyright (c) 2015年 4view. All rights reserved.
//

//----弹出选择相册

import Foundation
import UIKit
import AssetsLibrary
import AVFoundation


protocol PicsSelecter_deletegate:NSObjectProtocol{
    func imagePickerDidSelected(images:NSArray)
}
class PicsSelecter:UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, PicsShowCellDelegate,UINavigationControllerDelegate{
    
    let _gap:CGFloat=15
    let _barH:CGFloat = 64
    var _title_label:UILabel?
    var _topBar:UIView?
    var _btn_cancel:UIButton?
    var _btn_save:UIButton?
    
    
    var _collectionView:UICollectionView?
    weak var _delegate:PicsSelecter_deletegate?
    

    
    var _images:NSMutableArray?=[]
    
    var _firstLoaded:Bool=true
    
    
    var _setuped:Bool=false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    func setup(){
        if _setuped{
            return
        }
        
        _topBar=UIView(frame:CGRect(x: 0, y: 0, width: self.view.frame.width, height: _barH))
        _topBar?.backgroundColor=MainAction._color_black_bar
        _btn_cancel=UIButton(frame:CGRect(x: _gap-3, y: 20, width: 40, height: _barH-20))
        _btn_cancel?.titleLabel?.textAlignment = NSTextAlignment.Left
        _btn_cancel?.titleLabel?.font=MainAction._font_topButton
        _btn_cancel?.setTitle("取消", forState: UIControlState.Normal)
        _btn_cancel?.addTarget(self, action: "clickAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
        _btn_save=UIButton(frame:CGRect(x: self.view.frame.width-40-_gap+3, y: 20, width: 40, height: _barH-20))
        _btn_save?.titleLabel?.textAlignment = NSTextAlignment.Right
        _btn_save?.titleLabel?.font=MainAction._font_topButton
        
        _btn_save?.setTitle("保存", forState: UIControlState.Normal)
        _btn_save?.setTitleColor(MainAction._color_yellow, forState: UIControlState.Normal)
        _btn_save?.addTarget(self, action: "clickAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
        _title_label=UILabel(frame:CGRect(x: 50, y: 10, width: self.view.frame.width-100, height: 64))
        
        _title_label?.textColor=UIColor.whiteColor()
        _title_label?.font = MainAction._font_topbarTitle
        _title_label?.textAlignment=NSTextAlignment.Center
        _title_label?.text="选择图片"
        
        _topBar?.addSubview(_title_label!)
        _topBar?.addSubview(_btn_cancel!)
        _topBar?.addSubview(_btn_save!)
        
        //print("images:",_images)
        
        let layout = CustomLayout()
        
        _collectionView = UICollectionView(frame: CGRect(x: 0, y: _barH, width: self.view.frame.width, height: self.view.frame.height-_barH),collectionViewLayout:layout)
        _collectionView?.registerClass(PicsShowCell.self, forCellWithReuseIdentifier: "PicsShowCell")
        _collectionView?.delegate = self
        _collectionView?.dataSource = self
        
        self.view.addSubview(_collectionView!)
        
        
        self.view.addSubview(_topBar!)
        
        
        _setuped = true
        
    }
    
    //-----设置图片数组，录入的图片格式为[NSDictionary(objects: [_url,"file"], forKeys: ["url","type"])] 或 [NSDictionary(objects: [_url,"alasset"], forKeys: ["url","type"])]
    func _setImages(__images:NSArray)->Void{
       
        
        self._images=[]
        for var i:Int = 0;i < __images.count; ++i{
            let _dict:NSMutableDictionary = NSMutableDictionary(dictionary: __images.objectAtIndex(i) as! NSDictionary )
            _dict.setObject(0, forKey: "selected")
            self._images?.addObject(_dict)
        }
        
        //print(self._images)
        
//        _group.group.enumerateAssetsUsingBlock {[unowned self](result: ALAsset!, index: Int, stop: UnsafeMutablePointer<ObjCBool>) in
//            if result != nil {
//                let asset = DKAsset()
//                //asset.thumbnailImage = UIImage(CGImage:result.thumbnail().takeUnretainedValue())
//                let _nsurl:NSURL = (result.valueForProperty(ALAssetPropertyAssetURL) as? NSURL)!
//                let _url:NSString=_nsurl.absoluteString
//                let _dict:NSDictionary = NSDictionary(objects: [_url,"alasset"], forKeys: ["url","type"])
//                //asset.originalAsset = result
//                self._images!.insertObject(_dict, atIndex: 0)
//                self._imageItems?.insertObject(asset, atIndex: 0)
//                //                self._collectionView!.reloadData()
//            } else {
//                self._collectionView!.reloadData()
//                self._collectionView.scrollToItemAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), atScrollPosition: UICollectionViewScrollPosition.None, animated: true)
//            }
//        }
        if self._collectionView == nil{
            return
        }
        self._collectionView!.reloadData()
        self._collectionView!.scrollToItemAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), atScrollPosition: UICollectionViewScrollPosition.None, animated: true)
        
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       
        return _images!.count;
    }
    func collectionView(collectionView: UICollectionView,
        cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
            
                let identify:String = "PicsShowCell"
                let cell = self._collectionView?.dequeueReusableCellWithReuseIdentifier(
                    identify, forIndexPath: indexPath) as! PicsShowCell
                cell._index=indexPath.item
            
                let _pic:NSDictionary=_images?.objectAtIndex(indexPath.item) as! NSDictionary
            
            
                
                if (_pic.objectForKey("seleceted") != nil) {
                    let _s:Int=_pic.objectForKey("selected") as! Int
                    if _s == 1{
                      cell._selected=true
                    }else{
                      cell._selected=false
                    }
                }else{
                    cell._selected=false
                }
            
                cell._setPic(_pic)
                cell._delegate=self
                cell._hasTag=true
                return cell
            
            
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        //  var _show = self.storyboard?.instantiateViewControllerWithIdentifier("Manage_show") as? Manage_show
        let _controller:Manage_pic = Manage_pic()
        _controller._showIndexAtPics(indexPath.item, __array: _images!)
        self.navigationController?.pushViewController(_controller, animated: true)
    }
    
    
    //-----图片单独选中☑️或取消
    func PicDidSelected(pic: PicsShowCell) {
        
        //var _ps:NSMutableArray=NSMutableArray(array: _images!)
        let _pic:NSMutableDictionary=NSMutableDictionary(dictionary: _images?.objectAtIndex(pic._index!) as! NSDictionary)
        _pic.setObject(pic._selected, forKey: "selected")
        _images![pic._index!]=_pic
    }
    
   
    func clickAction(_btn:UIButton)->Void{
        switch _btn{
        case _btn_cancel!:
            self.navigationController?.popViewControllerAnimated(true)
        case _btn_save!:
            let _imgs:NSMutableArray=NSMutableArray()
            
            let _c:Int = _images!.count
            
            for var i=0; i<_c;++i{
                let _pic:NSDictionary = _images!.objectAtIndex(i) as! NSDictionary
                
                
                
                if (_pic.objectForKey("selected") != nil) {
                    
                    let _s:Int=_pic.objectForKey("selected") as! Int
                    if _s == 1{
                        _imgs.addObject(_pic)
                    }
                    
                    
                }else{
                    
                }
                
            }
            
            self.navigationController?.popViewControllerAnimated(false)
            _delegate?.imagePickerDidSelected(_imgs)
            
            
        default:
            print("")
        }
    }
    override func viewWillAppear(animated: Bool) {
        UIApplication.sharedApplication().statusBarStyle=UIStatusBarStyle.LightContent
        UIApplication.sharedApplication().statusBarHidden=false
    }
}










