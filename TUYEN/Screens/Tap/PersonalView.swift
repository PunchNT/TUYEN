import SwiftUI

struct Personal: View {
    @StateObject var viewModel = ProfileViewModel()
    @AppStorage("isLoggedIn") var isLoggedIn = true
    
    @State private var showAllergyPopup = false
    @State private var showDietPopup = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.white.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 25) {
                        
                        // Header
                        HStack {
                            Text("Personal information")
                                .font(.title2)
                                .fontWeight(.bold)
                            Spacer()
                            NavigationLink(destination: AccountView(viewModel: viewModel)) {
                                Image(systemName: "gearshape")
                                    .font(.title2)
                                    .foregroundColor(.black)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 10)
                        
                        // 🌟 Profile & Calories Card (เอาสีเขียว Gradient กลับมาแล้ว!)
                        NavigationLink(destination: AccountView(viewModel: viewModel)) {
                            VStack(alignment: .leading, spacing: 15) {
                                HStack {
                                    Circle()
                                        .fill(Color.white.opacity(0.2))
                                        .frame(width: 50, height: 50)
                                        .overlay(
                                            Text(viewModel.name.isEmpty ? "?" : String(viewModel.name.prefix(1)).uppercased())
                                                .foregroundColor(.white)
                                                .font(.title2)
                                        )
                                    
                                    Text(viewModel.name)
                                        .foregroundColor(.white)
                                        .font(.title3)
                                        .fontWeight(.bold)
                                        .padding(.leading, 5)
                                    
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.white.opacity(0.8))
                                }
                                
                                Text("Total calories (target \(viewModel.targetCal))")
                                    .foregroundColor(.white.opacity(0.7))
                                    .font(.caption)
                                    .padding(.top, 5)
                                
                                HStack(alignment: .bottom) {
                                    Text("\(viewModel.consumedCal)")
                                        .font(.system(size: 40, weight: .bold))
                                        .foregroundColor(.white)
                                    
                                    Spacer()
                                    
                                    Text("Calories")
                                        .foregroundColor(.green)
                                        .fontWeight(.bold)
                                        .padding(.bottom, 6)
                                }
                                
                                // หลอด Progress Bar ปลายมน
                                let target = Double(viewModel.targetCal) > 0 ? Double(viewModel.targetCal) : 2000.0
                                let consumed = Double(viewModel.consumedCal)
                                let progressPercentage = min(consumed / target, 1.0)
                                
                                GeometryReader { geometry in
                                    ZStack(alignment: .leading) {
                                        Capsule()
                                            .fill(Color.white.opacity(0.3))
                                            .frame(width: geometry.size.width, height: 8)
                                        
                                        Capsule()
                                            .fill(Color.green)
                                            .frame(width: max(0, geometry.size.width * CGFloat(progressPercentage)), height: 8)
                                    }
                                }
                                .frame(height: 8)
                            }
                            .padding(20)
                            .frame(maxWidth: .infinity)
                            // 🌟 รหัสสี Gradient ดั้งเดิมที่คุณต้องการ
                            .background(
                                LinearGradient(
                                    colors: [Color.green.opacity(0.8), Color.black],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .cornerRadius(20)
                        }
                        .padding(.horizontal)
                        
                        // Food Allergies Section
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Text("Food allergies")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                Spacer()
                                Button { showAllergyPopup = true } label: {
                                    Image(systemName: "plus.circle")
                                        .foregroundColor(.green)
                                        .font(.title2)
                                }
                            }
                            
                            if viewModel.allergies.isEmpty {
                                Text("No allergies added")
                                    .foregroundColor(.gray)
                                    .font(.subheadline)
                            } else {
                                ForEach(viewModel.allergies, id: \.self) { item in
                                    HStack {
                                        Text(item).foregroundColor(.black)
                                        Spacer()
                                        Button { viewModel.removeAllergy(item) } label: {
                                            Image(systemName: "trash").foregroundColor(.red.opacity(0.7))
                                        }
                                    }
                                    .padding()
                                    .background(Color.white)
                                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.2), lineWidth: 1))
                                }
                            }
                        }
                        .padding(.horizontal)
                        
                        // Diet Type Section
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Text("Diet type")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                Spacer()
                                Button { showDietPopup = true } label: {
                                    Image(systemName: "plus.circle")
                                        .foregroundColor(.green)
                                        .font(.title2)
                                }
                            }
                            
                            if viewModel.diets.isEmpty {
                                Text("No diet types added")
                                    .foregroundColor(.gray)
                                    .font(.subheadline)
                            } else {
                                ForEach(viewModel.diets, id: \.self) { item in
                                    HStack {
                                        Text(item).foregroundColor(.black)
                                        Spacer()
                                        Button { viewModel.removeDiet(item) } label: {
                                            Image(systemName: "trash").foregroundColor(.red.opacity(0.7))
                                        }
                                    }
                                    .padding()
                                    .background(Color.white)
                                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.2), lineWidth: 1))
                                }
                            }
                        }
                        .padding(.horizontal)
                        
                        // Sign Out Button
                        Button {
                            isLoggedIn = false
                        } label: {
                            HStack {
                                Image(systemName: "rectangle.portrait.and.arrow.right")
                                Text("Sign Out")
                            }
                            .font(.headline)
                            .foregroundColor(Color(red: 0.9, green: 0.3, blue: 0.3))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red.opacity(0.1))
                            .cornerRadius(10)
                        }
                        .padding(.horizontal)
                        .padding(.top, 10)
                        
                    }
                    .padding(.bottom, 30)
                }
                
                // Popups
                if showAllergyPopup {
                    AddPopupView(title: "Food allergy", onAdd: { value in
                        viewModel.addAllergy(value)
                        showAllergyPopup = false
                    }, onCancel: { showAllergyPopup = false })
                    .background(Color.black.opacity(0.4).ignoresSafeArea())
                }
                if showDietPopup {
                    AddPopupView(title: "Diet type", onAdd: { value in
                        viewModel.addDiet(value)
                        showDietPopup = false
                    }, onCancel: { showDietPopup = false })
                    .background(Color.black.opacity(0.4).ignoresSafeArea())
                }
            }
            .onAppear {
                viewModel.fetchProfile()
            }
        }
    }
}
