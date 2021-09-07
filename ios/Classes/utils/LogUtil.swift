//
//  LogUtil.swift
//  flutter_tencentad
//
//  Created by gstory on 2021/9/4.
//

import Foundation

public class LogUtil : NSObject{
   
    static let logInstance = LogUtil()
    
    private var isDebug: Bool = false
    
    func isShow(debug:Bool){
        self.isDebug = debug
    }
    
    func printLog<T>(message: T,
                     file: String = #file,
                     method: String = #function,
                     line: Int = #line)
    {
        if(self.isDebug == true){
            print("\((file as NSString).lastPathComponent)[\(line)], \(method): \(message)")
        }
    }
}
