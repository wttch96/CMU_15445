//
//  p0_starter.swift
//  CMU 15445
//
//  Created by Wttch on 2022/8/19.
//

import Foundation


protocol Matrix {
    associatedtype T
    
    init(_ rows: Int, _ cols: Int)
    
    func rowCount() -> Int
    
    func columnCount() -> Int
        
    func getElement(_ row: Int, _ col: Int) -> T
    
    mutating func setElement(_ row: Int, _ col: Int, _ val: T)
    
    mutating func fillFrom(_ source: [T]) throws
    
}

protocol MatrixItem {
    
    static var zero: Self { get }
    
    static func +(left: Self, right: Self) -> Self
    
    static func *(left: Self, right: Self) -> Self
}

extension MatrixItem {
    static func += (lhs: inout Self, rhs: Self) {
        lhs = lhs + rhs
    }
}

var a: Int = 1


struct MatrixError : Error {
    init(_ msg: String) {

    }
}

struct RowMatrix<E> : Matrix where E : MatrixItem {
    typealias T = E
    
    private let rows: Int
    private let cols: Int
    private var data: [[E]]
    
    init(_ rows: Int, _ cols: Int) {
        self.rows = rows
        self.cols = cols
        self.data = Array(repeating: Array(repeating: E.zero, count: cols), count: rows)
    }
    
    func rowCount() -> Int { rows }
    
    func columnCount() -> Int { cols }
    
    func getElement(_ row: Int, _ col: Int) -> E {
        data[row][col]
    }
    
    mutating func setElement(_ row: Int, _ col: Int, _ val: E) {
        self.data[row][col] = val
    }
    
    mutating func fillFrom(_ source: [E]) throws {
        guard source.count == rows * cols else {
            throw Excetion(.outOfRange, msg: "source 长度和矩阵容量不一致")
        }
        for r in 0..<rows {
            for c in 0..<cols {
                self.data[r][c] = source[c + r * cols]
            }
        }
    }
}

func +<T> (p1: RowMatrix<T>, p2: RowMatrix<T>) throws -> RowMatrix<T> where T : MatrixItem {
    guard p1.rowCount() == p2.rowCount() && p1.columnCount() == p2.columnCount() else {
        throw Excetion(.outOfRange)
    }
    
    var result = RowMatrix<T>(p1.rowCount(), p2.columnCount())
    
    for r in 0..<p1.rowCount() {
        for c in 0..<p1.columnCount() {
            result.setElement(r, c, p1.getElement(r, c) + p2.getElement(r, c))
        }
    }
    
    return result
}

func *<T> (p1: RowMatrix<T>, p2: RowMatrix<T>) throws -> RowMatrix<T> where T : MatrixItem {
    guard p1.columnCount() == p2.rowCount() else {
        throw Excetion(.outOfRange)
    }
    
    var result = RowMatrix<T>(p1.rowCount(), p2.columnCount())
    
    for r in 0..<p1.rowCount() {
        for c in 0..<p2.columnCount() {
            var sum: T = T.zero
            for i in 0..<p1.columnCount() {
                sum += p1.getElement(r, i) * p2.getElement(i, c)
            }
            result.setElement(r, c, sum)
        }
    }
    
    return result
}


extension Int : MatrixItem {
    public static var zero: Int = 0
}
