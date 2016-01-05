//
//  ViewController.swift
//  HGADView
//
//  Created by nero on 15/12/30.
//  Copyright © 2015年 nero. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var adView:HGADView<String>?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let adView = HGADView<String>(frame: CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: 200))
        view.addSubview(adView)
        let images = ["1","2","3"]
        adView.images = images
     
        adView.imageDidClick = { [unowned self] index  in
            print("第\(index)张图片被点击了")
            
        }
        adView.loadImage = { ( imageView:UIImageView,imageName:String) in
            imageView.image = UIImage(named: imageName)
//             or  use Other Modules
        }
        self.adView = adView

    
    }
    override func viewWillAppear(animated: Bool) {
        super.viewDidAppear(animated)
        adView?.addTimer()
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        adView?.removeTimer()
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {

    }
}

