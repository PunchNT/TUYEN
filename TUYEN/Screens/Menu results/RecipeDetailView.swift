import SwiftUI

struct RecipeDetailResponse: Codable {
    let status: String
    let data: RecipeDetailData?
}

struct RecipeDetailData: Codable {
    let recipe_id: Int
    let title: String
    let calories: Int
    let prep_time: Int
    let ingredients: [String]
    let steps: [String]
    let image_url: String?
}

struct RecipeDetailView: View {
    let recipeId: Int
    var recipeName: String = ""
    var matchPercentage: Int? = 0
    var selectedIngredients: [Ingredient] = []
    
    // 🌟 ตัวแปรใหม่ เอาไว้ควบคุมว่าจะให้โชว์ปุ่มทำอาหารไหม (ค่าเริ่มต้นเป็น true)
    var showCookButton: Bool = true
    
    @State private var recipeDetails: RecipeDetailData?
    @State private var isLoading = true
    
    @State private var showConfirmPopup = false
    @State private var isSavingHistory = false
    @State private var showSuccessAlert = false
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            if isLoading {
                ProgressView("Loading recipe...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let recipe = recipeDetails {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        
                        HStack {
                            Text(recipe.title.capitalized).font(.title2).fontWeight(.bold)
                            Spacer()
                            Text("Easy").font(.caption).padding(.horizontal, 12).padding(.vertical, 5).background(Color.green.opacity(0.2)).foregroundColor(.green).cornerRadius(20)
                        }
                        
                        if let imageUrlString = recipe.image_url, let url = URL(string: imageUrlString) {
                            AsyncImage(url: url) { image in
                                image.resizable().scaledToFill().frame(height: 200).frame(maxWidth: .infinity).clipped().cornerRadius(16)
                            } placeholder: {
                                Rectangle().fill(Color.gray.opacity(0.2)).frame(height: 200).overlay(ProgressView()).cornerRadius(16)
                            }
                        }
                        
                        HStack(spacing: 0) {
                            VStack {
                                Text("\(recipe.calories)").font(.title2).fontWeight(.bold)
                                Text("Cal.").foregroundColor(.gray).font(.caption)
                            }.frame(maxWidth: .infinity)
                            Divider()
                            VStack {
                                Text(showCookButton ? "\(matchPercentage ?? 0)%" : "-").font(.title2).fontWeight(.bold)
                                Text("Ingredients").foregroundColor(.gray).font(.caption)
                            }.frame(maxWidth: .infinity)
                            Divider()
                            VStack {
                                Text("\(recipe.prep_time)").font(.title2).fontWeight(.bold)
                                Text("minute").foregroundColor(.gray).font(.caption)
                            }.frame(maxWidth: .infinity)
                        }
                        .padding().background(Color(.systemGray6)).cornerRadius(14)
                        
                        Text("Ingredients required").font(.title3).fontWeight(.bold)

                        HStack(alignment: .top, spacing: 12) {
                            Image(systemName: "checkmark.circle.fill").foregroundColor(.green).font(.title3)
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Required ingredients list").foregroundColor(.green).fontWeight(.semibold)
                                Text(recipe.ingredients.joined(separator: "\n")).foregroundColor(.black)
                            }
                            Spacer()
                        }
                        .frame(maxWidth: .infinity, alignment: .leading).padding().background(Color.green.opacity(0.12)).overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.green.opacity(0.5), lineWidth: 1)).cornerRadius(14)
                        
                        Text("How to do it").font(.title3).fontWeight(.bold)
                        
                        VStack(alignment: .leading, spacing: 10) {
                            ForEach(Array(recipe.steps.enumerated()), id: \.offset) { index, step in
                                Text("\(index + 1). \(step)")
                            }
                        }
                        .padding(.leading, 10)
                        
                        // 🌟 โซนปุ่ม
                        HStack(spacing: 15) {
                            
                            // โชว์ปุ่มนี้เฉพาะหน้าตู้เย็น (showCookButton = true)
                            if showCookButton {
                                Button {
                                    showConfirmPopup = true
                                } label: {
                                    HStack {
                                        Image(systemName: "fork.knife")
                                        Text("Let's Cook").fontWeight(.semibold)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.green)
                                    .foregroundColor(.white)
                                    .cornerRadius(15)
                                }
                            }
                            
                            NavigationLink(destination: CommunityReviewsView(recipeId: self.recipeDetails?.recipe_id ?? self.recipeId)) {
                                HStack {
                                    Image(systemName: "message.fill")
                                    Text("Read reviews").fontWeight(.semibold)
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.black)
                                .foregroundColor(.white)
                                .cornerRadius(15)
                            }
                        }.padding(.top, 10)
                        
                    }.padding()
                }
            } else {
                Text("Recipe not found.")
                    .foregroundColor(.gray)
            }
            
            if showConfirmPopup {
                Color.black.opacity(0.4).ignoresSafeArea()
                VStack(spacing: 20) {
                    Text("Confirm Cooking").font(.title3).fontWeight(.bold)
                    Text("Do you want to start cooking \(recipeDetails?.title ?? "this recipe")?").multilineTextAlignment(.center).font(.body)
                    
                    HStack(spacing: 15) {
                        Button { showConfirmPopup = false } label: {
                            Text("Cancel").frame(maxWidth: .infinity).padding().background(Color.red).foregroundColor(.white).cornerRadius(10)
                        }.disabled(isSavingHistory)
                        
                        Button {
                            addHistoryToDatabase()
                            deductIngredientsFromFridge()
                        } label: {
                            if isSavingHistory {
                                ProgressView().progressViewStyle(CircularProgressViewStyle(tint: .white)).frame(maxWidth: .infinity).padding().background(Color.green).cornerRadius(10)
                            } else {
                                Text("Confirm").frame(maxWidth: .infinity).padding().background(Color.green).foregroundColor(.white).cornerRadius(10)
                            }
                        }.disabled(isSavingHistory)
                    }
                }
                .padding(25).background(Color.white).cornerRadius(20).padding(.horizontal, 30)
            }
        }
        .onAppear { fetchRecipeDetails() }
        .alert("Success", isPresented: $showSuccessAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("บันทึกประวัติและตัดจำนวนวัตถุดิบเรียบร้อยแล้ว!")
        }
    }
    
    // (ฟังก์ชัน API เดิมเหมือนเดิมทั้งหมด)
    func fetchRecipeDetails() {
        let urlString: String
        if recipeId < 0 {
            let encodedName = recipeName.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
            urlString = "https://smartfridge-api-gp-fudkfahvfeazgced.southeastasia-01.azurewebsites.net/recipesbyname/\(encodedName)/details"
        } else {
            urlString = "https://smartfridge-api-gp-fudkfahvfeazgced.southeastasia-01.azurewebsites.net/recipes/\(recipeId)/details"
        }
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { data, _, _ in
            DispatchQueue.main.async {
                self.isLoading = false
                if let data = data, let result = try? JSONDecoder().decode(RecipeDetailResponse.self, from: data) {
                    self.recipeDetails = result.data
                }
            }
        }.resume()
    }
    
    // 🌟 แก้ไขจุดที่ 1: ตั้งค่า TimeZone เป็นไทย และดึง userId จริงมาใช้
    func addHistoryToDatabase() {
        isSavingHistory = true
        
        let userId = UserDefaults.standard.integer(forKey: "user_id") // ดึง ID ผู้ใช้ตัวจริง
        
        let url = URL(string: "https://smartfridge-api-gp-fudkfahvfeazgced.southeastasia-01.azurewebsites.net/history/add")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        formatter.timeZone = TimeZone(identifier: "Asia/Bangkok") // ตั้งเวลาประเทศไทย
        
        let dateString = formatter.string(from: Date())
        let realRecipeId = self.recipeDetails?.recipe_id ?? self.recipeId
        
        let body: [String: Any] = [
            "user_id": userId,
            "recipe_id": realRecipeId,
            "history_date": dateString,
            "history_type": "cooked"
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { _, _, _ in
            DispatchQueue.main.async {
                self.isSavingHistory = false
                self.showConfirmPopup = false
                self.showSuccessAlert = true
            }
        }.resume()
    }
    
    // 🌟 แก้ไขจุดที่ 2: ดึง userId จริงมาใช้
    func deductIngredientsFromFridge() {
        guard let recipeIngredients = recipeDetails?.ingredients else { return }
        
        let userId = UserDefaults.standard.integer(forKey: "user_id") // ดึง ID ผู้ใช้ตัวจริง
        
        for myItem in selectedIngredients {
            let isUsedInRecipe = recipeIngredients.contains { required in
                required.localizedCaseInsensitiveContains(myItem.ingredient_name) ||
                myItem.ingredient_name.localizedCaseInsensitiveContains(required)
            }
            if isUsedInRecipe {
                let newQuantity = max(0, myItem.quantity - 1.0)
                replaceFridgeItemAPI(oldFridgeId: myItem.fridge_id ?? 0, userId: userId, name: myItem.ingredient_name, newQuantity: newQuantity, unit: myItem.unit, expiryDate: myItem.expiry_date)
            }
        }
    }
    
    func replaceFridgeItemAPI(oldFridgeId: Int, userId: Int, name: String, newQuantity: Double, unit: String, expiryDate: String) {
        let deleteUrl = URL(string: "https://smartfridge-api-gp-fudkfahvfeazgced.southeastasia-01.azurewebsites.net/fridge/remove/\(oldFridgeId)")!
        var deleteRequest = URLRequest(url: deleteUrl)
        deleteRequest.httpMethod = "DELETE"
        URLSession.shared.dataTask(with: deleteRequest) { _, _, _ in
            if newQuantity > 0 {
                let addUrl = URL(string: "https://smartfridge-api-gp-fudkfahvfeazgced.southeastasia-01.azurewebsites.net/fridge/add")!
                var addRequest = URLRequest(url: addUrl)
                addRequest.httpMethod = "POST"
                addRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
                let body: [String: Any] = ["user_id": userId, "ingredient_name": name, "quantity": newQuantity, "unit": unit, "expiry_date": expiryDate]
                addRequest.httpBody = try? JSONSerialization.data(withJSONObject: body)
                URLSession.shared.dataTask(with: addRequest).resume()
            }
        }.resume()
    }
}
