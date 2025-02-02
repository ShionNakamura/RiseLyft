import SwiftUI

struct CompleteView: View {
    
    @EnvironmentObject var listViewModel: ListViewModel
    @State var textField: String = ""
    @State private var navigateToNextView: Bool = false

    var body: some View {
        VStack {
            HStack {
                Text("トレーニング終了")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 70)
            Image(systemName: "checkmark.seal.fill")
                    .font(.largeTitle)
                    .foregroundStyle(.blue)
                    .padding(.top, 70)
            }
            
            Text("今日のトレーニング時間")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.top, 50)
            
            Text(formattedTime(listViewModel.secondsTime))
                .font(.largeTitle)
                .padding(.top, 30)
            Text("メモを取る")
                .font(.title2)
                .padding()
                .frame(maxWidth: .infinity,maxHeight: 40,alignment: .topLeading)


            noteSection
                .padding(.top, 10)
            
            Spacer()
            
            Button {
                navigateToNextView.toggle()
                listViewModel.resetTimer()
                listViewModel.showTime = false

            } label: {
                Text("完了")
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
            .navigationDestination(isPresented: $navigateToNextView) {
                ListView()
                    .navigationBarBackButtonHidden(true)
            }
            Spacer()

        }
    }
    
    private var noteSection: some View {
        
        VStack(alignment: .leading, spacing: 10) {
            
            TextField("Note", text: $textField,axis: .vertical)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.white)
                 .padding()
                 .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(maxWidth: 380, minHeight: 250,alignment: .topLeading)
        .background(Color.orange.opacity(0.9))
        .cornerRadius(10)
    }
    
    private func formattedTime(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return String(format: "%02d:%02d", minutes, remainingSeconds)
    }
}

#Preview {
    CompleteView()
        .environmentObject(ListViewModel())
}

