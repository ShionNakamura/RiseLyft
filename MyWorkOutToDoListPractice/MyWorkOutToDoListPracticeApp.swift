//
//  MyWorkOutToDoListPracticeApp.swift
//  MyWorkOutToDoListPractice
//
//  Created by 仲村士苑 on 2024/12/20.
//

import SwiftUI
import CoreData

@main
//struct MyWorkOutToDoListPracticeApp: App {
//    @StateObject var listViewModel:ListViewModel = ListViewModel()
//    var body: some Scene {
//        WindowGroup {
//            NavigationStack{
//                ListView()
//            }
//                .environmentObject(listViewModel)
//        }
//    }
//}


//struct PersistenceController {
//    static let shared = PersistenceController()
//
//    let container: NSPersistentContainer
//
//    init() {
//        container = NSPersistentContainer(name: "MigrationManager") // ← .xcdatamodeldのファイル名
//        container.loadPersistentStores { _, error in
//            if let error = error {
//                fatalError("Unresolved error \(error)")
//            }
//        }
//    }
//}



struct MyWorkOutToDoListPracticeApp: App {
    let persistenceController = PersistenceController.shared
    @StateObject var listViewModel: ListViewModel = ListViewModel()

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ListView()
                    .onAppear {
                        MigrationManager.migrateIfNeeded(context: persistenceController.container.viewContext)
                    }
            }
            .environmentObject(listViewModel)
            .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init() {
        container = NSPersistentContainer(name: "MigrationManager") // .xcdatamodeldの名前に合わせる
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Unresolved error \(error)")
            }
        }
    }
}


