//
//  SplashAdViewFactory.swift
//  flutter_tencentad
//
//  Created by 郭维佳 on 2021/9/7.
//

import Foundation

public class SplashAdViewFactory: NSObject,FlutterPlatformViewFactory {
    private var messenger: FlutterBinaryMessenger

    init(messenger: NSObjectProtocol & FlutterBinaryMessenger) {
        self.messenger = messenger
        super.init()
    }
    
    public func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?) -> FlutterPlatformView {
        return SplashAdView(frame,  binaryMessenger: self.messenger,id: viewId, params:args)
    }
    
    public func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        return FlutterStandardMessageCodec.sharedInstance()
    }
}
