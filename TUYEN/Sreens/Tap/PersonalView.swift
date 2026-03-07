import SwiftUI

struct PersonalView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State private var email: String = ""
    @State private var name: String = ""
    @State private var password: String = ""
    @State private var target: String = ""
    
    var body: some View {
        ScrollView {
            
            VStack(alignment: .leading, spacing: 20) {
                
                // Top bar
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "arrow.left")
                            .font(.title3)
                            .foregroundColor(.black)
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .clipShape(Circle())
                    }
                    
                    Text("Account")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Spacer()
                }
                .padding(.top)
                
                
                // Profile Section
                VStack(spacing: 10) {
                    
                    ZStack {
                        Circle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(width: 120, height: 120)
                        
                        Text("C")
                            .font(.system(size: 50))
                            .fontWeight(.medium)
                    }
                    
                    Text("Chef Scientist")
                        .font(.title3)
                        .fontWeight(.semibold)
                    
                    Text("chef@smartfridge.app")
                        .foregroundColor(.gray)
                    
                    Button("Edit Profile") {
                        
                    }
                    .padding(.horizontal, 15)
                    .padding(.vertical, 6)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(15)
                    
                }
                .frame(maxWidth: .infinity)
                
                
                // Setting
                Text("Setting")
                    .font(.title3)
                    .fontWeight(.semibold)
                
                
                VStack(spacing: 15) {
                    
                    VStack(alignment: .leading) {
                        Text("Email")
                            .font(.subheadline)
                        
                        TextField("", text: $email)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(8)
                            .shadow(color: .black.opacity(0.1), radius: 2)
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Name")
                            .font(.subheadline)
                        
                        TextField("", text: $name)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(8)
                            .shadow(color: .black.opacity(0.1), radius: 2)
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Password")
                            .font(.subheadline)
                        
                        SecureField("", text: $password)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(8)
                            .shadow(color: .black.opacity(0.1), radius: 2)
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Target")
                            .font(.subheadline)
                        
                        TextField("", text: $target)
                            .frame(width: 120)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(8)
                            .shadow(color: .black.opacity(0.1), radius: 2)
                    }
                    
                }
                
                
                // Save Button
                Button {
                    
                } label: {
                    Text("Save")
                        .foregroundColor(.white)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(10)
                }
                .padding(.top, 20)
                
                
            }
            .padding()
        }
        .background(Color(.systemGray6))
    }
}

#Preview {
    PersonalView()
}
