//
//  ApuMiniView.swift
//  MioGuard
//
//  Compact 30×30pt version of the Apu mascot for Notch display.
//  Retains core features: round body, eyes with pupil tracking, mouth.
//  Strips detail (arms, legs, effects) for clarity at small size.
//

import SwiftUI

/// Compact Apu mascot for rendering inside the Notch bar.
struct ApuMiniView: View, MascotRenderable {

    let mascotId = "apu"
    let expression: MascotExpression
    var pupilOffset: CGSize = .zero

    /// Full-size Apu dimensions (used by MascotContainer for .floating mode).
    var preferredSize: CGSize { CGSize(width: 120, height: 120) }
    var supportsNotchMode: Bool { true }

    /// Mini body size (fits in ~30pt container).
    private let bodySize: CGFloat = 22

    var body: some View {
        ZStack {
            // Body
            Circle()
                .fill(
                    LinearGradient(
                        colors: [bodyColor, bodyEdgeColor],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(width: bodySize, height: bodySize)
                .shadow(color: .black.opacity(0.08), radius: 2, y: 1)

            // Small ears
            miniEars

            // Eyes
            miniEyes

            // Mouth
            miniMouth
        }
    }

    // MARK: - Ears

    private var miniEars: some View {
        HStack(spacing: bodySize - 2) {
            Circle()
                .fill(bodyEdgeColor)
                .frame(width: 5, height: 5)
                .offset(y: -bodySize / 2 + 1)

            Circle()
                .fill(bodyEdgeColor)
                .frame(width: 5, height: 5)
                .offset(y: -bodySize / 2 + 1)
        }
    }

    // MARK: - Eyes

    @ViewBuilder
    private var miniEyes: some View {
        let eyeY: CGFloat = -2
        let spacing: CGFloat = 6

        switch expression {
        case .sleeping:
            HStack(spacing: spacing) {
                miniClosedEye
                miniClosedEye
            }
            .offset(y: eyeY)

        case .celebrating, .happy:
            HStack(spacing: spacing) {
                miniHappyEye
                miniHappyEye
            }
            .offset(y: eyeY)

        case .concerned, .tired:
            HStack(spacing: spacing) {
                Circle()
                    .fill(ApuColors.eye.opacity(0.6))
                    .frame(width: 3.5, height: 3.5)
                Circle()
                    .fill(ApuColors.eye.opacity(0.6))
                    .frame(width: 3.5, height: 3.5)
            }
            .offset(
                x: pupilOffset.width * 0.15,
                y: eyeY + pupilOffset.height * 0.15
            )

        default:
            HStack(spacing: spacing) {
                miniNormalEye
                miniNormalEye
            }
            .offset(
                x: pupilOffset.width * 0.15,
                y: eyeY + pupilOffset.height * 0.15
            )
        }
    }

    private var miniNormalEye: some View {
        ZStack {
            Circle()
                .fill(ApuColors.eye)
                .frame(width: 4, height: 4)
            Circle()
                .fill(ApuColors.eyeHighlight)
                .frame(width: 1.5, height: 1.5)
                .offset(x: -0.5, y: -0.5)
        }
    }

    private var miniClosedEye: some View {
        RoundedRectangle(cornerRadius: 0.5)
            .fill(ApuColors.eyeClosed)
            .frame(width: 4, height: 1)
    }

    private var miniHappyEye: some View {
        MiniHappyArc()
            .stroke(ApuColors.eye, lineWidth: 1)
            .frame(width: 4, height: 2)
    }

    // MARK: - Mouth

    @ViewBuilder
    private var miniMouth: some View {
        let y: CGFloat = 3.5

        switch expression {
        case .celebrating, .happy:
            MiniSmileArc()
                .stroke(ApuColors.mouth, lineWidth: 1)
                .frame(width: 5, height: 2.5)
                .offset(y: y)
        case .concerned, .tired:
            RoundedRectangle(cornerRadius: 0.5)
                .fill(ApuColors.mouth.opacity(0.5))
                .frame(width: 3, height: 0.8)
                .offset(y: y)
        default:
            MiniSmileArc()
                .stroke(ApuColors.mouth, lineWidth: 0.8)
                .frame(width: 4, height: 2)
                .offset(y: y)
        }
    }

    // MARK: - Body Colors

    private var bodyColor: Color {
        switch expression {
        case .concerned, .tired: ApuColors.concernedBody
        case .alert: ApuColors.alertBody
        case .celebrating, .happy: ApuColors.celebratingBody
        case .sleeping: ApuColors.sleepingBody
        default: ApuColors.body
        }
    }

    private var bodyEdgeColor: Color {
        switch expression {
        case .concerned, .tired: ApuColors.concernedEdge
        case .celebrating, .happy: ApuColors.celebratingEdge
        default: ApuColors.bodyEdge
        }
    }
}

// MARK: - Mini Shapes

private struct MiniSmileArc: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        p.move(to: CGPoint(x: rect.minX, y: rect.minY))
        p.addQuadCurve(
            to: CGPoint(x: rect.maxX, y: rect.minY),
            control: CGPoint(x: rect.midX, y: rect.maxY)
        )
        return p
    }
}

private struct MiniHappyArc: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        p.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        p.addQuadCurve(
            to: CGPoint(x: rect.maxX, y: rect.maxY),
            control: CGPoint(x: rect.midX, y: rect.minY)
        )
        return p
    }
}
