import SwiftUI

struct BreakPopUpView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var listViewModel: ListViewModel
    @State private var navigateToNextView: Bool = false
    @State private var navigateToBacktView: Bool = false

    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .topLeading) {
                
                Color.black.opacity(0.8)
                    .ignoresSafeArea()

                VStack(spacing: 20) {
                    
                    
                
                        
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.white)
                            .padding(20)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)

                   
                    HStack {
                        Button {
                            navigateToNextView.toggle()
                        } label: {
                            Image(systemName: "gearshape.fill")
                                .font(.title3)
                                .foregroundColor(.white)
                        }

                        
                        Text("残り休憩時間: \(listViewModel.formattedIntervalTime())")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.vertical, 30)
                    }
                    
                    HStack(spacing: 10) {
                        
                        Button("再開") {
                            listViewModel.restartTimer()
                        }
                        .frame(width: 90, height: 50)
                        .background(Color.yellow)
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                        Button("止める") {
                            listViewModel.stopIntervalTimer()
                        }
                        .frame(width: 90, height: 50)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                        
                        Button("スキップ") {
                            listViewModel.skipBreak()
                            dismiss()

                        }
                        .frame(width: 100, height: 50)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                    }
                    
                    HStack(spacing: 10) {
                        Button("-1 min") {
                            listViewModel.decreaseTimerMin()
                        }
                        .frame(width: 70, height: 50)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                        
                        Button("-10s") {
                            listViewModel.decreaseTimerSec()
                        }
                        .frame(width: 70, height: 50)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                        
                        Button("+10s") {
                            listViewModel.increaseTimerSec()
                        }
                        .frame(width: 70, height: 50)
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                        
                        Button("+1 min") {
                            listViewModel.increaseTimerMin()
                        }
                        .frame(width: 70, height: 50)
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                    }
                    .padding(.horizontal, 10)
                    
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top) 
                
            }
            .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("DismissBreakSheet"))) { _ in
                            dismiss()
                        }

            
            .navigationDestination(isPresented: $navigateToNextView) {
                SelectBreakTImeView()
            }
            .navigationBarBackButtonHidden(true)
        }
    }
}


#Preview {
    
    NavigationStack{
        BreakPopUpView()
            .environmentObject(ListViewModel())

    }

}
