//
//  ViewController.swift
//  WYKSwiper
//
//  Created by 王亚坤 on 14/12/2016.
//  Copyright © 2016 yaomaitong. All rights reserved.
//

import UIKit

class ViewController: UIViewController, WYKSwiperDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        loadUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func loadUI() {
        let height = self.view.frame.size.height
        let width = self.view.frame.size.width
        let swiper = WYKSwiper(frame: CGRect(x: 0, y: height / 3, width: width, height: height / 3))
        swiper.setDefaultImage(defaultImage: UIImage(named: "default_image"))
        swiper.swiperDelegate = self
        self.view.addSubview(swiper)
        var data = [String]()
        data.append("https://image1.cdn.yaomaitong.cn/product/dfb2958ba0c44c94860de4e7a52b02da.jpg-img_l")
        data.append("https://image1.cdn.yaomaitong.cn/product/d225c7abd4e948a3bc5495999138902a.jpg-img_l")
        data.append("https://image1.cdn.yaomaitong.cn/product/e6f856541426449e92df9a7720254279.jpg-img_l")
        data.append("https://image1.cdn.yaomaitong.cn/product/a692ffa413054c5189e3f2f5a3c8f9fe.jpg-img_l")
        data.append("https://image1.cdn.yaomaitong.cn/product/1c3ecd11ac3f433194e8522900a528d5.jpg-img_l")
        var urls = [NSURL?]()
        urls.append(NSURL(string: "https://image1.cdn.yaomaitong.cn/product/dfb2958ba0c44c94860de4e7a52b02da.jpg-img_l"))
        urls.append(nil)
        urls.append(NSURL(string: "https://image1.cdn.yaomaitong.cn/product/e6f856541426449e92df9a7720254279.jpg-img_l"))
        urls.append(NSURL(string: "https://image1.cdn.yaomaitong.cn/product/a692ffa413054c5189e3f2f5a3c8f9fe.jpg-img_l"))
        swiper.setDataSource(data: data, links: urls)
    }
    
    func onSwiperImageClicked(url: NSURL) {
        NSLog("%@", url.absoluteString!)
    }
    
    func onSwiperPageNumberChanged(pageNumber: Int) {
        NSLog("pageNo:%@", String(pageNumber))
    }
}

