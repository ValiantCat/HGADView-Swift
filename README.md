# HGADView-Swift
Swift版轮播器


专门为Swift写的轮播器   非常具有Swift的风格

1 到导入项目 将HGADView拖进项目即可  
2 初始化  如下

      let adView = HGADView<String>(frame: CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: 200))
           view.addSubview(adView)
           let images = ["1","2","3"]
           adView.images = images
     
           adView.imageDidClick = { index  in
               print("第\(index)张图片被点击了")
            
            }
            // 加载图片的代码
             adView.loadImage = { ( imageView:UIImageView,imageName:String) in
            imageView.image = UIImage(named: imageName)
            // or  use Other Modules              
        }


3 Demo见下图
![demo](https://github.com/aiqiuqiu/HGADView-Swift/blob/master/demo.gif)
