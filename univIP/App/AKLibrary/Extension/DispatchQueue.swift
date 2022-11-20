//
//  DispatchQueue.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2022/11/18.
//

import Foundation

extension DispatchQueue {
    
    class func mainThread(execute work: () -> Void) {
        if Thread.isMainThread {
            work()
        } else {
            DispatchQueue.main.sync(execute: work)
        }
    }
    
    class func mainThread<T>(execute work: () throws -> T) rethrows -> T {
        if Thread.isMainThread {
            return try work()
        } else {
            return try DispatchQueue.main.sync(execute: work)
        }
    }
    
}
