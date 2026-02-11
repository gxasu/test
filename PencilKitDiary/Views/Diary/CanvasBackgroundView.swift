import SwiftUI

/// キャンバス背景の描画ビュー（UC 17）
struct CanvasBackgroundView: View {
    let background: CanvasBackground
    let lineColor: Color = .gray.opacity(0.3)
    let spacing: CGFloat = 20

    var body: some View {
        Canvas { context, size in
            switch background {
            case .plain:
                break

            case .grid:
                drawGrid(context: context, size: size)

            case .dot:
                drawDots(context: context, size: size)

            case .ruled:
                drawRuled(context: context, size: size)
            }
        }
    }

    private func drawGrid(context: GraphicsContext, size: CGSize) {
        // 縦線
        var x: CGFloat = spacing
        while x < size.width {
            var path = Path()
            path.move(to: CGPoint(x: x, y: 0))
            path.addLine(to: CGPoint(x: x, y: size.height))
            context.stroke(path, with: .color(lineColor), lineWidth: 0.5)
            x += spacing
        }
        // 横線
        var y: CGFloat = spacing
        while y < size.height {
            var path = Path()
            path.move(to: CGPoint(x: 0, y: y))
            path.addLine(to: CGPoint(x: size.width, y: y))
            context.stroke(path, with: .color(lineColor), lineWidth: 0.5)
            y += spacing
        }
    }

    private func drawDots(context: GraphicsContext, size: CGSize) {
        var x: CGFloat = spacing
        while x < size.width {
            var y: CGFloat = spacing
            while y < size.height {
                let rect = CGRect(x: x - 1.5, y: y - 1.5, width: 3, height: 3)
                context.fill(Path(ellipseIn: rect), with: .color(lineColor))
                y += spacing
            }
            x += spacing
        }
    }

    private func drawRuled(context: GraphicsContext, size: CGSize) {
        var y: CGFloat = spacing
        while y < size.height {
            var path = Path()
            path.move(to: CGPoint(x: 0, y: y))
            path.addLine(to: CGPoint(x: size.width, y: y))
            context.stroke(path, with: .color(lineColor), lineWidth: 0.5)
            y += spacing
        }
    }
}

#Preview("方眼紙") {
    CanvasBackgroundView(background: .grid)
        .frame(height: 300)
}

#Preview("ドット") {
    CanvasBackgroundView(background: .dot)
        .frame(height: 300)
}

#Preview("罫線") {
    CanvasBackgroundView(background: .ruled)
        .frame(height: 300)
}
