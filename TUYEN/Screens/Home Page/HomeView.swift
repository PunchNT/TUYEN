import SwiftUI

struct HomeView: View {
    
    @State private var showPopup = false
    @StateObject private var viewModel = HomeViewModel()
    
    // 🌟 เพิ่ม 2 ตัวแปรนี้สำหรับเช็กการกดปุ่มและเปลี่ยนหน้า
    @State private var showAlert = false
    @State private var navigateToMenuResults = false
    
    var body: some View {
        NavigationStack { // 🌟 ตรวจสอบให้แน่ใจว่ามี NavigationStack ครอบอยู่
            ZStack {
                VStack(alignment: .leading, spacing: 10) {
                    
                    // Header
                    HStack {
                        Image("tuyenlogo")
                            .resizable()
                            .frame(width: 40, height: 40)
                        
                        VStack(alignment: .leading) {
                            Text("My TuYen")
                                .font(.title)
                                .fontWeight(.bold)
                            Text("TuYen")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                        Button {
                            showPopup = true
                        } label: {
                            Image(systemName: "plus")
                                .font(.title3)
                                .foregroundColor(.white)
                                .padding(12)
                                .background(Color.green)
                                .clipShape(Circle())
                        }
                    }
                    .padding(.horizontal)
                    
                    // 🌟 🔔 Expired Notification (ดีไซน์ใหม่ให้เหมือนรูป)
                    if hasExpiredIngredient {
                        HStack(spacing: 12) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.orange.opacity(0.3))
                                    .frame(width: 45, height: 45)
                                Image(systemName: "alarm")
                                    .foregroundColor(.orange)
                                    .font(.title2)
                            }
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Expired notification")
                                    .font(.headline)
                                    .foregroundColor(.black)
                                Text("\(expiredIngredientName) will expire in \(expiredDay) days!!")
                                    .font(.subheadline)
                                    .foregroundColor(.black.opacity(0.7))
                            }
                            Spacer()
                        }
                        .padding()
                        .background(Color.orange.opacity(0.08))
                        .cornerRadius(12)
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.orange.opacity(0.8), lineWidth: 1.5))
                        .padding(.horizontal)
                    }
                    
                    // Main Content (List)
                    ZStack {
                        if viewModel.ingredients.isEmpty {
                            VStack(spacing:10){
                                Image(systemName: "refrigerator")
                                    .font(.system(size:50))
                                    .foregroundColor(.gray.opacity(0.6))
                                Text("No ingredients yet")
                                    .font(.headline)
                                Text("Tap + to add ingredients")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        } else {
                            List {
                                ForEach($viewModel.ingredients) { $ingredient in
                                    IngredientCard(
                                        ingredient: $ingredient,
                                        onDelete: {
                                            deleteIngredient(ingredient)
                                        }
                                    )
                                    .listRowSeparator(.hidden)
                                    .listRowBackground(Color.clear)
                                }
                            }
                            .listStyle(.plain)
                            .scrollContentBackground(.hidden)
                        }
                    }
                    .frame(maxHeight: .infinity)
                    
                    // 🌟 ปุ่ม Find Menu
                    Button {
                        // 1. เช็กว่ามีการติ๊กเลือกวัตถุดิบไหม
                        let selectedItems = viewModel.ingredients.filter { $0.isSelected }
                        
                        if selectedItems.isEmpty {
                            // ถ้าไม่ได้เลือก แจ้งเตือน Alert
                            showAlert = true
                        } else {
                            // ถ้าเลือกแล้ว ให้เปลี่ยนไปหน้า MenuResultsView
                            navigateToMenuResults = true
                        }
                    } label: {
                        HStack {
                            Image(systemName: "fork.knife")
                            Text("Find the menu from the available items.")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(14)
                        .padding(.horizontal)
                        .padding(.bottom, 10)
                    }
                    // 🌟 แจ้งเตือนภาษาอังกฤษ
                    .alert("Notice", isPresented: $showAlert) {
                        Button("OK", role: .cancel) { }
                    } message: {
                        Text("Please select an ingredient first.")
                    }
                    // 🌟 คำสั่งเปลี่ยนหน้า
                    .navigationDestination(isPresented: $navigateToMenuResults) {
                        // ส่งข้อมูลวัตถุดิบที่เลือกลงไปในหน้าถัดไป
                        let selectedIngredients = viewModel.ingredients.filter { $0.isSelected }
                        MenuResultsView(selectedIngredients: selectedIngredients)
                    }
                }
                
                // Popup Add Ingredient
                if showPopup {
                    AddIngredientPopup(
                        showPopup: $showPopup,
                        onAdd: { newIngredient in
                            // 1. เพิ่มโชว์บนหน้าจอให้เห็นทันที
                            viewModel.ingredients.append(newIngredient)
                            
                            // 2. 🌟 แปลงวันที่กลับเพื่อยิง API บันทึกลงฐานข้อมูลจริงๆ! (ของจะได้ไม่หาย)
                            let formatter = DateFormatter()
                            formatter.dateFormat = "yyyy-MM-dd"
                            let expDate = formatter.date(from: newIngredient.expiry_date) ?? Date()
                            
                            viewModel.addFridgeItem(
                                name: newIngredient.ingredient_name,
                                quantity: newIngredient.quantity,
                                unit: newIngredient.unit,
                                expDate: expDate
                            )
                        }
                    )
                }
            }
            .onAppear {
                viewModel.fetchFridgeItems()
            }
        }
    }
    
    // MARK: Delete Ingredient
    func deleteIngredient(_ ingredient: Ingredient) {
        withAnimation {
            viewModel.ingredients.removeAll { $0.id == ingredient.id }
            if let fridgeId = ingredient.fridge_id {
                viewModel.deleteIngredient(fridgeId: fridgeId)
            }
        }
    }
    
    // MARK: Expired Check
    // 🌟 1. สร้างตัวแปรช่วยหาวัตถุดิบที่ใกล้หมดอายุ "ที่สุด" (น้อยกว่าหรือเท่ากับ 2 วัน)
    var closestExpiringIngredient: Ingredient? {
        viewModel.ingredients
            .filter { $0.remainingDays <= 2 }
            .min(by: { $0.remainingDays < $1.remainingDays })
    }
    
    var hasExpiredIngredient: Bool {
        closestExpiringIngredient != nil
    }
    
    var expiredIngredientName: String {
        closestExpiringIngredient?.ingredient_name ?? ""
    }
    
    var expiredDay: Int {
        closestExpiringIngredient?.remainingDays ?? 0
    }
}
