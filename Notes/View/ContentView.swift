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
    @State var notyetLoginMsg = ""
    
    init() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = UIColor.clear // Makes the navbar transparent
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white] // Adjust text color
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
        VStack{
            // MARK: - ✅ Greetinga
            Text("Hi Welcome to Pawerfur Note 🐾")
                .font(.title2)
                .foregroundColor(.noteMilktea)
                .padding()
            
            Text("\(notyetLoginMsg)")
                .font(.body)
                .foregroundColor(.noteMilktea)
                .padding()
            
            HStack{
                // MARK: - ✅ Log-In Button
                Button() {
                    IsLogIn = true
                    notesViewModel.notyetLogin = false
                    byeMsg = ""
                } label: {
                    Text("Login")
                        .padding()
                        .frame(width: 120, height: 50)
                        .foregroundColor(.noteIcyGrey)
                        .background(.noteDarktea, in: .capsule)
                }
                
                // MARK: - ✅ Log-Out Button
                Button() {
                    if  notesViewModel.notyetLogin {
                        byeMsg = "Please log in first! "
                    } else {
                        IsLogIn = false
                        byeMsg = "Successfully log out!"
                        notesViewModel.notyetLogin = true
                    }
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

