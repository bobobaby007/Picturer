//
//  Manage_show.swift
//  Picturers
//
//  Created by Bob Huang on 15/6/19.
//  Copyright (c) 2015年 4view. All rights reserved.
//

import Foundation
import UIKit

class Manage_show: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    
    @IBOutlet weak var _btn_back:UIButton?
    @IBOutlet weak var _collectionView:UICollectionView!
    
    
    
    var _collectionArray:NSArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let layout = CustomLayout()
        _collectionView.collectionViewLayout=layout
        _collectionView.registerClass(PicsShowCell.self, forCellWithReuseIdentifier: "PicsShowCell")
    }
    func _setPicArray(__array:NSArray){
        _collectionArray=__array
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return _collectionArray.count;
    }
    func collectionView(collectionView: UICollectionView,
        cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
            let identify:String = "PicsShowCell"
            let cell = self._collectionView?.dequeueReusableCellWithReuseIdentifier(
                identify, forIndexPath: indexPath) as! PicsShowCell
           // let cell = PicsShowCell()
            cell._setImage( _collectionArray[indexPath.item] as! String)
            
            
            if indexPath.item%2==1{
                cell._setSelected(true)
            }else{
                cell._setSelected(false)
            }
            
            if indexPath.item%3==1{
                cell._setTagHidden(true)
            }else{
                
            }
            return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        var _pic:Manage_pic?
        _pic=self.storyboard?.instantiateViewControllerWithIdentifier("Manage_pic") as? Manage_pic
        // println(_show)
        //  var _show = self.storyboard?.instantiateViewControllerWithIdentifier("Manage_show") as? Manage_show
        
       // _pic?._setImage(_collectionArray[indexPath.item])
        
        self.navigationController?.pushViewController(_pic!, animated: true)        
        _pic?._setImage(_collectionArray[indexPath.item] as! String)
        
        
        
    }

    
    
    @IBAction func clickAction(_btn:UIButton)->Void{
        if _btn == _btn_back{
            self.navigationController?.popViewControllerAnimated(true)
        }
    }

}
