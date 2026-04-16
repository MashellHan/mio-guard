//
//  ApuMiniView.swift
//  MioGuard
//
//  Compact 30×30pt version of the Apu mascot for Notch display.
//  Retains core features: round body, eyes with pupil tracking, mouth.
//  Strips detail (ears, arms, legs, effects) for clarity at small size.
//

import SwiftUI

/// Compact Apu mascot for rendering inside the Notch bar.
struct ApuMiniView: View, MascotRenderable {

    let mascotId = "apu"
    let expression: MascotExpression
    var pupilOffset: CGSize = .zero

    var preferredSize: CGSize { CGSize(width: 90, height: 100) }
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
            // Closed eyes — horizontal lines
            HStack(spacing: spacing) {
                miniClosedEye
                miniClosedEye
            }
            .offset(y: eyeY)

        case .celebrating, .happy:
            // Happy squint
            HStack(spacing: spacing) {
                miniHappyEye
                miniHappyEye
            }
            .offset(y: eyeY)

        case .concerned, .tired:
            // Smaller, dimmer eyes
            HStack(spacing: spacing) {
                Circle()
                    .fill(Color(red: 0.17, green: 0.17, blue: 0.17).opacity(0.6))
                    .frame(width: 3.5, height: 3.5)
                Circle()
                    .fill(Color(red: 0.17, green: 0.17, blue: 0.17).opacity(0.6))
                    .frame(width: 3.5, height: 3.5)
            }
            .offset(
                x: pupilOffset.width * 0.15,
                y: eyeY + pupilOffset.height * 0.15
            )

        default:
            // Normal eyes with highlight
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
                .fill(Color(red: 0.17, green: 0.17, blue: 0.17))
                .frame(width: 4, height: 4)
            Circle()
                .fill(Color.white.opacity(0.85))
                .frame(width: 1.5, height: 1.5)
                .offset(x: -0.5, y: -0.5)
        }
    }

    private var miniClosedEye: some View {
        RoundedRectangle(cornerRadius: 0.5)
            .fill(Color(red: 0.25, green: 0.25, blue: 0.25))
            .frame(width: 4, height: 1)
    }

    private var miniHappyEye: some View {
        MiniHappyArc()
            .stroke(Color(red: 0.17, green: 0.17, blue: 0.17), lineWidth: 1)
            .frame(width: 4, height: 2)
    }

    // MARK: - Mouth

    @ViewBuilder
    private var miniMouth: some View {
        let y: CGFloat = 3.5

        switch expression {
        case .celebrating, .happy:
            MiniSmileArc()
                .stroke(Color(red: 0.42, green: 0.61, blue: 0.50), lineWidth: 1)
                .frame(width: 5, height: 2.5)
                .offset(y: y)
        case .concerned, .tired:
            RoundedRectangle(cornerRadius: 0.5)
                .fill(Color(red: 0.42, green: 0.61, blue: 0.50).opacity(0.5))
                .frame(width: 3, height: 0.8)
                .offset(y: y)
        default:
            MiniSmileArc()
                .stroke(Color(red: 0.42, green: 0.61, blue: 0.50), lineWidth: 0.8)
                .frame(width: 4, height: 2)
                .offset(y: y)
        }
    }

    // MARK: - Colors

    private var bodyColor: Color {
        switch expression {
        case .concerned, .tired:
            Color(red: 0.82, green: 0.85, blue: 0.80)
        case .alert:
            Color(red: 0.96, green: 0.85, blue: 0.80)
        case .celebrating, .happy:
            Color(red: 0.78, green: 0.93, blue: 0.82)
        case .sleeping:
            Color(red: 0.78, green: 0.85, blue: 0.90)
        default:
            Color(red: 0.72, green: 0.90, blue: 0.82)
        }
    }

    private var bodyEdgeColor: Color {
        switch expression {
        case .concerned, .tired:
            Color(red: 0.70, green: 0.73, blue: 0.68)
        case .celebrating, .happy:
            Color(red: 0.60, green: 0.85, blue: 0.68)
        default:
            Color(red: 0.56, green: 0.83, blue: 0.71)
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
