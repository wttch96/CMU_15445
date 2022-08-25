//
//  ArrayExtension.swift
//  CMU 15445
//
//  Created by Wttch on 2022/8/23.
//

import Foundation


extension Array {
    init(count: Int, _ generator: (Int) -> Element) {
        self.init(repeating: generator(0), count: count)
        for i in 0..<count {
            self[i] = generator(i)
        }
    }
}
