import SwiftUI

struct SetInputView: View {
    @EnvironmentObject var listViewModel: ListViewModel
    let item: ItemModel
    let setIndex: Int

    @State private var kg: String = ""
    @State private var reps: String = ""
    @State private var isSetComplete: Bool = false

    var body: some View {
        HStack(spacing: 15) {
            
            Text("セット \(setIndex + 1)")
                .font(.title3)
                .fontWeight(.semibold)
                .frame(minWidth: 70, alignment: .leading)
            
          

            // Weight Input
            HStack(spacing: 0){
                Spacer()

                TextField("重量", text: $kg,onCommit: {
                    updateModel()
                })
                    .keyboardType(.decimalPad)
                    .padding(.horizontal)
                    .frame(height: 35)
                    .frame(width: 65)
                    .background(RoundedRectangle(cornerRadius: 5).fill(Color.gray.opacity(0.2)))

                Text("kg")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .frame(minWidth: 30)
                Spacer()
                TextField("回数", text: $reps, onCommit: {
                    updateModel()
                })
                    .keyboardType(.numberPad)
                    .padding(.horizontal)
                    .frame(height: 35)
                    .frame(width: 70)
                    .background(RoundedRectangle(cornerRadius: 5).fill(Color.gray.opacity(0.2)))
                
                Text("回")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .frame(minWidth: 30)
                    .padding(.trailing)
            }
            Button(action: {
                
                          isSetComplete.toggle()
                          toggleSetCompletion()
              
                if isSetComplete {
                    listViewModel.startIntervalTimer()
                       DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                           listViewModel.breakTime = true // Ensure delay to avoid reset issues
                       }
                   }
                    

                      }) {
                          if listViewModel.showTime{
                              Image(systemName: isSetComplete ? "checkmark.circle.fill" : "circle")
                                  .foregroundColor(isSetComplete ? .green : .gray)
                                  .font(.title2)
                          }
                      }
                      .buttonStyle(BorderlessButtonStyle()) // Prevents unnecessary button styling
                      .sheet(isPresented: $listViewModel.breakTime) {
                          BreakPopUpView()
                      }
                      
        }
        .padding()
        .onAppear {
                    loadData()
                }
        
        
    }
    
    
//    private func loadData() {
//        if let itemIndex = getItemIndex(), setIndex < listViewModel.items[itemIndex].sets.count {
//            kg = listViewModel.items[itemIndex].sets[setIndex].kg
//            reps = listViewModel.items[itemIndex].sets[setIndex].reps
//            isSetComplete = set.setComplete
//
//        }
//    }
    
    
    private func loadData() {
           if let itemIndex = getItemIndex(), setIndex < listViewModel.items[itemIndex].sets.count {
               let set = listViewModel.items[itemIndex].sets[setIndex]
               kg = set.kg
               reps = set.reps
               isSetComplete = set.setComplete
           }
       }
//
//    private func updateModel() {
//           if let itemIndex = getItemIndex(), setIndex < listViewModel.items[itemIndex].sets.count {
//               listViewModel.items[itemIndex].sets[setIndex].kg = kg
//               listViewModel.items[itemIndex].sets[setIndex].reps = reps
//           }
//       }
    
    private func updateModel() {
        if let itemIndex = getItemIndex(), setIndex < listViewModel.items[itemIndex].sets.count {
            var updatedItem = listViewModel.items[itemIndex] // Copy the item
            updatedItem.sets[setIndex] = SetDetail(kg: kg, reps: reps, setComplete: isSetComplete) // Modify the set
            listViewModel.items[itemIndex] = updatedItem // Assign the modified item back
        }
    }

    
    private func toggleSetCompletion() {
        if let itemIndex = getItemIndex(), setIndex < listViewModel.items[itemIndex].sets.count {
            var updatedItem = listViewModel.items[itemIndex] // Copy item
            updatedItem.sets[setIndex].setComplete.toggle() // Toggle completion
            listViewModel.items[itemIndex] = updatedItem // Assign back
        }
    }
    
    private func getItemIndex() -> Int?{
        // Find the index of the current item
        return listViewModel.items.firstIndex(where: { $0.id == item.id }) 
    }
}

#Preview {
    let exampleItem = ItemModel(title: "ベンチプレス", isCompleted: false, date: Date(), setCount: 3, sets: [
        SetDetail(kg: "50", reps: "10",setComplete:false),
        SetDetail(kg: "55", reps: "8",setComplete:false),
        SetDetail(kg: "60", reps: "6",setComplete:false)
    ])
    return SetInputView(item: exampleItem, setIndex: 0)
        .environmentObject(ListViewModel())
}

