import SwiftUI

struct ForgotPasswordView: View {
    
    @Environment(\.dismiss) var dismiss
    @State private var showAlert = false
    @State private var newPassword = ""
    
    var body: some View {
        
        ZStack {
            
            Color(.systemGray6)
                .ignoresSafeArea()
            
            VStack(spacing: 25) {
                
                Spacer()
                
                // LOGO
                Image("tuyenlogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120)
                
                // TITLE
                Text("Forgot Password")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("Press reset to generate new password")
                    .foregroundColor(.gray)
                
                // BUTTON
                Button(action: {
                    
                    newPassword = generatePassword()
                    showAlert = true
                    
                }) {
                    
                    Text("Reset Password")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(14)
                }
                .padding(.horizontal, 30)
                .padding(.top, 20)
                
                Spacer()
            }
        }
        
        // ALERT SHOW PASSWORD
        .alert("New Password: \(newPassword)", isPresented: $showAlert) {
            Button("OK") {
                dismiss() // กลับหน้า Login
            }
        }
    }
    
    // FIXED PASSWORD
    func generatePassword() -> String {
        return "1234"
    }
    }


#Preview {
    ForgotPasswordView()
}
