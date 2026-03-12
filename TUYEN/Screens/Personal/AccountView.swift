import SwiftUI

struct AccountView: View {
    @ObservedObject var viewModel: ProfileViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var email = ""
    @State private var name = ""
    @State private var password = "" // 🌟 เป็นค่าว่างแต่แรก จะได้ไม่ต้องมาลบ
    @State private var targetString = "2000"
    
    @State private var isSaving = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isInitializing = true
    
    var body: some View {
        ScrollView {
            VStack(spacing: 25) {
                
                // ------------------------------------
                // 1. โซนรูปโปรไฟล์ด้านบน
                // ------------------------------------
                VStack(spacing: 8) {
                    Circle()
                        .fill(Color(.systemGray5))
                        .frame(width: 90, height: 90)
                        .overlay(
                            Text(name.isEmpty ? "?" : String(name.prefix(1)).uppercased())
                                .font(.system(size: 35, weight: .medium))
                                .foregroundColor(.black)
                        )
                    
                    Text(isInitializing ? "Loading..." : name)
                        .font(.title3)
                        .fontWeight(.bold)
                        .padding(.top, 5)
                    
                    Text(email)
                        .foregroundColor(.gray)
                        .font(.subheadline)
                }
                .padding(.top, 20)
                
                // ------------------------------------
                // 2. โซน Setting
                // ------------------------------------
                VStack(alignment: .leading, spacing: 20) {
                    Text("Setting")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    VStack(alignment: .leading, spacing: 15) {
                        // Email & Name
                        field(title: "Email", text: $email)
                        field(title: "Name", text: $name)
                        
                        // Password
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Password")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            
                            // ใช้เงา Placeholder แบบในรูป
                            SecureField("********", text: $password)
                                .padding()
                                .background(Color.white)
                                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.3), lineWidth: 1))
                        }
                        
                        // 🌟 ช่อง Target (แก้ให้อยู่ตรงกลางตามรูปเป๊ะๆ)
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Target")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            
                            HStack {
                                Spacer()
                                TextField("2000", text: $targetString)
                                    .keyboardType(.numberPad)
                                    .multilineTextAlignment(.center)
                                    .frame(width: 150) // ความกว้างเท่าในรูป
                                    .padding(.vertical, 12)
                                    .background(Color.white)
                                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.3), lineWidth: 1))
                                Spacer()
                            }
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.top, 10)
                
                Spacer(minLength: 30)
                
                // ------------------------------------
                // 3. ปุ่ม Save
                // ------------------------------------
                Button {
                    saveProfile()
                } label: {
                    if isSaving {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .cornerRadius(10)
                    } else {
                        Text("Save")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .disabled(isSaving || isInitializing)
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }) {
                    HStack(spacing: 5) {
                        Image(systemName: "chevron.left")
                        Text("Account")
                    }
                    .foregroundColor(.black)
                    .font(.headline)
                }
            }
        }
        .onAppear {
            loadAccountData()
        }
        .alert("Status", isPresented: $showAlert) {
            Button("OK") {
                if alertMessage.contains("สำเร็จ") || alertMessage.contains("เรียบร้อย") { dismiss() }
            }
        } message: {
            Text(alertMessage)
        }
    }
    
    // UI ตัวช่วยสร้างกล่องกรอกข้อมูล
    func field(title: String, text: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.gray)
            
            TextField("", text: text)
                .padding()
                .background(Color.white)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.3), lineWidth: 1))
        }
    }
    
    func loadAccountData() {
        viewModel.fetchAccountInfo { fetchedEmail, fetchedName, fetchedTarget in
            self.email = fetchedEmail
            self.name = fetchedName
            self.targetString = "\(fetchedTarget)"
            self.password = ""
            self.isInitializing = false
        }
    }
    
    func saveProfile() {
        isSaving = true
        
        // 🌟 ดักเช็ค: ถ้าไม่พิมพ์ Password จะส่งเป็น nil (ไม่เปลี่ยนรหัส)
        let newPassword = password.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : password
        let targetInt = Int(targetString) ?? 2000
        
        viewModel.updateAccount(email: email, name: name, target: targetInt, password: newPassword) { success, message in
            self.isSaving = false
            self.alertMessage = message
            self.showAlert = true
        }
    }
}
