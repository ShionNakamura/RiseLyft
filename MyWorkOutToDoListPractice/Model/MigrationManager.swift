//
//  MigrationManager.swift
//  MyWorkOutToDoListPractice
//
//  Created by 仲村士苑 on 2025/06/09.
//

import Foundation
import CoreData

struct MigrationManager {
    
    static func loadFromUserDefaults() -> [ItemModel] {
        guard let data = UserDefaults.standard.data(forKey: "items") else { return [] }
        do {
            let items = try JSONDecoder().decode([ItemModel].self, from: data)
            return items
        } catch {
            print("Failed to decode: \(error)")
            return []
        }
    }

    static func migrateToCoreData(from models: [ItemModel], context: NSManagedObjectContext) {
        for model in models {
            let itemEntity = ItemModelEntity(context: context)
            itemEntity.id = model.id
            itemEntity.title = model.title
            itemEntity.isCompleted = model.isCompleted
            itemEntity.date = model.date
            itemEntity.setCount = Int16(model.setCount)

            for set in model.sets {
                let setEntity = SetDetailEntity(context: context)
                setEntity.kg = set.kg
                setEntity.reps = set.reps
                setEntity.setComplete = set.setComplete
                setEntity.item = itemEntity
            }
        }

        do {
            try context.save()
            print("Migration successful.")
        } catch {
            print("Failed to save: \(error)")
        }
    }

    static func migrateIfNeeded(context: NSManagedObjectContext) {
        let migratedFlagKey = "didMigrateToCoreData"
        if !UserDefaults.standard.bool(forKey: migratedFlagKey) {
            let items = loadFromUserDefaults()
            migrateToCoreData(from: items, context: context)
            UserDefaults.standard.set(true, forKey: migratedFlagKey)
            UserDefaults.standard.removeObject(forKey: "items")
        }
    }
}
