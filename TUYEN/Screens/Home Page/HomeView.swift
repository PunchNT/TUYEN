import SwiftUI

struct HomeView: View {
    
    @State private var showPopup = false
    
    // เริ่มต้นไม่มีวัตถุดิบ
    @State private var ingredients: [Ingredient] = []

    var body: some View {
        
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

                
                // 🔔 Expired Notification
                if hasExpiredIngredient {
                    
                    HStack(spacing:12) {
                        
                        Image(systemName: "clock.fill")
                            .font(.title3)
                            .foregroundColor(.orange)

                        VStack(alignment:.leading) {
                            
                            Text("Expired notification")
                                .font(.headline)

                            Text("\(expiredIngredientName) will expire in \(expiredDay) days!!")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        
                        Spacer()
                    }
                    .padding()
                    .background(Color.orange.opacity(0.2))
                    .cornerRadius(14)
                    .padding(.horizontal)
                }

                
                // Main Content
                ZStack {
                    
                    if ingredients.isEmpty {
                        
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
                    }
                    else {
                        
                        // ⭐ ใช้ List เพื่อให้ Swipe Delete ทำงาน
                        List {
                            
                            ForEach($ingredients) { $ingredient in
                                
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

                
                // Find Menu Button
                NavigationLink(destination: MenuResultsView()) {
                    
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
            }

            
            // Popup Add Ingredient
            if showPopup {
                AddIngredientPopup(
                    showPopup: $showPopup,
                    onAdd: { newIngredient in
                        ingredients.append(newIngredient)
                    }
                )
            }
        }
    }

    
    // MARK: Delete Ingredient
    func deleteIngredient(_ ingredient: Ingredient) {
        withAnimation {
            ingredients.removeAll { $0.id == ingredient.id }
        }
    }

    
    // MARK: Expired Check
    var hasExpiredIngredient: Bool {
        ingredients.contains { $0.day <= 1 }
    }

    var expiredIngredientName: String {
        ingredients.first { $0.day <= 1 }?.name ?? ""
    }

    var expiredDay: Int {
        ingredients.first { $0.day <= 1 }?.day ?? 0
    }
}
