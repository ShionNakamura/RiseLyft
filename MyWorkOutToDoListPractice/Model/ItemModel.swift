import Foundation

struct SetDetail: Codable {
    var kg: String
    var reps: String
    var setComplete: Bool
}

struct ItemModel: Identifiable, Codable {
    var id: UUID
    var title: String
    var isCompleted: Bool
    var date: Date
    var setCount: Int
    var sets:[SetDetail]
    
    init(id: UUID = UUID(), title: String, isCompleted: Bool, date: Date,setCount: Int = 1, sets: [SetDetail] = [])
    {
        self.id = id
        self.title = title
        self.isCompleted = isCompleted
        self.date = date
        self.setCount = setCount
        self.sets = sets
    }
    
    static let workoutCategories: [String: [String]] = [
        "背中のトレーニング": ["ラットプルダウン", "デットリフト", "懸垂", "ワンハンドロウ", "スタンディングダンベルロウ", "T-バロウ", "シーテッドローマシン", "シーテッドケーブルロウ"],
        "胸のトレーニング": ["ベンチプレス", "インクラインベンチプレス", "スミスベンチプレス", "スミスインクラインベンチプレス",],
        "肩のトレーニング": ["ダンベルショルダープレス", "サイドレイズ", "フェイスプル"],
        "脚のトレーニング": ["スクワット", "レッグプレス"],
        "腕のトレーニング": ["バーベルカール", "ダンベルフレンチプレス"]
    ]
    
    func updateCompletion() -> ItemModel {
        return ItemModel(id: id, title: title, isCompleted: !isCompleted, date: date, setCount: setCount, sets: sets)
    }
}

