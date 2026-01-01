import SwiftUI

struct LogIN: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var isLoggedIn: Bool = false
    @State private var showingAlert: Bool = false
    
    private let validUsername = "daniel"
    private let validPassword = "admin"
    
    var body: some View {
        NavigationStack {
            if isLoggedIn {
                CreazioneAnnuncioWrapper(username: username)
            } else {
                ZStack {
                    Color(UIColor.systemGroupedBackground).ignoresSafeArea()
                    
                    VStack(spacing: 30) {
                        Text("Accedi")
                            .font(.system(size: 40, weight: .bold))
                            .foregroundColor(.primary)
                            .padding(.top, 50)
                        
                        VStack(spacing: 20) {
                            CustomTextField(
                                placeholder: "Username (\(validUsername))",
                                text: $username,
                                iconName: "person.fill"
                            )
                            
                            CustomSecureField(
                                placeholder: "Password (\(validPassword))",
                                text: $password,
                                iconName: "lock.fill"
                            )
                        }
                        .padding(.horizontal)
                        
                        Spacer()
                        
                        Button(action: {
                            authenticateUser()
                        }) {
                            Text("LOGIN")
                                .font(.title3).fontWeight(.bold).foregroundColor(.white)
                                .frame(maxWidth: .infinity).frame(height: 60)
                                .background(isLoginEnabled ? Color.blue : Color.gray.opacity(0.5))
                                .cornerRadius(15)
                                .shadow(radius: 5)
                        }
                        .disabled(!isLoginEnabled)
                        .padding(.horizontal)
                    }
                    .alert("Accesso Fallito", isPresented: $showingAlert) {
                        Button("OK", role: .cancel) {}
                    } message: {
                        Text("Username o Password errati. Le credenziali sono '\(validUsername)' e '\(validPassword)'.")
                    }
                }
            }
        }
    }
    
    var isLoginEnabled: Bool {
        !username.isEmpty && !password.isEmpty
    }
    
    func authenticateUser() {
        if username == validUsername, password == validPassword {
            withAnimation {
                isLoggedIn = true
            }
        } else {
            showingAlert = true
            password = ""
        }
    }
}

struct CustomTextField: View {
    let placeholder: String
    @Binding var text: String
    let iconName: String
    
    var body: some View {
        HStack {
            Image(systemName: iconName)
                .foregroundColor(.secondary)
            
            TextField(placeholder, text: $text)
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
                .keyboardType(.default)
        }
        .padding()
        .frame(height: 55)
        .background(Color(UIColor.secondarySystemGroupedBackground))
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(text.isEmpty ? Color.clear : Color.blue, lineWidth: 1)
        )
    }
}

struct CustomSecureField: View {
    let placeholder: String
    @Binding var text: String
    let iconName: String
    
    var body: some View {
        HStack {
            Image(systemName: iconName)
                .foregroundColor(.secondary)
            
            SecureField(placeholder, text: $text)
        }
        .padding()
        .frame(height: 55)
        .background(Color(UIColor.secondarySystemGroupedBackground))
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(text.isEmpty ? Color.clear : Color.blue, lineWidth: 1)
        )
    }
}

struct CreazioneAnnuncioWrapper: View {
    let username: String
    @State private var showSuccessMessage: Bool = true
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        if showSuccessMessage {
            ZStack {
                // Sfondo dinamico: Blu in Light Mode, Nero/Grigio scuro in Dark Mode
                (colorScheme == .dark ? Color(UIColor.systemBackground) : Color.blue)
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    Image(systemName: "checkmark.seal.fill")
                        .resizable().frame(width: 100, height: 100)
                        .foregroundColor(colorScheme == .dark ? .blue : .white)
                    
                    Text("Bentornato \(username)!")
                        .font(.largeTitle).fontWeight(.bold)
                        .foregroundColor(colorScheme == .dark ? .primary : .white)
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    withAnimation { showSuccessMessage = false }
                }
            }
        } else {
            MainMenu(username: username)
        }
    }
}

struct LogIN_Previews: PreviewProvider {
    static var previews: some View {
        LogIN()
            .preferredColorScheme(.light)
        LogIN()
            .preferredColorScheme(.dark)
    }
}
