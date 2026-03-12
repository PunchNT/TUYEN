import SwiftUI

struct LoginView: View {
    @AppStorage("isLoggedIn") var isLoggedIn = false
    @State private var email = ""
    @State private var password = ""
    
    // เรียกใช้ ViewModel
    @StateObject private var authVM = AuthViewModel()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 25) {
                Spacer()
                
                VStack(spacing: 10) {
                    Image("tuyenlogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120)
                    Text("TuYen").font(.title).fontWeight(.bold).foregroundColor(.green)
                    Text("Cook Smart, Eat Fresh.").foregroundColor(.gray).font(.subheadline)
                }
                
                TextField("Email", text: $email)
                    .padding().background(Color(.systemGray6)).cornerRadius(12)
                    .autocapitalization(.none) // ป้องกันพิมพ์ใหญ่ตัวแรกอัตโนมัติ
                
                SecureField("Password", text: $password)
                    .padding().background(Color(.systemGray6)).cornerRadius(12)
                
                HStack {
                    Spacer()
                    NavigationLink(destination: ForgotPasswordView()) {
                        Text("Forgot Password?").font(.caption).foregroundColor(.green)
                    }
                }
                
                // แจ้งเตือนถ้ารหัสผิด
                if !authVM.errorMessage.isEmpty {
                    Text(authVM.errorMessage).foregroundColor(.red).font(.footnote)
                }
                
                Button {
                    // 🌟 เปลี่ยนมาใช้แบบมีวงเล็บปีกกา เพื่อรับสัญญาณว่าสำเร็จไหม
                    authVM.login(email: email, password: password) { success in
                        if success {
                            // 🌟 ถ้าสำเร็จ สั่งเปลี่ยนสถานะตรงนี้เลย หน้าจอจะสลับทันที!
                            isLoggedIn = true
                        }
                    }
                               
                } label: {
                    if authVM.isLoading {
                        ProgressView().progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .frame(maxWidth: .infinity).padding().background(Color.green).cornerRadius(12)
                    } else {
                        Text("Sign In").foregroundColor(.white).frame(maxWidth: .infinity)
                            .padding().background(Color.green).cornerRadius(12)
                    }
                }
                
                HStack {
                    Text("Don't have an account?")
                    NavigationLink(destination: SignUpView()) {
                        Text("Sign Up").foregroundColor(.green).fontWeight(.bold)
                    }
                }
                Spacer()
            }
            .padding()
        }
    }
}
