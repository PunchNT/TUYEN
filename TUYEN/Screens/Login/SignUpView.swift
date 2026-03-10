import SwiftUI

struct SignUpView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        
        VStack {
            
            Spacer()
            
            // LOGO
            Image("tuyenlogo")
                .resizable()
                .scaledToFit()
                .frame(width: 140)
            
            Text("TuYen")
                .font(.system(size: 34, weight: .bold))
                .foregroundColor(.green)
            
            Text("Join TuYen today.")
                .foregroundColor(.gray)
                .padding(.bottom, 30)
            
            
            // NAME
            HStack {
                Image(systemName: "person")
                    .foregroundColor(.gray)
                
                TextField("Name", text: $name)
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
            .padding(.horizontal, 30)
            
            
            // EMAIL
            HStack {
                Image(systemName: "envelope")
                    .foregroundColor(.gray)
                
                TextField("Email", text: $email)
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
            .padding(.horizontal, 30)
            
            
            // PASSWORD
            HStack {
                Image(systemName: "lock")
                    .foregroundColor(.gray)
                
                SecureField("Password", text: $password)
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
            .padding(.horizontal, 30)
            
            
            // SIGN UP BUTTON
            Button {
                // เมื่อกด Sign Up ให้กลับไปหน้า LoginView
                dismiss()
            } label: {
                Text("Sign Up")
                    .foregroundColor(.white)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(14)
            }
            .padding(.horizontal, 30)
            .padding(.top, 20)
            
            
            // BACK TO LOGIN
            HStack {
                Text("Already have an account?")
                
                Button {
                    dismiss()
                } label: {
                    Text("Sign In")
                        .foregroundColor(.green)
                        .fontWeight(.semibold)
                }
            }
            .font(.footnote)
            .padding(.top, 10)
            
            
            Spacer()
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    SignUpView()
}
