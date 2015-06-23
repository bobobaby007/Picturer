//
//  Manage_imagePicker.swift
//  Picturers
//
//  Created by Bob Huang on 15/6/20.
//  Copyright (c) 2015年 4view. All rights reserved.
//

import Foundation
import UIKit
import AssetsLibrary



// Group Model
class DKAssetGroup : NSObject {
    var groupName: String!
    var thumbnail: UIImage!
    var group: ALAssetsGroup!
}
// Asset Model
class DKAsset: NSObject {
    var thumbnailImage: UIImage?
    lazy var fullScreenImage: UIImage? = {
        return UIImage(CGImage: self.originalAsset.defaultRepresentation().fullScreenImage().takeUnretainedValue())
        }()
    lazy var fullResolutionImage: UIImage? = {
        return UIImage(CGImage: self.originalAsset.defaultRepresentation().fullResolutionImage().takeUnretainedValue())
        }()
    var url: NSURL?
    
    private var originalAsset: ALAsset!
    
    // Compare two assets
    override func isEqual(object: AnyObject?) -> Bool {
        let other = object as! DKAsset!
        return self.url!.isEqual(other.url!)
    }
}





class Manage_imagePicker:UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{    
        
        @IBOutlet weak var _btn_back:UIButton?
        @IBOutlet weak var _collectionView:UICollectionView!
        lazy private var library: ALAssetsLibrary = {
            return ALAssetsLibrary()
        }()
    
        lazy private var _groups: NSMutableArray = {
            return NSMutableArray()
        }()

    
        lazy private var _images:NSMutableArray={
            return NSMutableArray()
        }()
    
        var _collectionArray=["1.png","2.png","3.png","4.png","5.png","6.png","7.png"]
    
    
    
        
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
                        
                        
                        assetGroup.group.enumerateAssetsUsingBlock {[unowned self](result: ALAsset!, index: Int, stop: UnsafeMutablePointer<ObjCBool>) in
                            if result != nil {
                                let asset = DKAsset()
                                asset.thumbnailImage = UIImage(CGImage:result.thumbnail().takeUnretainedValue())
                                asset.url = result.valueForProperty(ALAssetPropertyAssetURL) as? NSURL
                                asset.originalAsset = result
                                self._images.addObject(asset)
                                self._collectionView!.reloadData()
                            } else {
                               self._collectionView!.reloadData()
                            }
                        }
                        
                        self._groups.insertObject(assetGroup, atIndex: 0)
                    }
                } else {
                    self._collectionView.reloadData()
                }
                }, failureBlock: {(error: NSError!) in
                    //---没有相册
            })
            
            


            
        }
        
        func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return _images.count;
        }
        func collectionView(collectionView: UICollectionView,
            cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
                let identify:String = "PicsShowCell"
                let cell = self._collectionView?.dequeueReusableCellWithReuseIdentifier(
                    identify, forIndexPath: indexPath) as! PicsShowCell
                let _asset:DKAsset=_images[indexPath.item] as! DKAsset
                let _image:UIImage=_asset.thumbnailImage!
                cell._setImageByImage(_image)
                cell._setSelected(false)
                return cell
        }
        func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
            var _pic:Manage_pic?
            _pic=self.storyboard?.instantiateViewControllerWithIdentifier("Manage_pic") as? Manage_pic
            // println(_show)
            //  var _show = self.storyboard?.instantiateViewControllerWithIdentifier("Manage_show") as? Manage_show
            
            // _pic?._setImage(_collectionArray[indexPath.item])
            
            self.navigationController?.pushViewController(_pic!, animated: true)
            
           // _pic?._setImage(_collectionArray[indexPath.item])
            
        }
        
        
        
        @IBAction func clickAction(_btn:UIButton)->Void{
            if _btn == _btn_back{
                self.navigationController?.popViewControllerAnimated(true)
            }
        }
        
    
}
