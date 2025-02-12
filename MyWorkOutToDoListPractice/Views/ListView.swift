import SwiftUI
import UIKit

struct ListView: View {
    
    @EnvironmentObject var listViewModel: ListViewModel
    @State private var selectedCategory: String? = nil
    @State var navigateToBreakTimeView: Bool = false
    @State var navigateToNextView: Bool = false
    @State var showConfirmationAlert: Bool = false
    @State  var editMode: EditMode = .inactive  // ✅ Added edit mode state
    @State var isCollapsed: Bool = false
    var body: some View {
        NavigationStack {
            VStack(spacing: 15) {

                if !listViewModel.showTime && !listViewModel.items.isEmpty {
                    
                    Text(listViewModel.getFormattedDate())
                        .font(.title)
                        .padding()
                    
                    Spacer()
                    
                    Button {
                        withAnimation(.easeInOut) {
                            listViewModel.showTime.toggle()
                            listViewModel.startTimer()
                        }
                    } label: {
                        Text("トレーニングを始める")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.orange)
                            .cornerRadius(12)
                            .shadow(color: Color.orange.opacity(0.8), radius: 5)
                    }
                }
                
                // Training duration
                if listViewModel.showTime {
                    HStack {
                        VStack {
                            Text("トレーニング経過時間: \(formattedTime(listViewModel.secondsTime))")
                                .font(.headline)
                                .fontWeight(.bold)
                                .padding()
                            
                            HStack(spacing: 10) {
                                Button("再開") {
                                    listViewModel.startTimer()
                                }
                                .frame(width: 90, height: 50)
                                .background(Color.orange)
                                .foregroundColor(.white)
                                .clipShape(Capsule())
                                
                                Button("止める") {
                                    listViewModel.stopTimer()
                                }
                                .frame(width: 90, height: 50)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .clipShape(Capsule())
                                
                                Button("リセット") {
                                    listViewModel.resetTimer()
                                    listViewModel.showTime.toggle()
                                }
                                .frame(width: 90, height: 50)
                                .background(Color.red)
                                .foregroundColor(.white)
                                .clipShape(Capsule())
                            }
                        }
                    }
                }
                
                // Tab View
                TabView {
                    NavigationStack {
                        ZStack {
                            if listViewModel.items.isEmpty {
                                NoItemView()
                            } else {
                                List {
                                    ForEach(listViewModel.items) { item in
                                        VStack(alignment: .leading) {
                                            HStack {
                                                Spacer()
                                                ListRowView(item: item)
                                                    .font(.subheadline)
                                                    .fontWeight(.bold)
                                                    .frame(maxWidth: .infinity, alignment: .leading)
//                                                    .lineLimit(1)
//                                                    .minimumScaleFactor(0.5)
                                                    .onTapGesture {
                                                        withAnimation(.linear) {
                                                            listViewModel.updateItem(item: item)
                                                        }
                                                    }
                                                    
//                                                Spacer()
                                                
                                                // Set count + -
                                                HStack(spacing: 20) {
                                                    Text("セット数 \(item.setCount - 1)")
                                                        .font(.subheadline)
                                                    
                                                    HStack(spacing: 8) {
                                                        Image(systemName: "plus")
                                                            .font(.caption)
                                                            .foregroundColor(.blue)
                                                            .padding(8)
                                                            .onTapGesture {
                                                                listViewModel.increaseSetCount(for: item)
                                                            }
                                                    }
                                                    .padding(.horizontal, 6)
                                                    .background(RoundedRectangle(cornerRadius: 5).fill(Color.gray.opacity(0.2)))
                                                }
                                            }
                                            
                                            .padding()
                                            
                                           
                                            // For each set
                                            if !isCollapsed {
                                                ForEach(Array(item.sets.enumerated()), id: \.offset) { index, set in
                                                    SetInputView(item: item, setIndex: index)
                                                    
                                                    if index < item.sets.count - 1 {
                                                        Divider()
                                                            .padding(.vertical, 3)
                                                    }
                                                }
                                            }
                                        }
                                       
                                    }
                                    
                                    .onDelete(perform: listViewModel.deleteItem)
                                    .onMove(perform: listViewModel.moveItem)

                                    // ✅ Move enabled by edit mode
                                    
                                    if !listViewModel.items.isEmpty && listViewModel.showTime {
                                        VStack(spacing: 20) {
                                            HStack {
                                                if listViewModel.breakTime {
                                                    Button {
                                                        navigateToBreakTimeView.toggle()
                                                    }
                                                    label: {
                                                        Image(systemName: "info.circle.fill")
                                                            .font(.title3)
                                                    }
                                                    Text("残り休憩時間: \(listViewModel.formattedIntervalTime())")
                                                        .font(.headline)
                                                        .fontWeight(.bold)
                                                        .padding(.vertical, 30)
                                                        .navigationDestination(isPresented: $navigateToBreakTimeView) {
                                                            BreakPopUpView()
                                                                .navigationBarBackButtonHidden(true)
                                                        }
                                                }
                                            }
                                        }
                                        
                                        VStack(spacing: 10) {
                                            Button("終了") {
                                                listViewModel.stopTimer()
                                                showConfirmationAlert.toggle()
                                            }
                                            .foregroundStyle(.white)
                                            .font(.headline)
                                            .frame(height: 55)
                                            .frame(maxWidth: .infinity)
                                            .background(Color.green)
                                            .cornerRadius(10)
                                        }
                                        .navigationDestination(isPresented: $navigateToNextView) {
                                            CompleteView()
                                                .navigationBarBackButtonHidden(true)
                                        }
                                    }
                                }
                               
                                .alert(isPresented: $showConfirmationAlert) {
                                    Alert(
                                        title: Text("全ての種目終了"),
                                        primaryButton: .destructive(Text("終了")) {
                                            navigateToNextView.toggle()
                                        },
                                        secondaryButton: .cancel()
                                    )
                                }
                            }
                        }
                    }
                    .tabItem {
                        Image(systemName: "figure.strengthtraining.traditional")
                        Text("メニュー")
                    }
                     
                    
                }
                .accentColor(.orange)
                .navigationTitle(!listViewModel.showTime ? "トレーニングリスト🏋️‍♀️" : "トレーニング中")
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            editMode = editMode == .active ? .inactive : .active
                            isCollapsed.toggle()
                        }) {
                            Text(editMode == .active ? "完了" : "編集")
//                                .foregroundColor(.orange)
                        }
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink("種目を追加", destination: WorkOutMenuView())
                    }
                }
                .listStyle(PlainListStyle())
                .background(Color.black)
            }
        }
       
        .environment(\.editMode, $editMode)  // ✅ Apply edit mode environment
       
    }
    
    func formattedTime(_ seconds: Int) -> String {
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        let remainingSeconds = seconds % 60
        return String(format: "%02d時間:%02d分:%02d秒", hours, minutes, remainingSeconds)
    }
    
 
}

#Preview {
    NavigationStack {
        ListView()
    }
    .environmentObject(ListViewModel())
}

