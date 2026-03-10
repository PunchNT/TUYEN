import SwiftUI

struct LoginView: View {
    
    @AppStorage("isLoggedIn") var isLoggedIn = false
    
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        
        NavigationStack {
            
            VStack(spacing: 25) {
                
                Spacer()
                
                VStack(spacing: 10) {
                    
                    Image("tuyenlogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120)
                    
                    Text("TuYen")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                    
                    Text("Cook Smart, Eat Fresh.")
                        .foregroundColor(.gray)
                        .font(.subheadline)
                }
                
                TextField("Email", text: $email)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                
                SecureField("Password", text: $password)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                
                HStack {
                    Spacer()
                    
                    NavigationLink(destination: ForgotPasswordView()) {
                        Text("Forgot Password?")
                            .font(.caption)
                            .foregroundColor(.green)
                    }
                }
                
                Button {
                    isLoggedIn = true
                } label: {
                    
                    Text("Sign In")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(12)
                }
                
                HStack {
                    
                    Text("Don't have an account?")
                    
                    NavigationLink(destination: SignUpView()) {
                        Text("Sign Up")
                            .foregroundColor(.green)
                            .fontWeight(.bold)
                    }
                }
                
                Spacer()
                
            }
            .padding()
        }
    }
}
