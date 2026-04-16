import Foundation

// MARK: - Notification Tier

enum NotificationTier: String, Codable, Sendable, CaseIterable, Comparable {
    case system
    case floating
    case fullScreen

    static func < (lhs: NotificationTier, rhs: NotificationTier) -> Bool {
        lhs.sortOrder < rhs.sortOrder
    }

    private var sortOrder: Int {
        switch self {
        case .system:     return 0
        case .floating:   return 1
        case .fullScreen: return 2
        }
    }
}

// MARK: - Dismiss Policy

enum DismissPolicy: Codable, Sendable, Equatable {
    case skippable
    case postponeOnly(maxCount: Int)
    case mandatory
}

// MARK: - Escalation Strategy

enum EscalationStrategy: Codable, Sendable, Equatable {
    case tiered(tier1Delay: TimeInterval, tier2Delay: TimeInterval)
    case direct
}

// MARK: - Break Behavior

struct BreakBehavior: Codable, Sendable {
    var interval: TimeInterval
    var duration: TimeInterval
    var isEnabled: Bool
    var entryTier: NotificationTier
    var dismissPolicy: DismissPolicy
}

// MARK: - Reminder Mode Profile

struct ReminderModeProfile: Codable, Sendable {
    var microBreak: BreakBehavior
    var macroBreak: BreakBehavior
    var mandatoryBreak: BreakBehavior
    var escalationStrategy: EscalationStrategy

    func behavior(for breakType: BreakType) -> BreakBehavior {
        switch breakType {
        case .micro:     return microBreak
        case .macro:     return macroBreak
        case .mandatory: return mandatoryBreak
        }
    }
}

// MARK: - Reminder Mode

enum ReminderMode: String, Codable, Sendable, CaseIterable {
    case gentle
    case aggressive
    case strict
    case custom

    func profile() -> ReminderModeProfile {
        switch self {
        case .gentle:
            return ReminderModeProfile(
                microBreak: BreakBehavior(
                    interval: EyeGuardConstants.microBreakInterval,
                    duration: EyeGuardConstants.microBreakDuration,
                    isEnabled: true, entryTier: .system, dismissPolicy: .skippable
                ),
                macroBreak: BreakBehavior(
                    interval: EyeGuardConstants.macroBreakInterval,
                    duration: EyeGuardConstants.macroBreakDuration,
                    isEnabled: true, entryTier: .floating, dismissPolicy: .skippable
                ),
                mandatoryBreak: BreakBehavior(
                    interval: EyeGuardConstants.mandatoryBreakInterval,
                    duration: EyeGuardConstants.mandatoryBreakDuration,
                    isEnabled: true, entryTier: .fullScreen, dismissPolicy: .skippable
                ),
                escalationStrategy: .tiered(
                    tier1Delay: EyeGuardConstants.tier1EscalationDelay,
                    tier2Delay: EyeGuardConstants.tier2EscalationDelay
                )
            )

        case .aggressive:
            return ReminderModeProfile(
                microBreak: BreakBehavior(
                    interval: EyeGuardConstants.microBreakInterval,
                    duration: EyeGuardConstants.microBreakDuration,
                    isEnabled: true, entryTier: .fullScreen, dismissPolicy: .skippable
                ),
                macroBreak: BreakBehavior(
                    interval: EyeGuardConstants.macroBreakInterval,
                    duration: EyeGuardConstants.macroBreakDuration,
                    isEnabled: true, entryTier: .fullScreen, dismissPolicy: .skippable
                ),
                mandatoryBreak: BreakBehavior(
                    interval: EyeGuardConstants.mandatoryBreakInterval,
                    duration: EyeGuardConstants.mandatoryBreakDuration,
                    isEnabled: true, entryTier: .fullScreen,
                    dismissPolicy: .postponeOnly(maxCount: 2)
                ),
                escalationStrategy: .direct
            )

        case .strict:
            return ReminderModeProfile(
                microBreak: BreakBehavior(
                    interval: EyeGuardConstants.microBreakInterval,
                    duration: EyeGuardConstants.microBreakDuration,
                    isEnabled: true, entryTier: .fullScreen, dismissPolicy: .mandatory
                ),
                macroBreak: BreakBehavior(
                    interval: EyeGuardConstants.macroBreakInterval,
                    duration: EyeGuardConstants.macroBreakDuration,
                    isEnabled: true, entryTier: .fullScreen,
                    dismissPolicy: .postponeOnly(maxCount: 2)
                ),
                mandatoryBreak: BreakBehavior(
                    interval: EyeGuardConstants.mandatoryBreakInterval,
                    duration: EyeGuardConstants.mandatoryBreakDuration,
                    isEnabled: true, entryTier: .fullScreen, dismissPolicy: .mandatory
                ),
                escalationStrategy: .direct
            )

        case .custom:
            return ReminderMode.aggressive.profile()
        }
    }
}
