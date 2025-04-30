
import SwiftUI

struct SelectBreakTImeView: View{
    
    @State private var selectedMinute: Int = 1
    @State private var selectedSecond: Int = 0
    @State var navigateToNextView: Bool = false
    @EnvironmentObject var listViewModel: ListViewModel
    
    @Environment(\.dismiss) var dismiss

    var body: some View {

        VStack {
                 Text("休憩設定時間を変更する")
                     .font(.title)
                     .fontWeight(.bold)
                     .padding()
            
                 Text("\(selectedMinute)分 : \(String(format: "%02d", selectedSecond))秒")
                     .font(.largeTitle)
                     .fontWeight(.bold)
                     .padding()

                 Picker("分", selection: $selectedMinute) {
                     ForEach(0...20, id: \.self) { minute in
                         Text("\(minute)分").tag(minute)
                     }
                 }
                 .pickerStyle(WheelPickerStyle())
                 .padding()
                 
                 Picker("秒", selection: $selectedSecond) {
                     ForEach(0...59, id: \.self) { second in
                         Text("\(String(format: "%02d", second))秒").tag(second)
                     }
                 }
                 .pickerStyle(WheelPickerStyle())
                 .padding()
                 
                 Button("設定") {
                     let totalTime = (selectedMinute * 60) + selectedSecond
                     listViewModel.defaultIntervalTime = totalTime
                     listViewModel.saveTimer()
                     dismiss()
                 }
                 .frame(width: 200, height: 50)
                 .background(Color.blue)
                 .foregroundColor(.white)
                 .clipShape(Capsule())
                 .padding()

             }
             .padding()
             .onAppear {
                       let savedTime = listViewModel.intervalTime
                       selectedMinute = savedTime / 60
                       selectedSecond = savedTime % 60
                   }
         }
    
}
#Preview {
    NavigationStack{
        SelectBreakTImeView()
    }
    .environmentObject(ListViewModel())
}
