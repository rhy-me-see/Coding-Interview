//
//  Item.swift
//  CTPractice
//
//  Created by Ruohua Yin on 3/23/25.
//

import Foundation

class TimerInfo: Identifiable {
    var id: Int
    var time: Double = 0.0
    var timer: Timer?
    var isPaused: Bool = false
    
    init(_ id: Int) {
        self.id = id
    }
}
