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
    
    @State private var imageNumber: Int = 1
    @State private var randomNumber: Int = 1
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isLoggingIn = false
    @State private var showNote = false

    init() {
        // Configure navigation bar appearance
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = UIColor.clear // Makes the navbar transparent
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white] // Adjust text color
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        alertMessage = ""
    }
    
    func randomImage() {
        print("Status: Old Image Number = \(imageNumber)")
        repeat {
            randomNumber = Int.random(in: 1...5)
            print("Action: Random number generated: \(randomNumber)")
        } while randomNumber == imageNumber
        /* This loop repeats when the numbers are the same. */
        
        imageNumber = randomNumber
        print("Result: New Image number: \(imageNumber)")
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
                    Image("rock\(imageNumber)")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 100)
                }
                
                // MARK: - ✅ Greeting
                Text("Hi Welcome to Pawerfur Note 🐾")
                    .font(.body)
                    .foregroundColor(.noteMediumDarktea)
                    .padding()
                    .padding(.top, 30)
                
                Spacer()
                
                VStack {
                    // MARK: - ✅ Username TextField
                    TextField("Enter username", text: $username)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 300)
                        .padding()
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.none)
                        .submitLabel(.next)
                        .keyboardType(.emailAddress)
                        .disabled(isLoggingIn)
                    
                    // MARK: - ✅ Password TextField
                    SecureField("Enter password", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 300)
                        .padding()
                        .submitLabel(.done)
                        .disabled(isLoggingIn)
                        .onSubmit {
                            if !username.isEmpty && !password.isEmpty {
                                loginUser()
                            }
                        }
                }
                .padding()
                
                Spacer()
                
                HStack {
                    // MARK: - ✅ Log-In Button
                    Button {
                        loginUser()
                    } label: {
                        ZStack {
                            CustomButtonView()
                            if isLoggingIn {
                                ProgressView()
                                    .tint(.noteAlmond)
                            } else {
                                Text("Login")
                                    .padding()
                                    .font(.body)
                                    .foregroundColor(.noteAlmond)
                            }
                        }
                    }
                    .disabled(isLoggingIn || username.isEmpty || password.isEmpty)
                    
                    // MARK: - ✅ Log-Out Button
                    Button {
                        logoutUser()
                    } label: {
                        ZStack {
                            CustomButtonView()
                            Text("Log out")
                                .padding()
                                .font(.body)
                                .foregroundColor(.noteAlmond)
                        }
                    }
                    .disabled(isLoggingIn)
                }
                .padding(.top, 40)
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Notification"),
                        message: Text(alertMessage),
                        dismissButton: .default(Text("OK")) {
                            if alertMessage == "Login Successful!" && noteViewModel.isLogin {
                                showNote = true
                            }
                        }
                    )
                }
                .fullScreenCover(isPresented: $showNote) {
                    NotesView()
                }
                
                // MARK: - ✅ Sign-Up
                NavigationLink(destination: SignUpView()) {
                    Text("Sign Up")
                        .padding()
                        .font(.body)
                        .foregroundColor(.noteMilktea)
                }
                .disabled(isLoggingIn)
                
                Text(byeMsg)
                    .font(.body)
                    .foregroundColor(.noteMilktea)
                    .padding()
            }
            .padding()
        }
    }
    
    // MARK: - Login Function
    private func loginUser() {
        hideKeyboard()
        
        // Don't proceed if fields are empty
        guard !username.isEmpty && !password.isEmpty else {
            alertMessage = "Please enter both username and password"
            showAlert = true
            return
        }
        
        // Set loading state
        isLoggingIn = true
        byeMsg = ""
        
        // Use Task to call async function
        Task {
            await noteViewModel.login(email: username, password: password)
            
            // Update UI on the main thread
            await MainActor.run {
                isLoggingIn = false
                
                if !noteViewModel.showPleaseLogin {
                    // Login successful
                    alertMessage = "Login Successful!"
                    showAlert = true
                    
                    // After alert is dismissed, showNote will be set to true
                } else {
                    // Login failed
                    alertMessage = "Login Failed..."
                    showAlert = true
                }
            }
        }
    }
    
    // MARK: - Logout Function
    private func logoutUser() {
        randomImage()
        
        if noteViewModel.showPleaseLogin {
            byeMsg = "Please log in first!"
        } else {
            noteViewModel.isLogin = false
            byeMsg = "Successfully logged out!"
            noteViewModel.showPleaseLogin = true
            showNote = false
            
            // Clear credentials
            username = ""
            password = ""
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(NotesViewModel())
}
