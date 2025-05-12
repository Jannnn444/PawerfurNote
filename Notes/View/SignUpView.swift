//
//  SuccessLoginView.swift
//  Notes
//
//  Created by Hualiteq International on 2025/3/4.
//

//
//  SignUpView.swift
//  Notes
//
//  Created by Hualiteq International on 2025/3/4.
//  Refactored to use async/await pattern
//

import SwiftUI

struct SignUpView: View {
    @EnvironmentObject var noteViewModel: NotesViewModel
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var phone: String = ""
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isSigningUp = false
    
    var body: some View {
        VStack {
            Text("Sign Up Right now!")
                .padding()
                .background(.noteMilktea)
                .frame(width: 130, height: 80)
            
            TextField("Name", text: $name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .frame(width: 300)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.none)
                .submitLabel(.next)
               
            TextField("Phone", text: $phone)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .frame(width: 300)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.none)
                .submitLabel(.next)
            
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .frame(width: 300)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.none)
                .submitLabel(.next)
                .keyboardType(.emailAddress)
            
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .frame(width: 300)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.none)
                .submitLabel(.done)
                .onSubmit {
                    hideKeyboard()
                    signUpUser()
                }
            
            Button {
                hideKeyboard()
                signUpUser()
            } label: {
                ZStack {
                    CustomButtonView()
                    if isSigningUp {
                        ProgressView()
                            .tint(.noteAlmond)
                    } else {
                        Text("Create")
                            .padding()
                            .foregroundColor(.noteAlmond)
                    }
                }
            }
            .disabled(isSigningUp || name.isEmpty || email.isEmpty || password.isEmpty || phone.isEmpty)
            
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text(noteViewModel.isCreated ? "Success!" : "Error"),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
    
    private func signUpUser() {
        guard !name.isEmpty && !email.isEmpty && !password.isEmpty && !phone.isEmpty else {
            alertMessage = "Please fill in all fields"
            showAlert = true
            return
        }
        
        // Set signing up state
        isSigningUp = true
        
        // Use Task to call async function
        Task {
            await noteViewModel.signup(name: name, email: email, password: password, phone: phone)
            
            // Update UI on the main thread
            await MainActor.run {
                isSigningUp = false
                
                if noteViewModel.isCreated {
                    alertMessage = "Account created successfully!"
                } else {
                    alertMessage = noteViewModel.errorMessages ?? "Account creation failed."
                }
                
                showAlert = true
            }
        }
    }
}


// Preview
#Preview {
    SignUpView()
        .environmentObject(NotesViewModel())
}
