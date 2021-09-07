//
//  NativeExpressAdViewFactory.swift
//  flutter_tencentad
//
//  Created by gstory on 2021/9/1.
//

import Foundation

public class NativeExpressAdViewFactory: NSObject,FlutterPlatformViewFactory {
    private var messenger: FlutterBinaryMessenger

    init(messenger: NSObjectProtocol & FlutterBinaryMessenger) {
        self.messenger = messenger
        super.init()
    }
    
    public func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?) -> FlutterPlatformView {
        return NativeExpressAdView(frame,  binaryMessenger: self.messenger,id: viewId, params:args)
    }
    
    public func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        return FlutterStandardMessageCodec.sharedInstance()
    }
}
