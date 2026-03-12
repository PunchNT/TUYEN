import SwiftUI

struct ForgotPasswordView: View {
    @Environment(\.dismiss) var dismiss
    @State private var email = ""
    @State private var showAlert = false
    
    @StateObject private var authVM = AuthViewModel()
    
    var body: some View {
        ZStack {
            Color(.systemGray6).ignoresSafeArea()
            VStack(spacing: 25) {
                Spacer()
                Image("tuyenlogo").resizable().scaledToFit().frame(width: 120)
                Text("Forgot Password").font(.title).fontWeight(.bold)
                Text("Enter your email to reset password").foregroundColor(.gray)
                
                // เพิ่มช่องกรอกอีเมล
                TextField("Email", text: $email)
                    .padding().background(Color.white).cornerRadius(12)
                    .padding(.horizontal, 30)
                    .autocapitalization(.none)
                
                if !authVM.errorMessage.isEmpty {
                    Text(authVM.errorMessage).foregroundColor(.red).font(.footnote)
                }
                
                Button(action: {
                    authVM.resetPassword(email: email) { success in
                        if success { showAlert = true }
                    }
                }) {
                    if authVM.isLoading {
                        ProgressView().progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .frame(maxWidth: .infinity).padding().background(Color.green).cornerRadius(14)
                    } else {
                        Text("Reset Password").fontWeight(.bold).frame(maxWidth: .infinity)
                            .padding().background(Color.green).foregroundColor(.white).cornerRadius(14)
                    }
                }
                .padding(.horizontal, 30).padding(.top, 10)
                
                Spacer()
            }
        }
        .alert("Notification", isPresented: $showAlert) {
            Button("OK") { dismiss() } // กลับหน้า Login
        } message: {
            Text(authVM.successMessage) // ขึ้นข้อความ "รีเซ็ตรหัสผ่านเป็น 1234..."
        }
    }
}
