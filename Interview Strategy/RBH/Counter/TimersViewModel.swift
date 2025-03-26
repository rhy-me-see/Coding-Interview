//
//  TimersViewModel.swift
//  CTPractice
//
//  Created by Ruohua Yin on 3/24/25.
//

import SwiftUI

class TimersViewModel: ObservableObject {
    
    @Published var timers: [Int: TimerInfo] = [:]
    
    func startTimer(for id: Int) {
        if timers[id] == nil {
            timers[id] = TimerInfo(id)
        }
        
        guard timers[id]!.isPaused == false else { return }
        
        timers[id]?.timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { [weak self] _ in
            self?.timers[id]?.time += 0.1
            self?.objectWillChange.send()
        })
    }
    
    func stopTimer(for id: Int) {
        timers[id]?.timer?.invalidate()
        timers[id]?.timer = nil
    }
    
    func pauseTimer(for id: Int) {
        guard timers[id] != nil else { return }
        timers[id]?.isPaused.toggle()
        if timers[id]!.isPaused {
            stopTimer(for: id)
        } else {
            startTimer(for: id)
        }
    }
}
