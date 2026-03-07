import SwiftUI

struct LoginView: View {
    
    @Binding var isLoggedIn: Bool
    
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        
        NavigationStack {
            
            VStack {
                
                Spacer()
                
                Image("tuyen_logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120)
                
                Text("TuYen")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.green)
                
                Text("Cook Smart, Eat Fresh.")
                    .foregroundColor(.gray)
                    .padding(.bottom, 30)
                
                
                HStack {
                    Image(systemName: "envelope")
                        .foregroundColor(.gray)
                    
                    TextField("Email", text: $email)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal, 30)
                
                
                HStack {
                    Image(systemName: "lock")
                        .foregroundColor(.gray)
                    
                    SecureField("Password", text: $password)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal, 30)
                
                
                HStack {
                    Spacer()
                    
                    Text("Forgot Password?")
                        .foregroundColor(.green)
                        .font(.footnote)
                }
                .padding(.horizontal, 30)
                
                
                Button {
                    isLoggedIn = true
                } label: {
                    Text("Sign In")
                        .foregroundColor(.white)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.black)
                        .cornerRadius(12)
                }
                .padding(.horizontal, 30)
                .padding(.top, 10)
                
                
                HStack {
                    Text("Don’t have an account?")
                    
                    NavigationLink(destination: SignUpView()) {
                        Text("Sign Up")
                            .foregroundColor(.green)
                            .fontWeight(.semibold)
                    }
                }
                .font(.footnote)
                .padding(.top, 10)
                
                
                Spacer()
                
                Text("AdminTuYen@gmail.com")
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .padding(.bottom, 20)
            }
        }
    }
}

#Preview {
    LoginView(isLoggedIn: .constant(false))
}

