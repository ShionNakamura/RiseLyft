//
//  BreakPopUpView.swift
//  MyWorkOutToDoListPractice
//
//  Created by 仲村士苑 on 2025/02/02.
//

import SwiftUI

struct BreakPopUpView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject  var listViewModel: ListViewModel
    @State private var navigateToNextView: Bool = false
    var body: some View {
        // break time
        //        if listViewModel.showTime && listViewModel.breakTime{
        NavigationStack{
            withAnimation(.easeInOut) {
                
                VStack(spacing: 20) {
                    HStack {
                        
                        Button {
                            navigateToNextView.toggle()
                        }
                        label: {
                            Image(systemName: "gearshape.fill")
                                .font(.title3)
                        }
                        
                        Text("残り休憩時間: \(listViewModel.formattedIntervalTime())")
                            .font(.headline)
                            .fontWeight(.bold)
                            .padding(.vertical, 30)
                    }
                    
                    
                    HStack(spacing: 10){
                        
                        Button("止める") {
                            listViewModel.stopIntervalTimer()
                        }
                        .frame(width: 90, height: 50) // Consistent size
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                        
                        
                        
                        
                        HStack (spacing: 10){
                            Button("スキップ") {
                                listViewModel.skipBreak()
                                dismiss()
                            }
                            .frame(width: 100, height: 50)
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .clipShape(Capsule())
                        }
                        
                    }
                    
                    HStack(spacing: 10) {
                        Button("-1 min") {
                            listViewModel.decreaseTimerMin()
                        }
                        .frame(width: 70, height: 50)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                        
                        Button("-10s") {
                            listViewModel.decreaseTimerSec()
                        }
                        .frame(width: 70, height: 50)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                        
                        Button("+10ss") {
                            listViewModel.increaseTimerSec()
                        }
                        .frame(width: 70, height: 50)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                        
                        Button("+1 min") {
                            listViewModel.increaseTimerMin()
                        }
                        .frame(width: 70, height: 50)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                    }
                    .padding(.horizontal, 10)
                    
                    
                }
                .navigationDestination(isPresented: $navigateToNextView){
                    SelectBreakTImeView()
                }
                .navigationBarBackButtonHidden()
                
            }
        }
    }
}


#Preview {
    
    NavigationStack{
        BreakPopUpView()
            .environmentObject(ListViewModel())

    }

}
