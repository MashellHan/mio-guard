import Foundation

// MARK: - AppModule Protocol

/// Protocol for modular subsystems that can be activated/deactivated
/// based on the current mode (Eye Guard / Island / Dual).
@MainActor
protocol AppModule: AnyObject {
    var id: String { get }
    var isActive: Bool { get }
    func activate()
    func deactivate()
    func handleEvent(_ event: AppEvent)
}

// MARK: - AppEvent

/// Unified event bus for cross-module communication.
enum AppEvent: Sendable {
    case screenLocked
    case screenUnlocked
    case modeChanged(AppMode)
    case breakTriggered(BreakType)
    case breakCompleted(BreakType)
    case breakSkipped(BreakType)
    case idleDetected
    case activityResumed
    case healthScoreUpdated(Int)
}
