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
        "背中のトレーニング": ["ラットプルダウン", "デットリフト", "懸垂", "シーテッドローマシン","バーベルベントオーバーローイング"],
        "胸のトレーニング": ["ベンチプレス", "インクラインベンチプレス", "ディップス", "ダンベルプレス","ペックデックマシン"],
        "肩のトレーニング": ["ダンベルショルダープレス", "サイドレイズ", "フロントレイズ","リアレイズ","マシンショルダープレス"],
        "脚のトレーニング": ["スクワット", "レッグプレス","レッグカール","ブルガリアンスクワット","レッグエクステンション"],
        "腕のトレーニング": ["バーベルカール", "ダンベルフレンチプレス","インクラインダンベルカール","プリーチャーカール","スカルクラッシャー"],
        "腹筋のトレーニング": ["クランチ", "レッグレイズ", "プランク", "バイシクルクランチ", "ロシアンツイスト"]
    ]
    
    func updateCompletion() -> ItemModel {
        return ItemModel(id: id, title: title, isCompleted: !isCompleted, date: date, setCount: setCount, sets: sets)
    }
}

