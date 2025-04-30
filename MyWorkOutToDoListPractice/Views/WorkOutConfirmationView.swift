

import SwiftUI

struct WorkOutConfirmationView: View {
    @EnvironmentObject var listViewModel:ListViewModel
    @State private var selectedDate: Date = Date()
    
   
    @State private var checkMarks: [String: Bool] = [:]

    @State var showSheet: Bool = false
    @State private var selectedExercise: ItemModel?
    @State private var showConfirmationAlert: Bool = false
    @State private var navigateToNextView: Bool = false
    
    var body: some View {
        
        let workouts = getFilteredWorkouts()
        
        NavigationStack{
            ZStack{
                VStack {
                    Text("あなたが選んだ本日の種目")
                        .font(.headline)
                        .fontWeight(.bold)
                        .padding(.top, 50)
                    Spacer()
                
                        List{
                            ForEach(workouts){ workout in
                                VStack(alignment: .leading){
                                    HStack{
                                        VStack {
                                            
                                            HStack {
                                                Text("• \(workout.title)")
                                                    .font(.headline)
                                                    .fontWeight(.semibold)
                                                Spacer()
                                            }
                                            

                                        }
                                        Spacer()
                                    
                                        }
                                    
                                }
                            }
                            .onDelete(perform: listViewModel.deleteItem)
                            .onMove(perform: listViewModel.moveItem)
                           
                        }
                    

                    
                    Button {
                        saveExercises()
                        showConfirmationAlert.toggle()
                    } label: {
                        Text("メニューを決定する")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.green)
                            .cornerRadius(10)
                            .padding(.horizontal)
                    }
                    .navigationDestination(isPresented: $navigateToNextView) {
                        ListView()
                            .navigationBarBackButtonHidden(true)
                                   }
                    .alert( isPresented:$showConfirmationAlert ){
                               Alert(
                                   title: Text("最終確認"),
                                   message: Text("あなたが選んだ種目に間違いないですか。"),
                                   primaryButton: .destructive(Text("決定")) {
                                       navigateToNextView.toggle()
                                                   },
                                   secondaryButton: .cancel()
                               )
                        
                           }
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()


                
                    
                    
                }
                .listStyle(PlainListStyle())

                
            }
            .navigationTitle("\(listViewModel.getFormattedDate())")
            
            
        }
        
        
       
    }
    
    func getFilteredWorkouts() -> [ItemModel] {
        return listViewModel.filterItem(selectedDate)
    }
    
    private func saveExercises() {
        let selectedExercises = checkMarks.filter { $0.value }.map { $0.key }
        for exercise in selectedExercises {
            let newItem = ItemModel(title: exercise, isCompleted: false, date: Date(),setCount: 1) 
            listViewModel.addItem(newItem)
        }
    }
    
}



#Preview {
    NavigationStack{
        WorkOutConfirmationView()
    }
    .environmentObject(ListViewModel())
}
