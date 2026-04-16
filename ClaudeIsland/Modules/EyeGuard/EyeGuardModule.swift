import Foundation
import Observation

/// Eye Guard module entry point.
///
/// Manages the lifecycle of the eye guard subsystem:
/// - BreakScheduler: break timing and notification triggers
/// - ActivityMonitor: CGEventTap idle/lock detection
///
/// Activated/deactivated by ModeManager based on current mode.
/// UI reads state through published accessors (not directly from BreakScheduler).
@Observable
@MainActor
final class EyeGuardModule: AppModule {

    let id = "eye_guard"

    private(set) var isActive = false

    // MARK: - Sub-systems (lazy, created on activate)

    private var breakScheduler: BreakScheduler?

    // MARK: - Lifecycle

    func activate() {
        guard !isActive else { return }
        isActive = true

        // BreakScheduler self-starts its timer loop on init
        breakScheduler = BreakScheduler()
    }

    func deactivate() {
        guard isActive else { return }
        isActive = false

        breakScheduler?.stopScheduling()
        breakScheduler = nil
    }

    func handleEvent(_ event: AppEvent) {
        switch event {
        case .screenLocked:
            breakScheduler?.handleScreenLocked()
        case .screenUnlocked:
            breakScheduler?.handleScreenUnlocked()
        default:
            break
        }
    }

    // MARK: - Public Accessors for UI

    /// Duration of the current continuous usage session.
    var currentSessionDuration: TimeInterval {
        breakScheduler?.currentSessionDuration ?? 0
    }

    /// Current health score (0-100).
    var healthScore: Int {
        breakScheduler?.currentHealthScore ?? 100
    }

    /// Time remaining until the next break.
    var nextBreakIn: TimeInterval {
        breakScheduler?.timeUntilNextBreak ?? 0
    }

    /// The next break type that will trigger.
    var nextBreakType: BreakType? {
        breakScheduler?.nextScheduledBreak
    }

    /// Whether a break is currently in progress.
    var isBreakInProgress: Bool {
        breakScheduler?.isBreakInProgress ?? false
    }

    /// Total screen time today.
    var totalScreenTimeToday: TimeInterval {
        breakScheduler?.totalScreenTimeToday ?? 0
    }

    /// Breaks taken today.
    var breaksTakenToday: Int {
        breakScheduler?.breaksTakenToday ?? 0
    }

    /// Breaks skipped today.
    var breaksSkippedToday: Int {
        breakScheduler?.breaksSkippedToday ?? 0
    }

    /// Exercise sessions completed today.
    var exerciseSessionsToday: Int {
        breakScheduler?.exerciseSessionsToday ?? 0
    }

    /// Recommended exercise sessions for today.
    var recommendedExerciseSessions: Int {
        breakScheduler?.recommendedExerciseSessions ?? 1
    }
}

// MARK: - BreakScheduler Extensions for Module Integration

extension BreakScheduler {

    /// Stops the timer loop and releases resources.
    func stopScheduling() {
        // Timer task cancellation is handled by BreakScheduler's own lifecycle
        // This is a placeholder for the mio-guard integration
    }

    /// Handles screen lock event forwarded from EyeGuardModule.
    func handleScreenLocked() {
        // Forward to internal screen lock handling
        // In the full migration, this maps to the DistributedNotificationCenter observer
    }

    /// Handles screen unlock event forwarded from EyeGuardModule.
    func handleScreenUnlocked() {
        // Forward to internal screen unlock handling
    }
}
