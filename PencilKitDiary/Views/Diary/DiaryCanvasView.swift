import SwiftUI
import PencilKit

/// PencilKit キャンバスの UIViewRepresentable ラッパー（UC 4-6）
struct DiaryCanvasView: UIViewRepresentable {
    @Binding var drawing: PKDrawing
    @Binding var toolPickerVisible: Bool
    var background: CanvasBackground
    var onDrawingChanged: () -> Void

    func makeUIView(context: Context) -> PKCanvasView {
        let canvasView = PKCanvasView()
        canvasView.delegate = context.coordinator
        canvasView.drawingPolicy = .anyInput
        canvasView.drawing = drawing
        canvasView.backgroundColor = .clear
        canvasView.isOpaque = false
        canvasView.tool = PKInkingTool(.pen, color: .label, width: 3)

        // ツールピッカーの設定（UC 5）
        let toolPicker = PKToolPicker()
        context.coordinator.toolPicker = toolPicker
        toolPicker.setVisible(toolPickerVisible, forFirstResponder: canvasView)
        toolPicker.addObserver(canvasView)
        canvasView.becomeFirstResponder()

        return canvasView
    }

    func updateUIView(_ canvasView: PKCanvasView, context: Context) {
        if canvasView.drawing != drawing {
            canvasView.drawing = drawing
        }

        if let toolPicker = context.coordinator.toolPicker {
            toolPicker.setVisible(toolPickerVisible, forFirstResponder: canvasView)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, PKCanvasViewDelegate {
        var parent: DiaryCanvasView
        var toolPicker: PKToolPicker?

        init(_ parent: DiaryCanvasView) {
            self.parent = parent
        }

        /// 描画が変更されたときに呼ばれる（UC 4, 6）
        func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
            parent.drawing = canvasView.drawing
            parent.onDrawingChanged()
        }
    }
}
