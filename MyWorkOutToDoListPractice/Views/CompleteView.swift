import SwiftUI

struct CompleteView: View {
    
    @EnvironmentObject var listViewModel: ListViewModel
    @State var textField: String = ""
    @State private var navigateToNextView: Bool = false
    
    var completedExercises: [ItemModel] {
        listViewModel.items.filter { $0.isCompleted && $0.setCount - 1 > 0 }
    }
    
    var body: some View {
        VStack { // 🟢 Wrap the entire UI in a VStack
            ScrollView {
                VStack {
                    // 🎉 Training Completion Header
                    HStack {
                        Text("🎉トレーニング終了")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .padding(.top, 70)
                        
                        Image(systemName: "checkmark.seal.fill")
                            .font(.largeTitle)
                            .foregroundStyle(.blue)
                            .padding(.top, 70)
                    }
                    
                    // 📌 Workout Completion Time
                    Text("今日のトレーニング達成時間")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.top, 50)
                    
                    Text(formattedTime(listViewModel.secondsTime))
                        .font(.largeTitle)
                        .padding(.top, 30)
                    
                    // ✅ Completed Exercises Section
                    if !completedExercises.isEmpty {
                        Text("達成したエクササイズ")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.top, 30)
                        
                        ScrollView {
                            VStack(alignment: .leading, spacing: 10) {
                                ForEach(completedExercises) { item in
                                    HStack {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundColor(.green)
                                        Text(item.title)
                                            .font(.headline)
                                            .foregroundColor(.black)
                                        Spacer()
                                        Text("セット数: \(item.setCount - 1)")
                                            .font(.subheadline)
                                    }
                                    .padding()
                                    .background(Color.orange)
                                    .cornerRadius(8)
                                    
                                    // Calculate total kg lifted
                                    let totalKg = item.sets.reduce(0) { total, set in
                                        (Double(set.kg) ?? 0) * (Double(set.reps) ?? 0) + total
                                    }
                                    
                                    Text("トータル重量: \(Int(totalKg)) kg")
                                        .font(.subheadline)
                                        .fontWeight(.bold)
                                        .padding(.bottom, 5)
                                    
                                    // Display each set's weight and reps
                                    ForEach(Array(item.sets.enumerated()), id: \.offset) { index, set in
                                        HStack {
                                            Text("セット \(index + 1):")
                                                .fontWeight(.bold)
                                            Text("\(set.kg) kg × \(set.reps) 回")
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                        .frame(maxHeight: 200) // Limit height for better UI
                    }
                    
                    // 🔵 Finish Button
                    Button {
                        navigateToNextView = true
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            listViewModel.prepareForReset()
                        }
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
                }
            }
        }
        // 🟢 Move navigationDestination OUTSIDE of ScrollView
        .navigationDestination(isPresented: $navigateToNextView) {
            NoItemView()
                .navigationBarBackButtonHidden(true)
        }
    }
    
    func formattedTime(_ seconds: Int) -> String {
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        let remainingSeconds = seconds % 60
        return String(format: "%02d時間:%02d分:%02d秒", hours, minutes, remainingSeconds)
    }
}

#Preview {
    CompleteView()
        .environmentObject(ListViewModel())
}

