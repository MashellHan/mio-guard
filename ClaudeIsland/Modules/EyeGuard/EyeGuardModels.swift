import Foundation

// MARK: - BreakEvent

/// Records a single break event, whether taken or skipped.
struct BreakEvent: Codable, Sendable, Identifiable {
    let id: UUID
    let timestamp: Date
    let type: BreakType
    let wasTaken: Bool
    let actualDuration: TimeInterval

    init(
        id: UUID = UUID(),
        timestamp: Date = .now,
        type: BreakType,
        wasTaken: Bool,
        actualDuration: TimeInterval = 0
    ) {
        self.id = id
        self.timestamp = timestamp
        self.type = type
        self.wasTaken = wasTaken
        self.actualDuration = actualDuration
    }
}

// MARK: - UsageSession

struct UsageSession: Codable, Sendable, Identifiable {
    let id: UUID
    let startTime: Date
    let endTime: Date?
    let activeTime: TimeInterval
    let breaks: [BreakEvent]

    init(
        id: UUID = UUID(),
        startTime: Date = .now,
        endTime: Date? = nil,
        activeTime: TimeInterval = 0,
        breaks: [BreakEvent] = []
    ) {
        self.id = id
        self.startTime = startTime
        self.endTime = endTime
        self.activeTime = activeTime
        self.breaks = breaks
    }

    func addingBreak(_ breakEvent: BreakEvent) -> UsageSession {
        UsageSession(
            id: id, startTime: startTime, endTime: endTime,
            activeTime: activeTime, breaks: breaks + [breakEvent]
        )
    }

    func ending(at time: Date = .now) -> UsageSession {
        UsageSession(
            id: id, startTime: startTime, endTime: time,
            activeTime: activeTime, breaks: breaks
        )
    }
}

// MARK: - HealthScore

/// Composite health score for a given day, scored 0-100.
struct HealthScore: Codable, Sendable {
    let totalScore: Int
    let breakCompliance: Int
    let continuousUseDiscipline: Int
    let screenTimeScore: Int
    let breakQuality: Int

    init(
        breakCompliance: Int,
        continuousUseDiscipline: Int,
        screenTimeScore: Int,
        breakQuality: Int
    ) {
        self.breakCompliance = min(max(breakCompliance, 0), 40)
        self.continuousUseDiscipline = min(max(continuousUseDiscipline, 0), 30)
        self.screenTimeScore = min(max(screenTimeScore, 0), 20)
        self.breakQuality = min(max(breakQuality, 0), 10)
        self.totalScore = self.breakCompliance
            + self.continuousUseDiscipline
            + self.screenTimeScore
            + self.breakQuality
    }
}

// MARK: - UserPreferences

struct UserPreferences: Codable, Sendable {
    var microBreakInterval: TimeInterval
    var microBreakDuration: TimeInterval
    var macroBreakInterval: TimeInterval
    var macroBreakDuration: TimeInterval
    var mandatoryBreakInterval: TimeInterval
    var mandatoryBreakDuration: TimeInterval
    var isMicroBreakEnabled: Bool
    var isMacroBreakEnabled: Bool
    var isMandatoryBreakEnabled: Bool
    var isSoundEnabled: Bool
    var isEscalationEnabled: Bool
    var reminderMode: ReminderMode

    var activeProfile: ReminderModeProfile {
        reminderMode.profile()
    }

    static let `default` = UserPreferences(
        microBreakInterval: EyeGuardConstants.microBreakInterval,
        microBreakDuration: EyeGuardConstants.microBreakDuration,
        macroBreakInterval: EyeGuardConstants.macroBreakInterval,
        macroBreakDuration: EyeGuardConstants.macroBreakDuration,
        mandatoryBreakInterval: EyeGuardConstants.mandatoryBreakInterval,
        mandatoryBreakDuration: EyeGuardConstants.mandatoryBreakDuration,
        isMicroBreakEnabled: true,
        isMacroBreakEnabled: true,
        isMandatoryBreakEnabled: true,
        isSoundEnabled: true,
        isEscalationEnabled: true,
        reminderMode: EyeGuardConstants.defaultReminderMode
    )
}
