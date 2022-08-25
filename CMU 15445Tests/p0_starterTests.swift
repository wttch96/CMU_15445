//
//  p0_starterTests.swift
//  CMU 15445Tests
//
//  Created by Wttch on 2022/8/22.
//

import XCTest
@testable import CMU_15445

final class p0_starterTests : XCTestCase {
    
    func testInitialization() {
        var matrix = RowMatrix<Int>(2, 2)
        
        // 元素不够
        let source1 = Array(count: 3, { $0 })
        assertThrow({ try matrix.fillFrom(source1) }, .outOfRange)
        
        // 元素太多
        let source2 = Array(count: 5, { $0 })
        assertThrow({ try matrix.fillFrom(source2) }, .outOfRange)
        
        // 正确元素
        let source3 = Array(count: 4, { $0 })
        assertNotThrow({ try matrix.fillFrom(source3)})
        
        // 判断每个元素的值
        for i in 0..<matrix.rowCount() {
            for j in 0..<matrix.columnCount() {
                let expected = i * matrix.columnCount() + j
                assert(expected == matrix.getElement(i, j))
            }
        }
    }
}
