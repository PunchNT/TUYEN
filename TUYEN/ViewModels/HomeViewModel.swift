import Foundation
import SwiftUI
import Combine

// MARK: - โครงสร้างรับข้อมูลจาก API Recommend
struct RecommendResponse: Codable {
    let recommendations: [RecommendRecipe]
}

struct RecommendRecipe: Codable {
    let name: String
    let category: String
    let match_score_percent: Double
    let used_ingredients: [String]
}

// 🌟 คลาสหลัก (ต้องมีปีกกาครอบฟังก์ชันทั้งหมดไว้)
class HomeViewModel: ObservableObject {
    @Published var ingredients: [Ingredient] = []
    @Published var recipes: [Recipe] = []
    @Published var isLoading = false
    
    // ดึง user_id
    var userId: Int {
        UserDefaults.standard.integer(forKey: "user_id") == 0 ? 15 : UserDefaults.standard.integer(forKey: "user_id")
    }
    
    // MARK: - 1. ดึงข้อมูลวัตถุดิบ (GET)
    func fetchFridgeItems() {
        guard let url = URL(string: "https://smartfridge-api-gp-fudkfahvfeazgced.southeastasia-01.azurewebsites.net/fridge/\(userId)") else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }
            
            DispatchQueue.main.async {
                do {
                    let result = try JSONDecoder().decode(FridgeResponseData.self, from: data)
                    self.ingredients = result.data
                } catch {
                    print("Error decoding fridge items: \(error)")
                }
            }
        }.resume()
    }
    
    // MARK: - 2. เพิ่มวัตถุดิบ (POST)
    func addFridgeItem(name: String, quantity: Double, unit: String, expDate: Date) {
        let url = URL(string: "https://smartfridge-api-gp-fudkfahvfeazgced.southeastasia-01.azurewebsites.net/fridge/add")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateString = formatter.string(from: expDate)
        
        let body: [String: Any] = [
            "user_id": userId,
            "ingredient_name": name,
            "quantity": quantity,
            "unit": unit,
            "expiry_date": dateString
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { data, _, _ in
            DispatchQueue.main.async {
                self.fetchFridgeItems()
            }
        }.resume()
    }
    
    // MARK: - 3. ลบวัตถุดิบ (DELETE)
    func deleteIngredient(fridgeId: Int) {
        let url = URL(string: "https://smartfridge-api-gp-fudkfahvfeazgced.southeastasia-01.azurewebsites.net/fridge/remove/\(fridgeId)")!
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { _, _, _ in
            DispatchQueue.main.async {
                self.ingredients.removeAll { $0.fridge_id == fridgeId }
            }
        }.resume()
    }
    
    // MARK: - 4. 🌟 ค้นหาสูตรอาหารแบบ Perfect (POST /recommend)
    func fetchRecommendations(selectedItems: [Ingredient]) {
        self.isLoading = true
        self.recipes = []
        
        let url = URL(string: "https://smartfridge-api-gp-fudkfahvfeazgced.southeastasia-01.azurewebsites.net/recommend")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let ingredientNames = selectedItems.map { $0.ingredient_name }
        
        // 🌟 ส่ง "top_k": 20 ให้ Backend
        let body: [String: Any] = [
            "ingredients": ingredientNames,
            "top_k": 20
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data else {
                DispatchQueue.main.async { self.isLoading = false }
                return
            }
            
            DispatchQueue.main.async {
                guard let result = try? JSONDecoder().decode(RecommendResponse.self, from: data) else {
                    print("🔴 Decode Error: ไม่สามารถแปลงข้อมูลจาก /recommend ได้")
                    self.isLoading = false
                    return
                }
                
                // แปลงข้อมูลจาก Recommend ให้กลายเป็น Recipe Card
                self.recipes = result.recommendations.enumerated().map { index, rec in
                    Recipe(
                        recipe_id: -(index + 1), // ใช้เลขติดลบหลอก SwiftUI ไปก่อนแก้บัคเมนูซ้ำ
                        title: rec.name,
                        calories: 0,
                        prep_time: 0,
                        image_url: nil,
                        matchPercentage: Int(rec.match_score_percent),
                        usedIngredientsCount: rec.used_ingredients.count,
                        category: rec.category
                    )
                }
                self.isLoading = false
            }
        }.resume()
    }
}
