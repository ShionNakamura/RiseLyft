//
//  AddView.swift
//  MyWorkOutToDoListPractice
//
//  Created by 仲村士苑 on 2024/12/20.
//

import SwiftUI

struct AddView: View {
    
    @State var textField: String = ""
    @EnvironmentObject var listViewModel:ListViewModel
    @Environment(\.presentationMode) var presentationMode
    @State var alertTitle: String = ""
    @State var showAlert: Bool = false
    
    var body: some View {
        ScrollView{
            TextField("メニューを追加する", text: $textField)
                .padding(.horizontal)
                .frame(height: 55)
                .background(Color(.gray).opacity(0.2))
                .cornerRadius(10)
            Button {
                saveButtonPressed()
            } label: {
                Text("追加".uppercased())
                    .foregroundStyle(.white)
                    .font(.headline)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(Color.accentColor)
                    .cornerRadius(10)
            }
            .padding()
        }
        .navigationTitle("種目")
        .alert(isPresented: $showAlert) {
            getAlert()
        }
    }
    
    func saveButtonPressed(){
        if textIsAppropiate(){
            listViewModel.addItem(title: textField,date: Date())
            presentationMode.wrappedValue.dismiss()

        }
    }
    
    func textIsAppropiate()->Bool{
        if textField.count < 3{
            alertTitle = "uuuuu gotta add 3 characters longs"
            showAlert.toggle()
            return false
        }
        return true
    }
    
    func getAlert()->Alert{
        return Alert(title: Text(alertTitle))
    }
    
    
}

#Preview {
    NavigationStack{
        AddView()
    }
    .environmentObject(ListViewModel())

}
