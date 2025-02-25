

import SwiftUI

struct NoItemView: View {
    
    @EnvironmentObject var listViewModel: ListViewModel

    @State var animate: Bool = false
    @State private var editMode: EditMode = .inactive

    
    var body: some View {
        ScrollView{
            VStack(spacing: 15){
                
                Text(listViewModel.getFormattedDate())
                    .font(.title)
                    .padding()
                
                Spacer()
                Text("メニューがありません😭")
                    .font(.title)
                    .fontWeight(.semibold)
                Text("筋トレのメニューを作成してください")
                    .padding(.bottom, 10)
                NavigationLink {
                    WorkOutMenuView()
                } label: {
                    Text("メニューを作成する")
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
            .onAppear {
                           addAnimation()
                       }        }
        .frame(maxWidth:.infinity, maxHeight: .infinity)
        .navigationTitle(!listViewModel.showTime ? "トレーニングリスト🏋️‍♀️" : "トレーニング中")

        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    editMode = editMode == .active ? .inactive : .active
                }) {
                    Text(editMode == .active ? "完了" : "編集")
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink("種目を追加", destination: WorkOutMenuView())
            }
        }
    }


    
    func addAnimation(){
        listViewModel.resetTimer()
        listViewModel.showTime = false
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
    .environmentObject(ListViewModel())

}
