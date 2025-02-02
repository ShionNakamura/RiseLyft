//
//  selectBreakTimeView.swift
//  MyWorkOutToDoListPractice
//
//  Created by 仲村士苑 on 2025/02/02.
//

import SwiftUI

struct SelectBreakTImeView: View{
    
    @State private var selectedMinute: Int = 1  // Initial minute selection
     @State private var selectedSecond: Int = 0  // Initial second selection
    @State var navigateToNextView: Bool = false
    @EnvironmentObject var listViewModel: ListViewModel
    var body: some View {

        VStack {
                 Text("休憩設定時間を変更する")  // "Change break time"
                     .font(.title)
                     .fontWeight(.bold)
                     .padding()
                 
                 // Display the selected time in "minutes:seconds" format
                 Text("\(selectedMinute)分 : \(String(format: "%02d", selectedSecond))秒")
                     .font(.largeTitle)
                     .fontWeight(.bold)
                     .padding()

                 // Picker for minutes (1 to 10 minutes)
                 Picker("分", selection: $selectedMinute) {
                     ForEach(1...10, id: \.self) { minute in
                         Text("\(minute)分").tag(minute)
                     }
                 }
                 .pickerStyle(WheelPickerStyle())
                 .padding()
                 
                 // Picker for seconds (0 to 59 seconds)
                 Picker("秒", selection: $selectedSecond) {
                     ForEach(0...59, id: \.self) { second in
                         Text("\(String(format: "%02d", second))秒").tag(second)
                     }
                 }
                 .pickerStyle(WheelPickerStyle())
                 .padding()
                 
                 // Button to confirm the break time selection
                 Button("設定") {
                     let totalTime = (selectedMinute * 60) + selectedSecond
                     listViewModel.intervalTime = totalTime
                     navigateToNextView.toggle()
                 }
                 .frame(width: 200, height: 50)
                 .background(Color.blue)
                 .foregroundColor(.white)
                 .clipShape(Capsule())
                 .padding()
                 .navigationDestination(isPresented: $navigateToNextView) {
                     BreakPopUpView()
                 }
                 .navigationBarBackButtonHidden(true)
             }
             .padding()
         }
    
}
#Preview {
    NavigationStack{
        SelectBreakTImeView()
    }
    .environmentObject(ListViewModel())
}
