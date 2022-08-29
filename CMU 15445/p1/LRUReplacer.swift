//
//  LRUReplacer.swift
//  CMU 15445
//
//  Created by Wttch on 2022/8/29.
//

import Foundation

class LRUReplacer : Replacer {
    private var capital: Int
    
    private var lists: [FrameId] = []
    private var map: [FrameId: Bool] = [:]
    
    init(_ numPages: Int) {
        self.capital = numPages
    }
    
    func victim(_ frameId: inout FrameId) -> Bool {
        if lists.isEmpty {
            return false
        }
        frameId = lists.removeLast()
        map.removeValue(forKey: frameId)
        return true
    }
    
    func pin(_ frameId: FrameId) {
        if !map.contains(where: { (key: FrameId, value: Bool) in
            frameId == key
        }) {
            return
        }
        lists.remove(at: lists.firstIndex(of: frameId)!)
        map.removeValue(forKey: frameId)
    }
    
    func unpin(_ frameId: FrameId) {
        if map[frameId] ?? false {
            return
        }
        
        while size() > capital {
            var t: FrameId = 0
            victim(&t)
        }
        lists.insert(frameId, at: 0)
        map[frameId] = true
    }
    
    func size() -> Int {
        lists.count
    }
}
