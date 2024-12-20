//
//  ListViewModel.swift
//  MyWorkOutToDoListPractice
//
//  Created by 仲村士苑 on 2024/12/20.
//

import Foundation

class ListViewModel:ObservableObject{
    
    
    @Published var items:[ItemModel] = []{
        didSet{
            saveItem()
        }
    }
    
    let keyItem = "Key_item"
    
    init(){
        getItem()
    }
    
    func getItem(){
//        let newItem = [
//            ItemModel(title: "This is the first Item", isCompleted: false),
//            ItemModel(title: "This is the second Item", isCompleted: true),
//            ItemModel(title: "This is the second Item", isCompleted: true)
//        ]
//        items.append(contentsOf: newItem)
        guard let data = UserDefaults.standard.data(forKey: keyItem)else{return}
        guard let saveItem = try?  JSONDecoder().decode([ItemModel].self, from: data)else{return}
        self.items = saveItem
    }
    
    func deleteItem(indexSet: IndexSet){
        items.remove(atOffsets: indexSet)
    }
    func moveItem(indexSet: IndexSet, to: Int){
        items.move(fromOffsets: indexSet, toOffset: to)
    }
    
    func addItem(title:String){
        let newItem = ItemModel(title: title, isCompleted: false)
        items.append(newItem)
    }
  
    func updateItem(item: ItemModel) {
        if let index = items.firstIndex(where: {existingItem in
            existingItem.id == item.id
        }){
            items[index] = item.updateCompletion()
        }
    }
    
    func saveItem(){
        if let encodeData = try? JSONEncoder().encode(items){
            UserDefaults.standard.set(encodeData, forKey: keyItem)
        }
    }

    
}
