
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
    
    
    @Published var intervalTime: Int = 60 {
           didSet {
               saveTimer()
             
           }
       }
    
    let keyItem = "Key_item"
    var defaultIntervalTime: Int = 60 // Stores the custom interval

    @Published var showTime:Bool = false
    @Published var secondsTime = 0
    @Published var timer: Timer?
    
    @Published var breakTime:Bool = false
    @Published var intervalTimer: Timer?
    @Published  var isSetComplete: Bool = false
    @Published  var kg: String = ""
    @Published  var reps: String = ""
    
    init(){
        getItem()
        loadTimer()

    }
    
//    func getItem(){
//        
////        let newItem = [
////            ItemModel(title: "This is the first Item", isCompleted: false),
////            ItemModel(title: "This is the second Item", isCompleted: true),
////            ItemModel(title: "This is the second Item", isCompleted: true)
////        ]
////        items.append(contentsOf: newItem)
//        guard let data = UserDefaults.standard.data(forKey: keyItem)else{return}
//        guard let saveItem = try?  JSONDecoder().decode([ItemModel].self, from: data)else{return}
//        self.items = saveItem
//    }
    
    
    func getItem() {
        DispatchQueue.global(qos: .background).async {
            if let data = UserDefaults.standard.data(forKey: self.keyItem) {
                print("Data size: \(data.count) bytes") // Check size
                if let savedItems = try? JSONDecoder().decode([ItemModel].self, from: data) {
                    DispatchQueue.main.async {
                        self.items = savedItems
                    }
                }
            }
        }
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
        saveItem()
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

    
    func decreaseSetCount(for item: ItemModel, at index: Int) {
        if index < item.sets.count {
            var updatedItem = item
            updatedItem.sets.remove(at: index) // Remove the set at the specified index
            updatedItem.setCount -= 1 // Update the set count
            if let itemIndex = items.firstIndex(where: { $0.id == item.id }) {
                items[itemIndex] = updatedItem // Update the list with the modified item
            }
        }
    }

    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    // break time between sets
    func startIntervalTimer() {
        intervalTimer?.invalidate() // Reset any existing timer
        breakTime = true // Ensure this is set first
        intervalTime = defaultIntervalTime // Reset interval before starting
        intervalTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            DispatchQueue.main.async { // Ensure UI updates properly
                if self.intervalTime > 0 {
                    self.intervalTime -= 1
                } else {
                    self.skipBreak()
                }
            }
        }
    }
    
    func restartTimer(){
//        timer?.invalidate() // Stop any existing timer
        intervalTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            DispatchQueue.main.async { // Ensure UI updates properly
                if self.intervalTime > 0 {
                    self.intervalTime -= 1
                } else {
                    self.stopIntervalTimer() // Stop when time reaches 0
                    self.saveTimer()
                    self.skipBreak()
                }
            }
        }
    }
    
    func stopIntervalTimer() {
        intervalTimer?.invalidate()
        intervalTimer = nil
        
    }
    
    func skipBreak() {
        stopIntervalTimer()
        showTime = true // Resume workout
        breakTime = false
//
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
               NotificationCenter.default.post(name: NSNotification.Name("DismissBreakSheet"), object: nil)
           }

    }
    
    func decreaseTimerSec(){
        if intervalTime > 10 { // Prevents negative values
              intervalTime -= 10
          } else {
              self.skipBreak()
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
              self.showTime = true
              self.breakTime = false
          }
    }
    
    func  increaseTimerMin(){
        intervalTime += 60
    }

    
    func saveTimer() {
          UserDefaults.standard.set(intervalTime, forKey: "savedBreakTime")
      }
    
    
    func loadTimer() {
        if let savedTime = UserDefaults.standard.value(forKey: "savedBreakTime") as? Int {
            intervalTime = savedTime
        }
    }
    
///////////////////////////////////////////////////  /////////////////////////////////////////////////////

    
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
    
    

    
    func prepareForReset() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
              self.items.removeAll()
              self.resetTimer()
              self.showTime = false
          }
    }

    
 
    
   
}
