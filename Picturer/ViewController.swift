//
//  ViewController.swift
//  Picturers
//
//  Created by Bob Huang on 15/6/14.
//  Copyright (c) 2015年 4view. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

   
    var manage_home:Manage_home?
    var _navgationController = UINavigationController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
        
        
        showManageHome()
        //showManageHome()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    
    func setup()->Void{
        self.view.addSubview(_navgationController.view)
        if (manage_home != nil){
            //println("有")
        }else{
            //  println("没")
            manage_home=self.storyboard?.instantiateViewControllerWithIdentifier("Manage_home") as? Manage_home
        }
        _navgationController.navigationBarHidden=true
        
       // _navgationController.addChildViewController(manage_home!)
    }
    
    //----显示编辑首页

    func showManageHome(){
        
       _navgationController.pushViewController(manage_home!, animated: true)
        
       // self.navigationController?.presentViewController(manage_home!, animated: true, completion: { () -> Void in
         //   println("22")
        //})
        
        //self.view.addSubview(manage_home!.view)
        
        }
}

