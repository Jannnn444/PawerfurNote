//
//  NotesApp.swift
//  Notes
//
//  Created by Janus on 1/27/25.
//

import SwiftUI

@main
struct NotesToDocApp: App {
    @StateObject var notesViewModel: NotesViewModel

        init() {
            let viewModel = NotesViewModel()
            _notesViewModel = StateObject(wrappedValue: viewModel)
        }


    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(notesViewModel)
        }
    }
}
