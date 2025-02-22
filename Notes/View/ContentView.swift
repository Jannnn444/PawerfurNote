//
//  ContentView.swift
//  Notes
//
//  Created by Janus on 1/27/25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var notesViewModel: NotesViewModel
    @State var IsLogIn: Bool = false
    @State var byeMsg = ""
    
    var body: some View {
        VStack{
            // MARK: - ✅ Greetinga
            Text("Hi Welcome to Pawerfur Note 🐾")
                .font(.title2)
                .foregroundColor(.noteMilktea)
                .padding()
            
            Text("Please log in first ... ")
                .font(.body)
                .foregroundColor(.noteMilktea)
                .padding()
            
            HStack{
                // MARK: - ✅ Log-In Button
                Button() {
                    IsLogIn = true
                } label: {
                    Text("Login")
                        .padding()
                        .frame(width: 120, height: 50)
                        .foregroundColor(.noteIcyGrey)
                        .background(.noteDarktea, in: .capsule)
                }
                // MARK: - ✅ Log-Out Button
                Button() {
                    IsLogIn = false
                    byeMsg = "Successfully log out !"
                } label: {
                    Text("Log out")
                        .padding()
                        .frame(width: 120, height: 50)
                        .foregroundColor(.noteIcyGrey)
                        .background(.noteDarktea, in: .capsule)
                    
                }
            }
            .fullScreenCover(isPresented: $IsLogIn) {
                NotesView()
            }
            
            Text("\(byeMsg)")
                .font(.body)
                .foregroundColor(.noteMilktea)
                .padding()
        }
        .ignoresSafeArea()
    }
}

