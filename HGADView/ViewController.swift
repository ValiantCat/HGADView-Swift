//
//  ViewController.swift
//  HGADView
//
//  Created by nero on 15/12/30.
//  Copyright © 2015年 nero. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let adView = HGADView<String>(frame: CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: 200))
        view.addSubview(adView)
        let images = ["1","2","3"]
        adView.images = images
     
        adView.imageDidClick = { index  in
            print("第\(index)张图片被点击了")
            
        }
    
    }
    
    
}

