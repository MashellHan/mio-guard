import Foundation

/// Protocol for activity monitoring, enabling testability via dependency injection.
protocol ActivityMonitoring: Sendable {
    var isIdle: Bool { get async }
    var isScreenLocked: Bool { get async }
    func startMonitoring() async
    func stopMonitoring() async
    func resetState() async
}

/// Protocol for notification delivery.
protocol NotificationSending: Sendable {
    var isNotificationActive: Bool { get }

    func notify(
        breakType: BreakType,
        behavior: BreakBehavior,
        escalation: EscalationStrategy,
        healthScore: Int,
        onTaken: @escaping @Sendable () -> Void,
        onSkipped: @escaping @Sendable () -> Void,
        onPostponed: @escaping @Sendable (TimeInterval) -> Void,
        exerciseSessionsToday: Int,
        recommendedExerciseSessions: Int,
        onStartExercises: (@Sendable () -> Void)?
    )
}

/// Protocol for sound playback.
protocol SoundPlaying: Sendable {
    func playSound(_ name: String)
    func speak(_ text: String, language: String)
    func stopSpeaking()
    func startAmbient()
    func stopAmbient()
}

extension SoundPlaying {
    func speak(_ text: String) { speak(text, language: "zh-CN") }
}
