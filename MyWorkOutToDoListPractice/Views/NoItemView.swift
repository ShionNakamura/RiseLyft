//
//  NoItemView.swift
//  MyWorkOutToDoListPractice
//
//  Created by 仲村士苑 on 2024/12/20.
//

import SwiftUI

struct NoItemView: View {
    
    @State var animate: Bool = false
    
    var body: some View {
        ScrollView{
            VStack(spacing: 15){
                Text("メニューがありません😭")
                    .font(.title)
                    .fontWeight(.semibold)
                Text("筋トレのメニューを作成してください")
                    .padding(.bottom, 10)
                NavigationLink {
                    WorkOutMenuView()
                } label: {
                    Text("メニューを追加する")
                        .foregroundStyle(.white)
                        .font(.headline)
                        .frame(height:55)
                        .frame(maxWidth:.infinity)
                        .background(animate ? .red : .blue)
                        .cornerRadius(10)
                }
                .padding(.horizontal, animate ? 10 : 20)
                .offset(y:animate ? -7 : 0)
                .shadow(color: animate ? .red : .blue,
                                 radius: animate ? 30 : 10,
                                 x: 0,
                                 y: animate ? 50 : 30
                         )
                

            }
            .multilineTextAlignment(.center)
            .padding(40)
            .onAppear(perform: addAnimation)
        }
        .frame(maxWidth:.infinity, maxHeight: .infinity)
    }
    
    func addAnimation(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5){
            withAnimation(
                .easeInOut(duration: 2.0)
                .repeatForever()
            ){
                animate.toggle()
            }
        }
    }

}

#Preview {
    NavigationStack{
        NoItemView()

    }
}
