//
//  TestExtensions.swift
//  CMU 15445
//
//  Created by Wttch on 2022/8/22.
//

import Foundation


func assertThrow(_ test: () throws -> (), _ errorType: ErrorType) {
    do {
        try test()
    } catch let error as Excetion {
        assert(error.type == errorType)
    } catch {
        assert(false)
    }
}


func assertNotThrow(_ test: () throws -> ()) {
    do {
        try test()
        assert(true)
    } catch {
        assert(false)
    }
}
