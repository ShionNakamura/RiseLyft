

import SwiftUI

struct ListRowView: View {
    
   let item: ItemModel
  @EnvironmentObject var listViewModel:ListViewModel

    var body: some View {
            HStack{
                if listViewModel.showTime{
                    Image(systemName: item.isCompleted ? "checkmark.circle":"circle")
                        .foregroundStyle( item.isCompleted ? .green : .red)
                    
                }
               
                Text(item.title)
                
                Spacer()
            }
        
        
     
    }
    
}

#Preview {
    ListRowView(item: ItemModel(title: "This is something", isCompleted: false,date: Date(),setCount: 1))
        .environmentObject(ListViewModel())
    ListRowView(item: ItemModel(title: "This is something", isCompleted: true,date: Date(),setCount: 1))
        .environmentObject(ListViewModel())
}
