//
//  p1_replacerTests.swift
//  CMU 15445Tests
//
//  Created by Wttch on 2022/8/29.
//

import XCTest
@testable import CMU_15445

final class p1_replacerTests : XCTestCase {
    
    func testLru() {
        var lru = LRUReplacer(7)
        lru.unpin(1)
        lru.unpin(2)
        lru.unpin(3)
        lru.unpin(4)
        lru.unpin(5)
        lru.unpin(6)
        lru.unpin(1)
        XCTAssertEqual(6, lru.size())
        
        var value: FrameId = 0
        lru.victim(&value)
        XCTAssertEqual(1, value)
        lru.victim(&value)
        XCTAssertEqual(2, value)
        lru.victim(&value)
        XCTAssertEqual(3, value)
        
        lru.pin(3)
        lru.pin(4)
        XCTAssertEqual(2, lru.size())
        
        lru.unpin(4)
        
        lru.victim(&value)
        XCTAssertEqual(5, value)
        lru.victim(&value)
        XCTAssertEqual(6, value)
        lru.victim(&value)
        XCTAssertEqual(4, value)
    }
    
}
