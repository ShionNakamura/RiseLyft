//
//  ListView.swift
//  MyWorkOutToDoListPractice
//
//  Created by 仲村士苑 on 2024/12/20.
//

import SwiftUI


struct ListView: View {

    
    @EnvironmentObject var listViewModel: ListViewModel
    
    var body: some View {
        ZStack{
            if listViewModel.items.isEmpty{
                NoItemView()
            }
            else{
                List{
                    ForEach(listViewModel.items) { item in
                        ListRowView(item: item)
                            .onTapGesture {
                                withAnimation(.linear){
                                    listViewModel.updateItem(item: item)
                                }
                            }
                              }
                    .onDelete(perform: listViewModel.deleteItem)
                    .onMove(perform: listViewModel.moveItem)
                }
            }
        }
       
        .navigationTitle("Workout List 🏋️‍♀️")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                if !listViewModel.items.isEmpty{
                    EditButton()
                }

                
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink("追加", destination: AddView())
            }
        }
    }
    
  
    
 
}

#Preview {
    NavigationStack{
        ListView()
    }
    .environmentObject(ListViewModel())

}


