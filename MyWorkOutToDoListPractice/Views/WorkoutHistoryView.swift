////
////  WorkoutHistoryView.swift
////  MyWorkOutToDoListPractice
////
////  Created by 仲村士苑 on 2025/01/27.
////
//
//import SwiftUI
//
//struct WorkoutHistoryView: View {
//    @EnvironmentObject var listViewModel: ListViewModel
//    @State private var selectedDate: Date = Date()
//
//    var body: some View {
//        let workouts = getFilteredWorkouts()
//
//        VStack {
//            DatePicker("トレーニング日付", selection: $selectedDate, displayedComponents: .date)
//                .datePickerStyle(.compact)
//                .padding()
//            
//            List{
//                ForEach(workouts){ workout in
//                VStack{
//                        Text(workout.title)
//                        
//                    }
//                }
//               
//                
//            }
//            
//            
//        }
//        
//    }
//    
//    func getFilteredWorkouts() -> [ItemModel] {
//        return listViewModel.filterItem(selectedDate)
//    }
//}
//
//#Preview {
//    NavigationStack{
//        WorkoutHistoryView()
//    }
//    .environmentObject(ListViewModel())
//}
