//
//  CustomLayout.swift
//  Picturers
//
//  Created by Bob Huang on 15/6/19.
//  Copyright (c) 2015年 4view. All rights reserved.
//
import UIKit

/**
* 这个类只简单定义了一个section的布局
*/
class CustomLayout : UICollectionViewLayout {
    
    // 内容区域总大小，不是可见区域
    override func collectionViewContentSize() -> CGSize {
        return CGSizeMake(collectionView!.bounds.size.width,
            CGFloat(collectionView!.numberOfItemsInSection(0) * 200 / 3 + 200))
    }
    
    // 所有单元格位置属性
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [AnyObject] {
        
        var attributesArray = [AnyObject]()
        let cellCount = self.collectionView!.numberOfItemsInSection(0)
        for i in 0..<cellCount {
            var indexPath =  NSIndexPath(forItem:i, inSection:0)
            
            var attributes =  self.layoutAttributesForItemAtIndexPath(indexPath)
            
            attributesArray.append(attributes)
            
        }
        return attributesArray
    }
    
    // 这个方法返回每个单元格的位置和大小
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath)
        -> UICollectionViewLayoutAttributes! {
            //当前单元格布局属性
            var attribute =  UICollectionViewLayoutAttributes(forCellWithIndexPath:indexPath)
            
            //单元格外部空隙，简单起见，这些常量都在方法内部定义了，没有共享为类成员
           // let itemSpacing = 2
            let lineSpacing = 3
            
            //单元格边长
            //let largeCellSide:CGFloat = 200
            var smallCellSide:CGFloat = CGFloat(collectionView!.bounds.size.width)
            smallCellSide=(smallCellSide-CGFloat(2*lineSpacing))/3
            
            //内部间隙，左右5
            var insets = UIEdgeInsetsMake(0, 0, 0, 0)
            
            
            //当前行数，每行显示3个图片，1大2小
            var line:Int =  indexPath.item / 3
            //当前行的Y坐标
            var lineOriginY =  smallCellSide * CGFloat(line) + CGFloat(lineSpacing * line) + insets.top
            var lineOriginX =  smallCellSide * CGFloat(indexPath.item % 3) + CGFloat((indexPath.item % 3)*lineSpacing) + insets.top
            //右侧单元格X坐标，这里按左右对齐，所以中间空隙大
            //var rightLargeX =  collectionView!.bounds.size.width - largeCellSide - insets.right
            var rightSmallX =  collectionView!.bounds.size.width - smallCellSide - insets.right
            
            
            attribute.frame = CGRectMake(lineOriginX, lineOriginY, smallCellSide, smallCellSide)
            
            /*
            // 每行2个图片，2行循环一次，一共6种位置
            if (indexPath.item % 6 == 0) {
                attribute.frame = CGRectMake(insets.left, lineOriginY, largeCellSide, largeCellSide)
            } else if (indexPath.item % 6 == 1) {
                attribute.frame = CGRectMake(rightSmallX, lineOriginY, smallCellSide, smallCellSide)
            } else if (indexPath.item % 6 == 2) {
                attribute.frame = CGRectMake(rightSmallX, lineOriginY + smallCellSide + insets.top,
                    smallCellSide, smallCellSide)
            } else if (indexPath.item % 6 == 3) {
                attribute.frame = CGRectMake(insets.left, lineOriginY, smallCellSide, smallCellSide)
            } else if (indexPath.item % 6 == 4) {
                attribute.frame = CGRectMake(insets.left, lineOriginY + smallCellSide + insets.top,
                    smallCellSide, smallCellSide)
            } else if (indexPath.item % 6 == 5) {
                attribute.frame = CGRectMake(rightLargeX, lineOriginY, largeCellSide, largeCellSide)
            }
            */
            
            
            return attribute
    }
    
    /*
    //如果有页眉、页脚或者背景，可以用下面的方法实现更多效果
    func layoutAttributesForSupplementaryViewOfKind(elementKind: String!,
    atIndexPath indexPath: NSIndexPath!) -> UICollectionViewLayoutAttributes!
    func layoutAttributesForDecorationViewOfKind(elementKind: String!,
    atIndexPath indexPath: NSIndexPath!) -> UICollectionViewLayoutAttributes!
    */
}
