//
//  Replacer.swift
//  CMU 15445
//
//  Created by Wttch on 2022/8/29.
//

import Foundation

typealias FrameId = Int

/// Replacer是一个跟踪页面使用情况的协议
protocol Replacer {
    
    /// 从frames中选出一个按最近访问时间排序排名最靠后的一个frame, 即要可以从缓存中删除的 frame(受害者~).
    /// 成功则将该frame的id保存在frame_id中, 并返回true
    /// 如果 frames 为空, 则返回false.
    /// - Parameter frameId: 当前可以从缓存中删除的 frame
    func victim(_ frameId: inout FrameId) -> Bool
    
    /// 当BufferPoolManager对某个Page进行Pin操作时,  需要将该Page所在的frame从最近缓存中删除.
    /// 该frame要使用, 不能再被选择为删除的frame(受害者).
    /// - Parameter frameId: pin 操作的 frame_id
    func pin(_ frameId: FrameId)
    
    /// 当某个Page被Unpin至pin_count_将为0时, 执行这个函数, 将该Page对应的frame放入unpinned_frames_
    func unpin(_ frameId: FrameId)
    
    /// 这个方法会返回当前Replacer中的frame的数量
    func size() -> Int
}
