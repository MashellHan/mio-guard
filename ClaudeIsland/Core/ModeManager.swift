//
//  ModeManager.swift
//  MioGuard
//
//  Manages the app's operating mode: Eye Guard, Island, or Dual.
//  Persists user preference via UserDefaults.
//

import Foundation
import SwiftUI

/// The app's operating modes.
enum AppMode: String, CaseIterable, Identifiable {
    case eyeGuard = "eye_guard"
    case island = "island"
    case dual = "dual"

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .eyeGuard: "Eye Guard"
        case .island: "Island"
        case .dual: "Dual"
        }
    }

    var icon: String {
        switch self {
        case .eyeGuard: "shield.lefthalf.filled"
        case .island: "sparkle"
        case .dual: "rectangle.split.2x1"
        }
    }
}

/// Manages app mode switching, persistence, and feature enablement.
@MainActor
@Observable
final class ModeManager {

    // MARK: - Properties

    /// The currently active mode.
    private(set) var currentMode: AppMode

    /// Whether the Eye Guard module is active.
    var isEyeGuardEnabled: Bool {
        currentMode == .eyeGuard || currentMode == .dual
    }

    /// Whether the Island module is active.
    var isIslandEnabled: Bool {
        currentMode == .island || currentMode == .dual
    }

    /// Callback fired after mode changes.
    var onModeChanged: ((AppMode) -> Void)?

    // MARK: - Keys

    private enum Keys {
        static let mode = "mioguard.mode"
    }

    // MARK: - Init

    init() {
        if let raw = UserDefaults.standard.string(forKey: Keys.mode),
           let saved = AppMode(rawValue: raw) {
            self.currentMode = saved
        } else {
            self.currentMode = .dual
        }
    }

    // MARK: - Mode Switching

    /// Switch to a new mode with optional animation.
    func switchMode(to mode: AppMode) {
        guard mode != currentMode else { return }
        currentMode = mode
        UserDefaults.standard.set(mode.rawValue, forKey: Keys.mode)
        onModeChanged?(mode)
    }

    /// Cycle to the next mode in order: eyeGuard → island → dual → eyeGuard.
    func cycleMode() {
        let modes = AppMode.allCases
        guard let index = modes.firstIndex(of: currentMode) else { return }
        let next = modes[(index + 1) % modes.count]
        switchMode(to: next)
    }
}
