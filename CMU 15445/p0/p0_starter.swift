//
//  p0_starter.swift
//  CMU 15445
//
//  Created by Wttch on 2022/8/19.
//

import Foundation


/// 矩阵元素的协议, 要实现这些方法使矩阵可以进行运算
protocol MatrixItem {
    // 0值
    static var zero: Self { get }
    
    /// 加法运算
    /// - Parameters:
    ///   - left: 被加数
    ///   - right: 加数
    /// - Returns: 和
    static func +(left: Self, right: Self) -> Self
    
    /// 乘法运算
    /// - Parameters:
    ///   - left: 被乘数
    ///   - right: 乘数
    /// - Returns: 积
    static func *(left: Self, right: Self) -> Self
}


extension MatrixItem {
    /// 加等运算
    /// - Parameters:
    ///   - lhs: 被加数, 和的赋值对象
    ///   - rhs: 加数
    static func += (lhs: inout Self, rhs: Self) {
        lhs = lhs + rhs
    }
}


///
/// 矩阵协议
///
protocol Matrix {
    // 矩阵包含的数据类型
    associatedtype T: MatrixItem
    
    /// 初始化矩阵
    /// - Parameters:
    ///   - rows: 矩阵行数
    ///   - cols: 矩阵列数
    init(_ rows: Int, _ cols: Int)
    
    // 获取矩阵行数
    func rowCount() -> Int
    
    // 获取矩阵列数
    func columnCount() -> Int
    
    
    /// 获取矩阵制定位置的元素的值
    /// - Parameters:
    ///   - row: 元素所在行
    ///   - col: 元素所在列
    /// - Returns: 制定位置的元素的值
    func getElement(_ row: Int, _ col: Int) throws -> T
    
    
    /// 为指定位置的元素设置值
    /// - Parameters:
    ///   - row: 元素所在行
    ///   - col: 元素所在列
    ///   - val: 元素的值
    mutating func setElement(_ row: Int, _ col: Int, _ val: T) throws
    
    /// 使用给定的数组填充矩阵, 要保证数据元素长度等于 rows * cols
    /// - Parameter source: 给定的数组
    mutating func fillFrom(_ source: [T]) throws
}

extension Matrix {
    
    /// 矩阵加法
    /// - Parameters:
    ///   - p1: 第一个矩阵
    ///   - p2: 第二个矩阵
    /// - Returns: 矩阵的和
    static func + (p1: Self, p2: Self) throws -> Self {
        guard p1.rowCount() == p2.rowCount() && p1.columnCount() == p2.columnCount() else {
            throw Excetion(.outOfRange)
        }
        
        var result = Self.init(p1.rowCount(), p2.columnCount())
        
        for r in 0..<p1.rowCount() {
            for c in 0..<p1.columnCount() {
                try result.setElement(r, c, p1.getElement(r, c) + p2.getElement(r, c))
            }
        }
        return result
    }
    
    
    /// 矩阵乘法
    /// - Parameters:
    ///   - p1: 第一个矩阵
    ///   - p2: 第二个矩阵
    /// - Returns: 矩阵的积
    static func * (p1: Self, p2: Self) throws -> Self {
        guard p1.columnCount() == p2.rowCount() else {
            throw Excetion(.outOfRange)
        }
        
        var result = Self.init(p1.rowCount(), p2.columnCount())
        
        for r in 0..<p1.rowCount() {
            for c in 0..<p2.columnCount() {
                var sum: T = T.zero
                for i in 0..<p1.columnCount() {
                    try sum += p1.getElement(r, i) * p2.getElement(i, c)
                }
                try result.setElement(r, c, sum)
            }
        }
        return result
    }
    
    // Simplified General Matrix Multiply operation. Compute (`matrixA` * `matrixB` + `matrixC`).
    public static func gemm(a: Self, b: Self, c: Self) throws -> Self {
        return try a * b + c
    }
}

/// 矩阵协议的简单实现
struct RowMatrix<E> : Matrix where E : MatrixItem {
    typealias T = E
    // 行
    private let rows: Int
    // 列
    private let cols: Int
    // 保存的数据在二维数组中
    private var data: [[E]]
    
    init(_ rows: Int, _ cols: Int) {
        self.rows = rows
        self.cols = cols
        self.data = Array(repeating: Array(repeating: E.zero, count: cols), count: rows)
    }
    
    func rowCount() -> Int { rows }
    
    func columnCount() -> Int { cols }
    
    func getElement(_ row: Int, _ col: Int) throws -> E {
        guard row >= 0 && row < rows && col >= 0 && col < cols else {
            throw Excetion(.outOfRange, msg: "getElement 矩阵越界!")
        }
        return data[row][col]
    }
    
    mutating func setElement(_ row: Int, _ col: Int, _ val: E) throws {
        guard row >= 0 && row < rows && col >= 0 && col < cols else {
            throw Excetion(.outOfRange, msg: "setElement 矩阵越界!")
        }
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

extension Int : MatrixItem {
    public static var zero: Int = 0
}
