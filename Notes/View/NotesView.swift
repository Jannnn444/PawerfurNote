import SwiftUI

struct NotesView: View {
    @ObservedObject var noteViewModel = NotesViewModel()
    // Add a loading state
    @State private var isLoading: Bool = true
    @State var showConfirmationDialogue: Bool = false
    @State private var selectedNote: Note?
    @State private var isCreatingNote = false
    @State private var isHeadToHome = false
    
    // For login form
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var phone: String = ""

    var body: some View {
        ZStack {
            Color(.noteMilktea).edgesIgnoringSafeArea(.all)
            
            VStack {
                // Header section remains the same
                HStack {
                    Text("♡♥︎ Notes ♥︎♡")
                        .fontDesign(.rounded)
                        .foregroundStyle(.noteAlmond)
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                    Spacer()
                    Button {
                        isHeadToHome = true
                    } label: {
                        Image(systemName: "house")
                            .font(.title)
                            .foregroundColor(.noteAlmond)
                    }
                    
                    Spacer()
                    
                    // Only show the add button when logged in and not loading
                    if noteViewModel.isLogin && !isLoading {
                        Button {
                            isCreatingNote = true
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .font(.title)
                                .foregroundColor(.noteAlmond)
                        }
                    }
                    Spacer()
                }.padding()
                
                // Show loading indicator while processing
                if isLoading {
                    Spacer()
                    ProgressView()
                        .scaleEffect(1.5)
                        .progressViewStyle(CircularProgressViewStyle(tint: .noteAlmond))
                    Spacer()
                }
                // Content section - only shown when not loading
                else if noteViewModel.isLogin {
                    // Notes list when logged in
                    List {
                        ForEach(noteViewModel.notes) { note in
                            Button {
                                selectedNote = note
                            } label: {
                                ListCellView(note: note)
                                    .padding()
                            }
                            .listRowSeparator(.hidden)
                        }
                        .onDelete { indexSet in
                            indexSet.forEach { index in
                                let noteToDelete = noteViewModel.notes[index]
                                Task {
                                    await noteViewModel.deleteNote(noteToDelete)
                                }
                            }
                        }
                        .listRowBackground(Color.clear)
                    }
                    .scrollContentBackground(.hidden)
                    .background(Color(.noteAlmond))
                } else {
                    // Login form remains the same
                    VStack(spacing: 20) {
                        // Your existing login form code
                        Text("Please Sign up")
                            .font(.title)
                            .foregroundColor(.noteAlmond)
                        
                        TextField("Name", text: $name)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)
                            .autocapitalization(.none)
                        
                        TextField("Email", text: $email)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)
                            .autocapitalization(.none)
                        
                        SecureField("Password", text: $password)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)
                        
                        SecureField("Password", text: $phone)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)
                    }
                        Button("Sign Up") {
                            Task {
                                await noteViewModel.signup(name: name, email: email, password: password, phone: phone)
                            }
                        }
                            .padding()
                            .background(Color.noteMilktea.opacity(0.7))
                            .cornerRadius(15)
                            .padding(.horizontal)
                        }
                        
                        // Show any error messages
                        if let errorMessage = noteViewModel.errorMessages {
                            Text(errorMessage)
                                .foregroundColor(.red)
                                .padding()
                        }
                    }
                    .padding(.top, 30)
                    .sheet(item: $selectedNote) { note in
                        EditNotesView(noteViewModel: noteViewModel, note: note)
                    }
                    .sheet(isPresented: $isCreatingNote) {
                        EditNotesView(noteViewModel: noteViewModel, note: Note(id: "", title: "Title", content: "Content", favorite: false, created_at: "", updated_at: ""))
                    }
                }
                .ignoresSafeArea()
                .background(.noteAlmond)
                .onAppear {
                    Task {
                        // Show loading state first
                        isLoading = true
                        
                        // Wait for 2 seconds to let the system process
                        try? await Task.sleep(nanoseconds: 2_000_000_000)
                        
                        // Then fetch notes if logged in
                        if noteViewModel.isLogin {
                            await noteViewModel.getNotes()
                        }
                        
                        // Finally turn off loading state
                        isLoading = false
                    }
                }
                .fullScreenCover(isPresented: $isHeadToHome) {
                    ContentView()
                }
            }
            
    private func deleteNote(at offsets: IndexSet) {
        for index in offsets {
            let noteToDelete = noteViewModel.notes[index]
            Task {
                await noteViewModel.deleteNote(noteToDelete)
            }
        }
    }

    private func createNote() {
        let newTitle = "New Note"
        let newContent = ""
        
        Task {
            await noteViewModel.postNotes(title: newTitle, content: newContent)
            await noteViewModel.getNotes()
        }
    }
}
