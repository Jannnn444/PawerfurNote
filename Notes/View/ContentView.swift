//
//  ContentView.swift
//  Notes
//
//  Created by Janus on 1/27/25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var noteViewModel: NotesViewModel
    @State var byeMsg = ""
    @State var notyetLoginMsg = ""
    
    @State private var username: String = ""
    @State private var password: String = ""
    
    @State private var imageNumer: Int = 1
    @State private var randomNumber: Int = 1
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isLoading = false
    @State private var showNote = false
    @State private var isLoggedIn = false

    init() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = UIColor.clear // Makes the navbar transparent
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white] // Adjust text color
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        alertMessage = ""
    }
    
    func randomImage() {
        print("Status: Old Image Number = \(imageNumer)")
        repeat {
            randomNumber = Int.random(in: 1...5)
            print("Actin: Random number generatd: \(randomNumber)")
        } while randomNumber == imageNumer
        /* This loop repeats when the numbers are the same. */
        
        imageNumer = randomNumber
        print("Result: New Image number: \(imageNumer)")
        print("--- The End ---")
        print("\n")
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                ZStack {
                    CustomCircleView()
                    Rectangle()
                        .fill(.white)
                        .frame(width: 180, height: 180)
                        .cornerRadius(10)
                    
                    MotionAnimationView()
                    // MARK: - ✅ Rock Image
                    Image("rock\(imageNumer)")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 100)
                }
                
                // MARK: - ✅ Greetinga
                Text("Hi Welcome to Pawerfur Note 🐾")
                    .font(.title2)
                    .foregroundColor(.noteMediumDarktea)
                    .padding()
                
                // MARK: - ✅ Username TextField
                TextField("Enter username", text: $username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .frame(width: 300)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.none)
                    .submitLabel(.done)
                    .onSubmit {
                        hideKeyboard()
                    }
                
                // MARK: - ✅ Password TextField
                SecureField("Enter password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .frame(width: 300)
                    .submitLabel(.done)
                    .onSubmit {
                        hideKeyboard()
                    }
                
                // ✅ Show loading spinner while login is processing
                if isLoading {
                    VStack {
                        ProgressView("Logging in...") // ✅ Loading bar
                            .progressViewStyle(CircularProgressViewStyle())
                            .padding()
                    }
                }
                
                HStack{
                    // MARK: - ✅ Log-In Button
                    Button() {
                        hideKeyboard()
                        isLoading = true // ✅ Show loading before login attempt
                        noteViewModel.login(email: username, password: password)
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { // Ensure login state updates
                            // When api works, $noteViewModel.showPleaseLogin will be false.
                            if !noteViewModel.showPleaseLogin {
                                DispatchQueue.main.async {
                                    alertMessage = "Login Successful!"
                                    showAlert = true
                                    isLoading = false // ✅ Stop loading
                                    noteViewModel.isLogin = true
                                }
                            } else {
                                alertMessage = "Login Failed. Please check your credentials."
                                showAlert = true  // Show alert for failure too
                                isLoading = false
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    showAlert = false
                                }
                            }
                            isLoading = false // ✅ Hide loading indicator
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                showNote = true // ✅ Ensures transition happens after alert disappears
                            }
                        }
                    } label: {
                        ZStack{
                            CustomButtonView()
                            Text("Login")
                                .padding()
                                .foregroundColor(.noteAlmond)
                        }
                    }
                    .alert(isPresented: $showAlert) {
                        Alert(
                            title: Text("Notification"),
                            message: Text(alertMessage),
                            dismissButton: .default(Text("OK")) {
                                if alertMessage == "Login Successful!" {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                        noteViewModel.isLogin = true 
                                        showNote = true// ✅ Trigger sheet after alert dismissal
                                    }
                                }
                            }
                        )
                    }
                    
                    // MARK: - ✅ Log-Out Button
                    Button() {
                        randomImage()
                        if noteViewModel.showPleaseLogin {
                            byeMsg = "Please log in first! "
                        } else {
                            noteViewModel.isLogin = false
                            byeMsg = "Successfully log out!"
                            noteViewModel.showPleaseLogin = true
                            showNote = false
                        }
                    } label: {
                        ZStack {
                            CustomButtonView()
                            Text("Log out")
                                .padding()
                                .foregroundColor(.noteAlmond)
                        }
                    }
                }
                .fullScreenCover(isPresented: $showNote) {
                    NotesView()
                }
                .padding(.top, 30)
                
                // MARK: - ✅ Sign-Up
                NavigationLink(destination: SignUpView()) {
                    Text("Sign Up")
                        .padding()
                        .foregroundColor(.blue)
                }
                
                Text("\(byeMsg)")
                    .font(.body)
                    .foregroundColor(.noteMilktea)
                    .padding()
            }
        }
    }
}

