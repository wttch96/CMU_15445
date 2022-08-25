//
//  errors.swift
//  CMU 15445
//
//  Created by Wttch on 2022/8/22.
//

import Foundation


enum ErrorType {
    case invaild
    case outOfRange
}

class Excetion : Error {
    let type: ErrorType
    let message: String
    init(_ type: ErrorType, msg: String = "") {
        self.type = type
        self.message = msg
    }
}
