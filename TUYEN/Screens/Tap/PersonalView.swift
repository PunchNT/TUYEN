import SwiftUI

struct Personal: View {
    
    @StateObject var userData = UserData()
    
    @AppStorage("isLoggedIn") var isLoggedIn = true
    
    @State private var showAllergyPopup = false
    @State private var showDietPopup = false
    
    var body: some View {
        
        ZStack {
            
            ScrollView {
                
                VStack(spacing: 20) {
                    
                    // Header
                    HStack {
                        Text("Personal information")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Spacer()
                        
                        Image(systemName: "gearshape")
                    }
                    .padding(.horizontal)
                    
                    
                    // Profile Card
                    NavigationLink(destination: AccountView().environmentObject(userData)) {
                        
                        VStack(alignment: .leading, spacing: 15) {
                            
                            HStack {
                                
                                Circle()
                                    .fill(Color.white.opacity(0.2))
                                    .frame(width: 45, height: 45)
                                    .overlay(
                                        Text(String(userData.name.prefix(1)))
                                            .foregroundColor(.white)
                                    )
                                
                                Text(userData.name)
                                    .foregroundColor(.white)
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.white.opacity(0.7))
                            }
                            
                            Text("Total calories (target \(userData.target))")
                                .foregroundColor(.white.opacity(0.7))
                                .font(.caption)
                            
                            HStack {
                                
                                Text("12")
                                    .font(.system(size: 34, weight: .bold))
                                    .foregroundColor(.white)
                                
                                Spacer()
                                
                                Text("Calories")
                                    .foregroundColor(.green)
                            }
                            
                            ProgressView(value: 12, total: Double(userData.target))
                                .tint(.green)
                        }
                        .padding()
                        .background(
                            LinearGradient(
                                colors: [Color.green.opacity(0.8), Color.black],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .cornerRadius(18)
                    }
                    .padding(.horizontal)
                    
                    
                    // Food Allergies
                    VStack(alignment: .leading, spacing: 10) {
                        
                        HStack {
                            Text("Food allergies")
                                .fontWeight(.semibold)
                            
                            Spacer()
                            
                            Button {
                                showAllergyPopup = true
                            } label: {
                                Image(systemName: "plus.circle.fill")
                                    .foregroundColor(.green)
                            }
                        }
                        
                        ForEach(userData.allergies, id: \.self) { item in
                            Text(item)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(10)
                        }
                    }
                    .padding(.horizontal)
                    
                    
                    // Diet Type
                    VStack(alignment: .leading, spacing: 10) {
                        
                        HStack {
                            Text("Diet type")
                                .fontWeight(.semibold)
                            
                            Spacer()
                            
                            Button {
                                showDietPopup = true
                            } label: {
                                Image(systemName: "plus.circle.fill")
                                    .foregroundColor(.green)
                            }
                        }
                        
                        ForEach(userData.diets, id: \.self) { item in
                            Text(item)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(10)
                        }
                    }
                    .padding(.horizontal)
                    
                    
                    // Sign Out
                    Button {
                        isLoggedIn = false
                    } label: {
                        
                        HStack {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                            Text("Sign Out")
                        }
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red.opacity(0.15))
                        .cornerRadius(12)
                    }
                    .padding(.horizontal)
                }
                .padding(.top)
            }
            
            
            // Allergy Popup
            if showAllergyPopup {
                
                AddPopupView(
                    title: "Food allergy",
                    onAdd: { value in
                        userData.allergies.append(value)
                        showAllergyPopup = false
                    },
                    onCancel: {
                        showAllergyPopup = false
                    }
                )
                .background(Color.black.opacity(0.35).ignoresSafeArea())
            }
            
            
            // Diet Popup
            if showDietPopup {
                
                AddPopupView(
                    title: "Diet type",
                    onAdd: { value in
                        userData.diets.append(value)
                        showDietPopup = false
                    },
                    onCancel: {
                        showDietPopup = false
                    }
                )
                .background(Color.black.opacity(0.35).ignoresSafeArea())
            }
        }
    }
}
