//
//  ListRowView.swift
//  MyWorkOutToDoListPractice
//
//  Created by 仲村士苑 on 2024/12/20.
//

import SwiftUI

struct ListRowView: View {
    
   let item: ItemModel
    
    var body: some View {
        HStack{
            Image(systemName: item.isCompleted ? "checkmark.circle":"circle")
                .foregroundStyle( item.isCompleted ? .green : .red)
            Text(item.title)
            Spacer()
        }
    }
}

#Preview {
    ListRowView(item: ItemModel(title: "This is something", isCompleted: false))
    ListRowView(item: ItemModel(title: "This is something", isCompleted: true))
}
