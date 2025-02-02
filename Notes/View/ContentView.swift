//
//  ContentView.swift
//  Notes
//
//  Created by Janus on 1/27/25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var notesViewModel: NotesViewModel

    var body: some View {
    
            Group {
                if notesViewModel.isDataLoaded {
                    NotesView()
                } else {
                    ProgressView("Loading...")
                }
            }
    }
}
