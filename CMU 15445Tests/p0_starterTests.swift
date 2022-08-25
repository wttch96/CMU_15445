//
//  p0_starterTests.swift
//  CMU 15445Tests
//
//  Created by Wttch on 2022/8/22.
//

import XCTest
@testable import CMU_15445

final class p0_starterTests : XCTestCase {
    
    // 测试矩阵初始化
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
                assert(expected == assertNotThrowAndReturn { return try matrix.getElement(i, j) })
            }
        }
    }
    
    // 测试矩阵元素访问
    func testElementAccess() {
        var matrix = RowMatrix<Int>(2, 2)
        let source1 = Array(count: 4, { $0 })
        
        assertNotThrow { try matrix.fillFrom(source1) }
        
        // 判断每个元素的值
        for i in 0..<matrix.rowCount() {
            for j in 0..<matrix.columnCount() {
                let element = assertNotThrowAndReturn { try matrix.getElement(i, j) }
                let expected = i * matrix.columnCount() + j
                assert(expected == element)
            }
        }
        
        
        // Attempts to access elements out of range should throw
        assertThrow({ let _ = try matrix.getElement(0, -1) }, .outOfRange)
        assertThrow({ let _ = try matrix.getElement(-1, 0) }, .outOfRange)
        assertThrow({ let _ = try matrix.getElement(0, 2) }, .outOfRange)
        assertThrow({ let _ = try matrix.getElement(2, 0) }, .outOfRange)

        // Attempts to set elements out of range should throw
        assertThrow({ try matrix.setElement(0, -1, 445) }, .outOfRange)
        assertThrow({ try matrix.setElement(-1, 0, 445) }, .outOfRange)
        assertThrow({ try matrix.setElement(0, 2, 445) }, .outOfRange)
        assertThrow({ try matrix.setElement(2, 0, 445) }, .outOfRange)

        // Setting elements in range should succeed
        for i in 0..<matrix.rowCount() {
            for j in 0..<matrix.columnCount() {
                // Increment each element by 1
                let value = i * matrix.columnCount() + j + 1
                assertNotThrow {
                    try matrix.setElement(i, j, value)
                }
            }
        }

        // The effect of setting elements should be visible
        for i in 0..<matrix.rowCount() {
            for j in 0..<matrix.columnCount() {
                // Increment each element by 1
                let expected = i * matrix.columnCount() + j + 1
                let value = assertNotThrowAndReturn { try matrix.getElement(i, j)}
                assert(value == expected)
            }
        }
    }
    
    // 测试加法
    func testAddition() {
        var matrix0 = RowMatrix<Int>(3, 3)
        let source0 = [1, 4, 2, 5, 2, -1, 0, 3, 1]
        assertNotThrow { try matrix0.fillFrom(source0) }
       
        for i in 0..<matrix0.rowCount() {
            for j in 0..<matrix0.columnCount() {
                let expected = source0[i * matrix0.columnCount() + j]
                let value = assertNotThrowAndReturn { try matrix0.getElement(i, j)}
                assert(value == expected)
            }
        }
        
        var matrix1 = RowMatrix<Int>(3, 3)
        let source1 = [2, -3, 1, 4, 6, 7, 0, 5, -2]
        assertNotThrow { try matrix1.fillFrom(source1) }
       
        for i in 0..<matrix1.rowCount() {
            for j in 0..<matrix1.columnCount() {
                let expected = source1[i * matrix1.columnCount() + j]
                let value = assertNotThrowAndReturn { try matrix1.getElement(i, j)}
                assert(value == expected)
            }
        }
        
        let excepted = [3, 1, 3, 9, 8, 6, 0, 8, -1]
        let sum = assertNotThrowAndReturn{ try matrix0 + matrix1 }
        XCTAssertEqual(sum.rowCount(), 3)
        XCTAssertEqual(sum.columnCount(), 3)
        
        for i in 0..<sum.rowCount() {
            for j in 0..<sum.columnCount() {
                let expected = excepted[i * sum.columnCount() + j]
                let value = assertNotThrowAndReturn { try sum.getElement(i, j)}
                assert(value == expected)
            }
        }
    }
    
    // 测试乘法
    func testMultiplication() {
        let source0 = [1, 2, 3, 4, 5, 6]
        var matrix0 = RowMatrix<Int>(2, 3)
        assertNotThrow {
            try matrix0.fillFrom(source0)
        }
        for i in 0..<matrix0.rowCount() {
            for j in 0..<matrix0.columnCount() {
                let expected = source0[i * matrix0.columnCount() + j]
                let value = assertNotThrowAndReturn { try matrix0.getElement(i, j)}
                assert(value == expected)
            }
        }
        
        let source1 = [-2, 1, -2, 2, 2, 3]
        var matrix1 = RowMatrix<Int>(3, 2)
        assertNotThrow {
            try matrix1.fillFrom(source1)
        }
        for i in 0..<matrix1.rowCount() {
            for j in 0..<matrix1.columnCount() {
                let expected = source1[i * matrix1.columnCount() + j]
                let value = assertNotThrowAndReturn { try matrix1.getElement(i, j)}
                assert(value == expected)
            }
        }
        
        let excepted = [0, 14, -6, 32]
        let product = assertNotThrowAndReturn { try matrix0 * matrix1 }
        // (2,3) * (3,2) -> (2,2)
        XCTAssertEqual(product.columnCount(), 2)
        XCTAssertEqual(product.rowCount(), 2)
        
        for i in 0..<product.rowCount() {
            for j in 0..<product.columnCount() {
                let expected = excepted[i * product.columnCount() + j]
                let value = assertNotThrowAndReturn { try product.getElement(i, j)}
                assert(value == expected)
            }
        }
    }
}
