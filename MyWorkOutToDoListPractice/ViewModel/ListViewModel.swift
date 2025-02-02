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
    
    @Published var showTime:Bool = false

    @Published var secondsTime = 0
    @Published var timer: Timer?
    
    
    @Published var breakTime:Bool = false
    
    @Published var intervalTime: Int = 60
    @Published var intervalTimer: Timer?

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
    
    // CRUD
      func addItem(_ item: ItemModel) {
          items.append(item)
      }
    
    func deleteItem(indexSet: IndexSet){
        items.remove(atOffsets: indexSet)
    }
    
    func moveItem(indexSet: IndexSet, to: Int){
        items.move(fromOffsets: indexSet, toOffset: to)
    }
    
    func addItem(title:String,date:Date){
        let newItem = ItemModel(title: title, isCompleted: false, date: date,setCount: 1)
        items.append(newItem)
    }
  
    func updateItem(item: ItemModel) {
        if let index = items.firstIndex(where: {existingItem in
            existingItem.id == item.id
        }){
            items[index] = item.updateCompletion()
        }
    }
    
    // learn this again 
    
    func filterItem(_ date: Date)->[ItemModel]{
        items.filter{
            item in
            let itemDate = item.date
            let selectedDate = date
            return Calendar.current.isDate(itemDate, inSameDayAs: selectedDate)
        }
    }
    
    func saveItem(){
        if let encodeData = try? JSONEncoder().encode(items){
            UserDefaults.standard.set(encodeData, forKey: keyItem)
        }
    }

    
    // date
    func getFormattedDate() -> String {
           let dateFormatter = DateFormatter()
           dateFormatter.dateStyle = .medium
           let today = Date()
           return dateFormatter.string(from: today)
       }
    
    
    // set increase or descease
    func increaseSetCount(for item: ItemModel) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index].sets.append(SetDetail(kg: "", reps: "",setComplete: false))
            items[index].setCount += 1 // Update the set count
        }
    }

    func decreaseSetCount(for item: ItemModel) {
        if let index = items.firstIndex(where: { $0.id == item.id }), items[index].setCount > 1 {
            items[index].sets.removeLast()
            items[index].setCount -= 1
        }
    }
    
    // break time between sets
    func startIntervalTimer() {
        
        intervalTimer?.invalidate() // Reset any existing timer
        intervalTime = 60 // Set break duration (change as needed)
        if !breakTime { // Only set breakTime if it's not already true
               breakTime = true
           }
        showTime = true
        intervalTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if self.intervalTime > 0 {
                self.intervalTime -= 1 // Decrease break time
            } else {
                self.stopIntervalTimer() // Stop when time reaches 0
            }
        }
    }
    
    func stopIntervalTimer() {
        intervalTimer?.invalidate()
        intervalTimer = nil
        breakTime = false // Hide break UI
    }
    
    func skipBreak() {
        stopIntervalTimer()
        showTime = true // Resume workout
    }
    
    func decreaseTimerSec(){
        if intervalTime > 10 { // Prevents negative values
              intervalTime -= 10
          } else {
              intervalTime = 0
          }
    }
    
    func increaseTimerSec(){
              intervalTime += 10
    }
    
    func  decreaseTimerMin(){
        if intervalTime > 60 {
              intervalTime -= 60
          } else {
              intervalTime = 0
          }
    }
    func  increaseTimerMin(){
        intervalTime += 60
    }
    
    func formattedIntervalTime() -> String {
        let minutes = intervalTime / 60
        let seconds = intervalTime % 60
        return String(format: "%02d分:%02d秒", minutes, seconds)
    }
    
    
    // time duration for workout
    
    func startTimer(){
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
           self.secondsTime += 1
            }
    }
    
    func stopTimer() {
            timer?.invalidate()
            timer = nil
        }

    func resetTimer() {
            stopTimer()
            secondsTime = 0
        }
    
   
}
