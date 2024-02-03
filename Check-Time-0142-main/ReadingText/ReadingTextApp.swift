//
//  ReadingTextApp.swift
//  ReadingText
//
//  Created by 柳冰 on 2023/02/01.
//

import SwiftUI

@main
struct ReadingTextApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { output in
                    UIApplication.shared.applicationIconBadgeNumber = 0
                }.onAppear {
                    UIApplication.shared.applicationIconBadgeNumber = 0
                }
        }
    }
}
