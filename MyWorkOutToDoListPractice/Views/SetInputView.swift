import SwiftUI

struct SetInputView: View {
    @EnvironmentObject var listViewModel: ListViewModel
    let item: ItemModel
    let setIndex: Int

    @State  var kg: String = ""
    @State  var reps: String = ""
    @State private var isSetComplete: Bool = false
    @State private var showSheet: Bool = false
    

    @State var textFieldReps: Bool = false
    @State var textFieldKg: Bool = false

    @State var showAlertForRepsAndKg: Bool = false
    @State var alertTitle: String = ""
    
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        HStack(spacing: 10) {
            
            Text(" セット \(setIndex + 1)")
                .font(.body)
                .fontWeight(.semibold)
                .frame(minWidth: 70, alignment: .leading)
//                .padding(.leading, 20)
//            
            
            
            // Weight Input
            HStack(spacing: 5){
                Spacer()
                if listViewModel.showTime {
                                   // Weight input
                    TextField("重量", text:$kg)
                                       .keyboardType(.decimalPad)
                                       .padding(.horizontal)
                                       .frame(height: 35)
                                       .frame(width: 90)
                                       .background(RoundedRectangle(cornerRadius: 5).fill(Color.gray.opacity(0.2)))
                                       .onChange(of: kg) { oldValue, newValue in
                                           if !newValue.isEmpty {
                                               updateModel()
                                               
                                           }
                                           
                                       }
                                      
                                   Text("kg")
                                       .font(.subheadline)
                                       .fontWeight(.bold)
                                       .frame(minWidth: 20)

                                   
                                   // Reps input
                    TextField("回数", text: $reps)
                                       .keyboardType(.numberPad)
                                       .padding(.horizontal)
                                       .frame(height: 35)
                                       .frame(width: 90)
                                       .background(RoundedRectangle(cornerRadius: 5).fill(Color.gray.opacity(0.2)))
                                       .onChange(of: reps) { oldValue, newValue in
                                           if !newValue.isEmpty {
                                               updateModel()
                                           }
                                       }

                                   Text("回")
                                       .font(.subheadline)
                                       .fontWeight(.bold)
                                       .frame(minWidth: 20)
                               }
            }
            
            .alert(isPresented: $showAlertForRepsAndKg) {
                getAlert()
            }
            
            
        
            if !kg.isEmpty && !reps.isEmpty{
                
                Button(action: {
                    
                    if textIsAppropiate(){
                        isSetComplete.toggle()
                        saveButtonPressed()
                        toggleSetCompletion()
                        if isSetComplete { // Show sheet only when marking as complete
                            showSheet = true
                            listViewModel.startIntervalTimer()
                    }
                }
                    
                })
                    {
                    if listViewModel.showTime{
                        Image(systemName: isSetComplete ? "checkmark.circle.fill" : "circle")
                            .foregroundColor(isSetComplete ? .green : .gray)
                            .font(.title3)
                    }
                }
                
                .buttonStyle(BorderlessButtonStyle()) // Prevents unnecessary button styling
            }
            
      
                    Image(systemName: "trash")
                        .font(.title3)
                        .foregroundStyle(.red)
                        .onTapGesture {
                            listViewModel.decreaseSetCount(for: item, at: setIndex)

                        }
            
            
        }
                      
        
        .padding()

        .onAppear {
                    loadData()
                }
        .sheet(isPresented: $showSheet) {
            BreakPopUpView()
            
        }
      
        
        
    }
    
    func saveButtonPressed(){
        if textIsAppropiate(){
            presentationMode.wrappedValue.dismiss()
        }
    }
    
    
    func textIsAppropiate()->Bool{
        if reps.count > 5 {
            alertTitle = "回数を5桁以内に入力してください"
            showAlertForRepsAndKg.toggle()
            return false
        }
        else if kg.count > 5{
            alertTitle = "重量を5桁以内に入力してください"
            showAlertForRepsAndKg.toggle()
            return false
        }
        return true
    }
    
    func getAlert()->Alert{
        return Alert(title: Text(alertTitle))
    }
    

    
    private func loadData() {
           if let itemIndex = getItemIndex(), setIndex < listViewModel.items[itemIndex].sets.count {
               let set = listViewModel.items[itemIndex].sets[setIndex]
               kg = set.kg
               reps = set.reps
               isSetComplete = set.setComplete
           }
       }

    
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

