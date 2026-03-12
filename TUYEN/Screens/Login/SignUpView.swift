import SwiftUI

struct SignUpView: View {
    @Environment(\.dismiss) var dismiss
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    
    @StateObject private var authVM = AuthViewModel()
    @State private var showAlert = false
    
    var body: some View {
        VStack {
            Spacer()
            Image("tuyenlogo").resizable().scaledToFit().frame(width: 140)
            Text("TuYen").font(.system(size: 34, weight: .bold)).foregroundColor(.green)
            Text("Join TuYen today.").foregroundColor(.gray).padding(.bottom, 30)
            
            HStack { Image(systemName: "person").foregroundColor(.gray); TextField("Name", text: $name) }
                .padding().background(Color(.systemGray6)).cornerRadius(12).padding(.horizontal, 30)
            
            HStack { Image(systemName: "envelope").foregroundColor(.gray); TextField("Email", text: $email).autocapitalization(.none) }
                .padding().background(Color(.systemGray6)).cornerRadius(12).padding(.horizontal, 30)
            
            HStack { Image(systemName: "lock").foregroundColor(.gray); SecureField("Password", text: $password) }
                .padding().background(Color(.systemGray6)).cornerRadius(12).padding(.horizontal, 30)
            
            // แจ้งเตือนเออเร่อ (เช่น อีเมลซ้ำ)
            if !authVM.errorMessage.isEmpty {
                Text(authVM.errorMessage).foregroundColor(.red).font(.footnote)
            }
            
            Button {
                authVM.register(name: name, email: email, password: password) { success in
                    if success {
                        showAlert = true // สมัครผ่าน เด้งป๊อปอัปบอก
                    }
                }
            } label: {
                if authVM.isLoading {
                    ProgressView().progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .frame(maxWidth: .infinity).padding().background(Color.green).cornerRadius(14)
                } else {
                    Text("Sign Up").foregroundColor(.white).fontWeight(.semibold)
                        .frame(maxWidth: .infinity).padding().background(Color.green).cornerRadius(14)
                }
            }
            .padding(.horizontal, 30).padding(.top, 20)
            
            HStack {
                Text("Already have an account?")
                Button { dismiss() } label: { Text("Sign In").foregroundColor(.green).fontWeight(.semibold) }
            }.font(.footnote).padding(.top, 10)
            Spacer()
        }
        .navigationBarBackButtonHidden(true)
        .alert("Success", isPresented: $showAlert) {
            Button("OK") { dismiss() } // กด OK แล้วเด้งกลับหน้า Login
        } message: {
            Text(authVM.successMessage)
        }
    }
}
