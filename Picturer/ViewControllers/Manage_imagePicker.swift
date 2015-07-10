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


protocol ImagePickerDeletegate:NSObjectProtocol{
    func imagePickerDidSelected(images:NSArray)
}


// Group Model
class DKAssetGroup : NSObject {
    var groupName: String!
    var thumbnail: UIImage!
    var group: ALAssetsGroup!
}
// Asset Model
class DKAsset: NSObject {
    var _seleceted:Bool=false
    //var thumbnailImage: UIImage?
    lazy var fullScreenImage: UIImage? = {
        return UIImage(CGImage: self.originalAsset.defaultRepresentation().fullScreenImage().takeUnretainedValue())
        }()
    lazy var fullResolutionImage: UIImage? = {
        return UIImage(CGImage: self.originalAsset.defaultRepresentation().fullResolutionImage().takeUnretainedValue())
        }()
    var url: String?
    
    private var originalAsset: ALAsset!
    
    // Compare two assets
    override func isEqual(object: AnyObject?) -> Bool {
        let other = object as! DKAsset!
        return self.url!.isEqual(other.url!)
    }
}



class Manage_imagePicker:UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, PicsShowCellDelegate{
        
        @IBOutlet weak var _btn_back:UIButton?
        @IBOutlet weak var _btn_ok:UIButton?
        @IBOutlet weak var _collectionView:UICollectionView!
        @IBOutlet weak var _btn_title:UIButton?
        @IBOutlet weak var _img_arrow:UIImageView?
    
        var _groupPicker:groupPickerController?
        var _cameraPicker: UIImagePickerController!
        var _delegate:ImagePickerDeletegate?
    
        lazy private var library: ALAssetsLibrary = {
            return ALAssetsLibrary()
        }()
    
        lazy private var _groups: NSMutableArray = {
            return NSMutableArray()
        }()

    
        lazy private var _images:NSMutableArray={
            return NSMutableArray()
        }()
    
       var _firstLoaded:Bool=true
    
    
    
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            let layout = CustomLayout()
            _collectionView.collectionViewLayout=layout
            _collectionView.registerClass(PicsShowCell.self, forCellWithReuseIdentifier: "PicsShowCell")
            
            
            
            library.enumerateGroupsWithTypes(ALAssetsGroupAll, usingBlock: {(group: ALAssetsGroup! , stop: UnsafeMutablePointer<ObjCBool>) in
                if group != nil {
                    
                    if group.numberOfAssets() != 0 {
                        
                       
                        
                        let groupName = group.valueForProperty(ALAssetsGroupPropertyName) as! String
                        
                        let assetGroup = DKAssetGroup()
                        assetGroup.groupName = groupName
                        assetGroup.thumbnail = UIImage(CGImage: group.posterImage().takeUnretainedValue())
                        assetGroup.group = group
                        
                        
                        
                        
                        self._groups.insertObject(assetGroup, atIndex: 0)
                        
                        if self._firstLoaded{
                           
                            self._firstLoaded=false
                        }
                        
                      //  self._groups.addObject(assetGroup)
                    }
                    
                    
                    
                    
                    
                    
                } else {
                    
                     self._loadImagesAt(0)
                    //self._collectionView.reloadData()
                }
                }, failureBlock: {(error: NSError!) in
                    //---没有相册
            })

            
            
        }
    
    
    func _loadImagesAt(_groupIndex:Int)->Void{
        let _group:DKAssetGroup=self._groups.objectAtIndex(_groupIndex) as! DKAssetGroup
        self._images=[DKAsset()]
        self._btn_title?.setTitle(_group.groupName, forState: UIControlState.Normal)
        
        //---三角位置
        var size = CGRect()
        var size2 = CGSize()
        size = (_group.groupName+"").boundingRectWithSize(size2, options: NSStringDrawingOptions.UsesFontLeading, attributes: nil, context: nil);
        _img_arrow?.frame=CGRect(x: self.view.bounds.width/2+size.width,y: 32,width: 10,height: 10)
        
        _group.group.enumerateAssetsUsingBlock {[unowned self](result: ALAsset!, index: Int, stop: UnsafeMutablePointer<ObjCBool>) in
            if result != nil {
                let asset = DKAsset()
                //asset.thumbnailImage = UIImage(CGImage:result.thumbnail().takeUnretainedValue())
                var _nsurl:NSURL = (result.valueForProperty(ALAssetPropertyAssetURL) as? NSURL)!
                asset.url=_nsurl.absoluteString
                
                //asset.originalAsset = result
                self._images.insertObject(asset, atIndex: 1)
//                self._collectionView!.reloadData()
            } else {
                self._collectionView!.reloadData()
                self._collectionView.scrollToItemAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), atScrollPosition: UICollectionViewScrollPosition.None, animated: true)
            }
        }

    }
    
        func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return _images.count;
        }
        func collectionView(collectionView: UICollectionView,
            cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
                let identify:String = "PicsShowCell"
                let cell = self._collectionView?.dequeueReusableCellWithReuseIdentifier(
                    identify, forIndexPath: indexPath) as! PicsShowCell
                cell._indexPath=indexPath
                
                if indexPath.item==0{
                    cell._setImage("camara.png")
                    cell._hasTag=false
                }else{
                    let _asset:DKAsset=_images[indexPath.item] as! DKAsset
                    
                    let _al:ALAssetsLibrary=ALAssetsLibrary()
                    _al.assetForURL(NSURL(string: _asset.url!)! , resultBlock: { (asset:ALAsset!) -> Void in
                        cell._setImageByImage(UIImage(CGImage: asset.thumbnail().takeUnretainedValue())!)
                        }, failureBlock: { (error:NSError!) -> Void in
                        
                    })
                    //let _image:UIImage=UIImage(CGImage:_asset.originalAsset.thumbnail().takeUnretainedValue())!
                    cell._delegate=self
                    
                    cell._selected=_asset._seleceted
                    cell._hasTag=true
                }
                return cell
        }
        func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
            
            
            //  var _show = self.storyboard?.instantiateViewControllerWithIdentifier("Manage_show") as? Manage_show
            
            if indexPath.item==0{
                
                _cameraPicker =  UIImagePickerController()
                //_cameraPicker.delegate = self
                _cameraPicker.sourceType = .Camera
                //self.view.window!.rootViewController!.presentViewController(_cameraPicker, animated: true, completion: nil)
                
                presentViewController(_cameraPicker, animated: true, completion: nil)
            }else{
                
                let _asset:DKAsset=_images[indexPath.item] as! DKAsset
                var _pic:Manage_pic?
                _pic=self.storyboard?.instantiateViewControllerWithIdentifier("Manage_pic") as? Manage_pic
                
                let _dict:NSDictionary = NSDictionary(objects: [_asset.url as String!,"alasset"], forKeys: ["url","type"])
                _pic?._setPic(_dict)
                
                self.navigationController?.pushViewController(_pic!, animated: true)
                //presentViewController(_pic!, animated: true, completion: nil)
            }
           
            
        }
    
    
    //-----图片单独选中☑️或取消
    func PicDidSelected(pic: PicsShowCell) {
        var _asset:DKAsset=_images[pic._indexPath!.item] as! DKAsset
        _asset._seleceted=pic._selected
        _images[pic._indexPath!.item]=_asset
        //println(pic._selected)
    }
    
    
    //-------弹出相册列表代理方法
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _groups.count
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return tableView.bounds.size.height/6
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell:AlbumListCell=tableView.dequeueReusableCellWithIdentifier("AlbumListCell", forIndexPath: indexPath) as! AlbumListCell
        let _group:DKAssetGroup=_groups[indexPath.row] as! DKAssetGroup
        cell.setThumbImageByImage(_group.thumbnail)
        cell.setTitle(_group.groupName)
        cell.setDescription(String(_group.group.numberOfAssets()))
        //cell.imageView?.image=UIImage(named: _albumArray[indexPath.row] as! String)
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
       // tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.dismissViewControllerAnimated(false, completion: nil)
        self._loadImagesAt(indexPath.row)
    }
    
    
    //----相机代理方法
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        _cameraPicker.dismissViewControllerAnimated(true, completion: nil)
        _loadImagesAt(0)
        
        //_cameraPicker.image = info[UIImagePickerControllerOriginalImage] as? UIImage
    }
    
    
    
    @IBAction func clickAction(_btn:UIButton)->Void{
        switch _btn{
        case _btn_back!:
            self.navigationController?.popViewControllerAnimated(true)
        case _btn_title!:
            _groupPicker=groupPickerController()
            _groupPicker!._setDelegateAndSource(self, _s: self)
            //self.navigationController?.presentViewController(_groupPicker!, animated: true, completion: nil)
            self.presentViewController(_groupPicker!, animated: true, completion: nil)
        case _btn_ok!:
            var _imgs:NSMutableArray=NSMutableArray()
            
            let _c:Int = _images.count
            
            for var i=0; i<_c;++i{
                let _ak:DKAsset = _images.objectAtIndex(i) as! DKAsset
                if _ak._seleceted {
                  //  println(_ak._seleceted)
                    let _img:NSDictionary=NSDictionary(objects: ["alasset",_ak.url!], forKeys: ["type","url"])
                  _imgs.addObject(_img)
                }
            }
            self.navigationController?.popViewControllerAnimated(true)
            _delegate?.imagePickerDidSelected(_imgs)
            
            
        default:
            println("")
        }
    }
}


class groupPickerController: UIViewController {
    
    var _topBar:UIView?
    var _btn_cancel:UIButton?
    
    var _tableView:UITableView?
    
    var _delegate:UITableViewDelegate?
    var _source:UITableViewDataSource?
    
    
    func _setDelegateAndSource(_d:UITableViewDelegate,_s:UITableViewDataSource){
        _tableView=UITableView()
        _tableView?.delegate=_d
        _tableView?.dataSource=_s
    }
    
    override func viewDidLoad() {
        _topBar=UIView(frame:CGRect(x: 0, y: 0, width: self.view.frame.width, height: 62))
        
        _topBar?.backgroundColor=UIColor.blackColor()
        
        _btn_cancel=UIButton(frame:CGRect(x: 0, y: 0, width: 40, height: 62))
        _btn_cancel?.setTitle("取消", forState: UIControlState.Normal)
        _btn_cancel?.addTarget(self, action: "clickAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        _tableView?.frame = CGRect(x: 0, y: 62, width: self.view.frame.width, height: self.view.frame.height-62)
        _tableView?.registerClass(AlbumListCell.self, forCellReuseIdentifier: "AlbumListCell")
        
        self.view.addSubview(_tableView!)
        
        self.view.addSubview(_topBar!)
        _topBar?.addSubview(_btn_cancel!)
            }
    
    func clickAction(sender:UIButton){
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}








