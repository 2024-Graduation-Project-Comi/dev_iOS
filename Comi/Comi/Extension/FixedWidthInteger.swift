//
//  FixedWidthInteger.swift
//  Comi
//
//  Created by MoonGoon on 5/24/24.
//

import Foundation

extension FixedWidthInteger {
    var littleEndianData: Data {
        var value = self.littleEndian
        return Data(bytes: &value, count: MemoryLayout<Self>.size)
    }
}
