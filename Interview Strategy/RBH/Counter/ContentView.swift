
import SwiftUI

struct ContentView: View {
    
    @StateObject private var viewModel = TimersViewModel()
    
    var body: some View {
        List(0..<50, id: \.self) { index in
            TimerRow(id: index, viewModel: viewModel)
        }
    }
}

struct TimerRow: View {
    let id: Int
    @ObservedObject var viewModel: TimersViewModel
    @State var shouldBlink = false
    
    var body: some View {
        let timer = viewModel.timers[id]
        HStack {
            let formattedDouble = timer?.time != nil ? String(format: "%.2f", timer!.time) : "0.0"
            Text("Row:\(id) - Time: \(formattedDouble)s")
            Spacer()
            Circle()
                .frame(width: 10.0, height: 10.0)
                .foregroundColor(.red)
                .opacity(shouldBlink ? 0.3: 1.0)
                .animation(shouldBlink ? .easeInOut(duration: 0.5).repeatForever(autoreverses: true): .none, value: shouldBlink)
        }
        .padding()
        .background(timer?.isPaused == true ? Color.yellow.opacity(0.3): Color.clear)
        .onAppear {
            DispatchQueue.main.async {
                shouldBlink = true
                viewModel.startTimer(for: id)
            }
        }
        .onDisappear {
            viewModel.stopTimer(for: id)
        }
        .onTapGesture {
            shouldBlink.toggle()
            viewModel.pauseTimer(for: id)
        }
    }
}

#Preview {
    ContentView()
}
