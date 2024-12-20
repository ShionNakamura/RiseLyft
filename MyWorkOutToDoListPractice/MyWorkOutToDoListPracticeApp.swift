//
//  MyWorkOutToDoListPracticeApp.swift
//  MyWorkOutToDoListPractice
//
//  Created by 仲村士苑 on 2024/12/20.
//

import SwiftUI

@main
struct MyWorkOutToDoListPracticeApp: App {
    @StateObject var listViewModel:ListViewModel = ListViewModel()
    var body: some Scene {
        WindowGroup {
            NavigationStack{
                ListView()
            }
                .environmentObject(listViewModel)
        }
    }
}

