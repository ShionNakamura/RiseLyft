//
//  ListView.swift
//  MyWorkOutToDoListPractice
//
//  Created by 仲村士苑 on 2024/12/20.
//

import SwiftUI

import UIKit

struct ListView: View {

    @EnvironmentObject var listViewModel: ListViewModel
    @State private var selectedCategory: String? = nil
    @State var navigateToNextView: Bool = false
    @State var showConfirmationAlert : Bool = false
    var body: some View {
        NavigationStack{
            ZStack {
                VStack(spacing: 15){
                    if !listViewModel.showTime{
                        HStack{
                            Image(systemName:  "arrowshape.left")
                                .padding(.leading)
                            Spacer()
                            NavigationLink(destination: WorkoutHistoryView()) {
                                Text(listViewModel.getFormattedDate())
                                    .font(.title)
                                    .padding()
                            }
                            Spacer()
                            
                            Image(systemName: "arrowshape.right")
                                .padding(.trailing)
                        }
                    }
                    
                    
                    if !listViewModel.showTime && !listViewModel.items.isEmpty{
                        withAnimation(.easeInOut) {
                            Button {
                                listViewModel.showTime.toggle()
                                listViewModel.startTimer()
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
                        
                    }
                    // training duration
                    if listViewModel.showTime {
                        withAnimation(.easeInOut) {
                            
                            HStack {
                                VStack {

                                    Text("トレーニング経過時間: \(formattedTime(listViewModel.secondsTime))")
                                        .font(.headline)
                                        .fontWeight(.bold)
                                        .padding()
                                    HStack(spacing: 10){
                                        
                                            Button("再開") {
                                                listViewModel.startTimer()

                                            }
                                            .frame(width: 90, height: 50) // Consistent size
                                            .background(Color.accentColor)
                                            .foregroundColor(.white)
                                            .clipShape(Capsule())
                                            
                                        
                                        
                                            Button("止める") {
                                                listViewModel.stopTimer()
                                            }
                                            .frame(width: 90, height: 50) // Consistent size
                                            .background(Color.blue)
                                            .foregroundColor(.white)
                                            .clipShape(Capsule())
                                        
                                       
                                      
                                        Button("リセット") {
                                            listViewModel.resetTimer()
                                            listViewModel.showTime.toggle()
                                        }
                                        .frame(width: 90, height: 50) // Consistent size
                                        .background(Color.red)
                                        .foregroundColor(.white)
                                        .clipShape(Capsule())
                                      
                                    
                                    }

                                }
                            }
                        }
                    }
                   
                    
                    TabView{
                        ZStack{
                            if listViewModel.items.isEmpty{
                                NoItemView()
                           }
                            else{
                                List {
                                    ForEach(listViewModel.items) { item in
                                        VStack(alignment: .leading){
                                            HStack {
                                                ListRowView(item: item)
                                                    .font(.headline)
                                                    .frame(maxWidth: .infinity, alignment: .leading)
                                                    .lineLimit(1)
                                                    .minimumScaleFactor(0.5)
                                                    .onTapGesture {
                                                        withAnimation(.linear) {
                                                            listViewModel.updateItem(item: item)
                                                        }
                                                    }
                                                Spacer() // Pushes the icon to the right
                                                
                                                // set + -
                                                HStack(spacing: 20) {
                                                    Text("セット数 \(item.setCount - 1) ")
                                                        .font(.subheadline)
                                                     
                                                    HStack(spacing: 8) {
                                                        Image(systemName: "plus")
                                                            .font(.caption)
                                                            .foregroundColor(.blue)
                                                            .padding(8)
                                                            .onTapGesture {
                                                                listViewModel.increaseSetCount(for: item)
                                                            }
                                                        
                                                        Image(systemName: "minus")
                                                            .font(.caption)
                                                            .foregroundColor(.blue)
                                                            .padding(8)
                                                            .onTapGesture {
                                                                listViewModel.decreaseSetCount(for: item)
                                                            }
                                                    }
                                                    .padding(.horizontal, 6)
                                                    .background(RoundedRectangle(cornerRadius: 5).fill(Color.gray.opacity(0.2)))
                                                }
                                            }
                                            // for each set
                                            ForEach(Array(item.sets.enumerated()), id: \.offset) { index, set in
                                                SetInputView(item: item, setIndex: index)
                                                
                                                
                                                if index < item.sets.count - 1 {
                                                    Divider()
                                                        .padding(.vertical, 3)
                                                }
                                            }
                                            
                                        }
                                        
                                        
                                    }
                                    .onDelete(perform: listViewModel.deleteItem)
                                    .onMove(perform: listViewModel.moveItem)
                                    
                                    if !listViewModel.items.isEmpty && listViewModel.showTime{
                                          VStack {
                                              Button("完了") {
                                                  listViewModel.stopTimer()
                                                  navigateToNextView = true
                                              }
                                              .foregroundStyle(.white)
                                              .font(.headline)
                                              .frame(height: 55)
                                              .frame(maxWidth: .infinity)
                                              .background(Color.green)
                                              .cornerRadius(10)
                                          }
                                          .frame(maxWidth: .infinity) // Centers the button
                                      }
                                  }
                                  .navigationDestination(isPresented: $navigateToNextView) {
                                      CompleteView()
                                          .navigationBarBackButtonHidden(true)
                                  }
                                  .alert( isPresented:$showConfirmationAlert ){
                                      
                                             Alert(
                                                 title: Text("全ての種目終了"),
                                                 message: Text("全ての種目終了ならば完了を。"),
                                                 primaryButton: .destructive(Text("完了")) {
                                                     navigateToNextView.toggle()
                                                },
                                                 secondaryButton: .cancel()
                                             )
                                
                            }
                            
                            
                            Spacer()
                            
                        
                        }
                        .tabItem {
                            
                            Image(systemName: "figure.strengthtraining.traditional")
                                .foregroundStyle(.orange)
                            Text("メニュー")
                                .foregroundStyle(.orange)
                            
                        }
                        
                        Text("calendar")
                            .tabItem {
                                Image(systemName: "calendar")
                                Text("カレンダー")
                            }
                    }
                    .navigationTitle(!listViewModel.showTime ? "トレーニングリスト🏋️‍♀️" : "トレーニング中")
                    .toolbar {
                       
                            ToolbarItem(placement: .navigationBarLeading) {
                                if !listViewModel.items.isEmpty && !listViewModel.showTime {
                                    EditButton()
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
            .accentColor(.orange)
            
        }
       
 }
    
    func formattedTime(_ seconds: Int) -> String {
           let minutes = seconds / 60
           let remainingSeconds = seconds % 60
           return String(format: "%02d:%02d", minutes, remainingSeconds)
        
       }
  

}



#Preview {
    
    NavigationStack{
        ListView()
    }
    .environmentObject(ListViewModel())

}

