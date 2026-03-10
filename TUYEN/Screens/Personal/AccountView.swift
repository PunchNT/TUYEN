import SwiftUI

struct AccountView: View {
    
    @EnvironmentObject var userData: UserData
    @Environment(\.dismiss) var dismiss
    
    @State private var email = "Ohm@gmail.com"
    @State private var password = "12345678"
    
    var body: some View {
        
        ScrollView {
            
            VStack(spacing: 20) {
                
                Circle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 90, height: 90)
                    .overlay(
                        Text(String(userData.name.prefix(1)))
                            .font(.largeTitle)
                    )
                
                Text(userData.name)
                    .font(.title3)
                    .fontWeight(.semibold)
                
                Text(email)
                    .foregroundColor(.gray)
                
                
                VStack(spacing: 15) {
                    
                    field(title: "Email", text: $email)
                    
                    field(title: "Name", text: $userData.name)
                    
                    field(title: "Password", text: $password)
                    
                    HStack {
                        Text("Target")
                        
                        Spacer()
                        
                        TextField("", value: $userData.target, format: .number)
                            .frame(width: 80)
                            .textFieldStyle(.roundedBorder)
                    }
                    
                }
                .padding()
                
                
                Button {
                    save()
                } label: {
                    Text("Save")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .padding(.horizontal)
            }
            .padding()
        }
        .navigationTitle("Account")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func field(title: String, text: Binding<String>) -> some View {
        
        VStack(alignment: .leading) {
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
            
            TextField("", text: text)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
        }
    }
    
    
    func save() {
        
        UserDefaults.standard.set(userData.name, forKey: "name")
        UserDefaults.standard.set(userData.target, forKey: "target")
        
        dismiss()   
    }
}
