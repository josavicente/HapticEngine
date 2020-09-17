//
//  HapticEngineModel.swift
//  
//
//  Created by Josafat Vicente Pérez on 17/09/2020.
//

import Foundation
import CoreHaptics

struct HapticEvent {
    var tap : Vibration
    var type: CHHapticEvent.EventType
    var duration: Float
    
    init(tap: Vibration, type: CHHapticEvent.EventType, duration: Float){
        self.tap = tap
        self.type = type
        self.duration = duration
    }
}

enum Vibration : Int16, CaseIterable{
    case softSweet = 0
    case sweet = 1
    case softLow = 2
    case low = 3
    case softMedium = 4
    case medium = 5
    case softHigh = 6
    case high = 7
    case heavy = 8
    case metal = 9

    
    init(type: Int16){
        switch type {
        case 0:
            self = .softSweet
        case 1:
            self = .sweet
        case 2:
            self = .softLow
        case 3:
            self = .low
        case 4:
            self = .softMedium
        case 5:
            self = .medium
        case 6:
            self = .softHigh
        case 7:
            self = .high
        case 8:
            self = .heavy
        case 9:
            self = .metal
        default:
            self = .medium
            
        }
        
    }

    var description : String {
        switch self {
        case .softSweet:
            return NSLocalizedString("Soft Sweet", comment: "")
        case .sweet:
            return NSLocalizedString("Sweet", comment: "")
        case .softLow:
            return NSLocalizedString("Soft Low", comment: "")
        case .low:
            return NSLocalizedString("Low", comment: "")
        case .softMedium:
            return NSLocalizedString("Soft Medium", comment:"")
        case .medium:
            return NSLocalizedString("Medium", comment:"")
        case .softHigh:
            return NSLocalizedString("Soft High", comment:"")
        case .high:
            return NSLocalizedString("High", comment:"")
        case .heavy:
            return NSLocalizedString("Heavy", comment: "")
        case .metal:
            return NSLocalizedString("Metal", comment: "")
        }
    }
    
    var value : Float {
        switch self {
        case .softSweet:
            return 0.1
        case .sweet:
            return 0.2
        case .softLow:
            return 0.3
        case .low:
            return 0.4
        case .softMedium:
            return 0.5
        case .medium:
            return 0.6
        case .softHigh:
            return 0.7
        case .high:
            return 0.8
        case .heavy:
            return 0.9
        case .metal:
            return 1.0
        }
        
    }
    
}
