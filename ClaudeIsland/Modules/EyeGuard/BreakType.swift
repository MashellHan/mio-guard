import Foundation

/// Categories of breaks based on medical guidelines.
enum BreakType: String, Codable, Sendable, CaseIterable {

    /// 20-20-20 rule: every 20 minutes, look at something 20 feet away for 20 seconds.
    case micro

    /// Hourly break: every 60 minutes, take a 5-10 minute break.
    case macro

    /// Mandatory break: every 120 minutes, take a 15 minute break.
    case mandatory

    var interval: TimeInterval {
        switch self {
        case .micro:     return EyeGuardConstants.microBreakInterval
        case .macro:     return EyeGuardConstants.macroBreakInterval
        case .mandatory: return EyeGuardConstants.mandatoryBreakInterval
        }
    }

    var duration: TimeInterval {
        switch self {
        case .micro:     return EyeGuardConstants.microBreakDuration
        case .macro:     return EyeGuardConstants.macroBreakDuration
        case .mandatory: return EyeGuardConstants.mandatoryBreakDuration
        }
    }

    var displayName: String {
        switch self {
        case .micro:     return "Micro Break"
        case .macro:     return "Macro Break"
        case .mandatory: return "Mandatory Break"
        }
    }

    var iconName: String {
        switch self {
        case .micro:     return "eye"
        case .macro:     return "cup.and.saucer"
        case .mandatory: return "figure.walk"
        }
    }

    /// Priority for break absorption: higher absorbs lower when due simultaneously.
    var priority: Int {
        switch self {
        case .micro:     return 0
        case .macro:     return 1
        case .mandatory: return 2
        }
    }
}
