//
//  MyUtils.swift
//  flutter_tencentad
//
//  Created by gstory on 2021/9/4.
//

import Foundation

class MyUtils{
    static func getVC() -> UIViewController {
            let viewController = UIApplication.shared.windows.filter { (w) -> Bool in
                w.isHidden == false
            }.first?.rootViewController
            return viewController!
        }
    
    //获取屏幕尺寸
    static func getScreenSize() -> CGRect {
        let screenBounds:CGRect = UIScreen.main.bounds
        return screenBounds
    }
}
