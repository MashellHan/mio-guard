//
//  PixelCatMascot.swift
//  MioGuard
//
//  Adapter that wraps the existing PixelCharacterView to conform
//  to MascotRenderable, enabling it to be used in the unified
//  MascotContainer alongside Apu.
//

import SwiftUI

/// Wraps PixelCharacterView as a MascotRenderable.
struct PixelCatMascot: View, MascotRenderable {

    let mascotId = "pixel_cat"
    let expression: MascotExpression

    var preferredSize: CGSize { CGSize(width: 80, height: 80) }
    var supportsNotchMode: Bool { true }

    var body: some View {
        PixelCharacterView(state: mapExpression(expression))
            .frame(width: PixelCharacterView.canvasW, height: PixelCharacterView.canvasH)
    }

    /// Maps unified MascotExpression to PixelCharacterView's AnimationState.
    private func mapExpression(_ expr: MascotExpression) -> AnimationState {
        switch expr {
        case .idle, .sleeping, .happy:
            .idle
        case .thinking, .exercising:
            .thinking
        case .alert, .encouraging:
            .needsYou
        case .concerned, .tired:
            .error
        case .celebrating:
            .done
        case .waiting:
            .idle
        }
    }
}
