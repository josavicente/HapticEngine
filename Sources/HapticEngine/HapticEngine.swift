//
//  HapticEngine.swift

//  Created by Josafat Vicente Pérez on 16/09/2020.
#if canImport(Combine)
#if canImport(CoreHaptics)
#if canImport(SwiftUI)

import Combine
import CoreHaptics
import SwiftUI

public final class HapticEngine  : ObservableObject {
    
    private var engine: CHHapticEngine?
    private var toRestart = false
    
    public init() {
        engine = try? CHHapticEngine()
        engine?.resetHandler = resetEngine
        engine?.stoppedHandler = restartEngine
        engine?.playsHapticsOnly = true
        try? prepareHaptics()
    }
    
    public func start() throws {
        try engine?.start()
        toRestart = false
    }
    
    private func resetEngine() {
        do {
            try prepareHaptics()
        } catch {
            toRestart = true
        }
    }
    func prepareHaptics() throws {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        
        do {
            self.engine = try CHHapticEngine()
            try start()
        } catch {
            print("There was an error creating the engine: \(error.localizedDescription)")
        }
    }
    
    private func restartEngine(_ reasonForStopping: CHHapticEngine.StoppedReason? = nil) {
        resetEngine()
    }
    
    // Simple feedback
    func simpleSuccess() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    
    func ascendingSuccess() {
        // make sure that the device supports haptics
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        var events = [CHHapticEvent]()
        
        for i in stride(from: 0, to: 1, by: 0.1) {
            let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: Float(i))
            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: Float(i))
            let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: i)
            events.append(event)
        }
        
        // convert those events into a pattern and play it immediately
        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Failed to play pattern: \(error.localizedDescription).")
        }
    }
    func descendingSucces(){
        // make sure that the device supports haptics
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        var events = [CHHapticEvent]()
        
        for i in stride(from: 0, to: 1, by: 0.1) {
            let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: Float(1 - i))
            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: Float(1 - i))
            let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 1 + i)
            events.append(event)
        }
        
        // convert those events into a pattern and play it immediately
        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Failed to play pattern: \(error.localizedDescription).")
        }
    }
    func complexSuccess() {
        // make sure that the device supports haptics
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        var events = [CHHapticEvent]()
        
        
        for i in stride(from: 0, to: 1, by: 0.1) {
            let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: Float(i))
            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: Float(i))
            let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: i)
            events.append(event)
        }
        
        for i in stride(from: 0, to: 1, by: 0.1) {
            let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: Float(1 - i))
            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: Float(1 - i))
            let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 1 + i)
            events.append(event)
        }
        
        // convert those events into a pattern and play it immediately
        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Failed to play pattern: \(error.localizedDescription).")
        }
    }
    
    public func launch(intensity: Float = 0.75, sharpness: Float = 0.75) throws {
        let ev = CHHapticEvent(
            eventType: .hapticTransient,
            parameters: [
                CHHapticEventParameter(parameterID: .hapticIntensity, value: intensity),
                CHHapticEventParameter(parameterID: .hapticSharpness, value: sharpness)
            ],
            relativeTime: 0)
        let pattern = try CHHapticPattern(events: [ev], parameters: [])
        let player = try engine?.makePlayer(with: pattern)
        if toRestart {
            try? start()
        }
        try player?.start(atTime: CHHapticTimeImmediate)
    }
    
    func getRelativeTime(touches: [HapticEvent], index: Int) -> Float {
        var relativeTime : Float = 0.0
        for i in 1..<index {
            relativeTime += (touches[i].tap.value + touches[i].duration)
        }
        return relativeTime
    }
    
    func customHapticGenerator(touches: [HapticEvent]) -> [CHHapticEvent]{
        
        
        var events : [CHHapticEvent] = []
        
        for i in 0..<touches.count{
            switch touches[i].type {
            case .hapticTransient:
                events.append(CHHapticEvent(eventType: touches[i].type, parameters: [], relativeTime: TimeInterval(self.getRelativeTime(touches: touches, index: i))))
            case .hapticContinuous:
                events.append(CHHapticEvent(eventType: touches[i].type, parameters: [], relativeTime: TimeInterval(self.getRelativeTime(touches: touches, index: i)), duration: TimeInterval(touches[i].duration)))
            case .audioCustom:
                print("audio custom")
            case .audioContinuous:
                print("audio continuous")
            default:
                events.append(CHHapticEvent(eventType: .hapticTransient, parameters: [], relativeTime: 0.2))
            }
        }
        
        return events
        
    }
    
    func customSuccess(events: [CHHapticEvent]){
        
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        
        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Failed to play pattern: \(error.localizedDescription).")
        }
    }
    
}

#endif
#endif
#endif
