import Foundation

struct RecipeResponse: Codable {
    let status: String
    let total: Int
    let data: [Recipe]
}

struct Recipe: Identifiable, Codable {
    var id: Int { recipe_id }
    let recipe_id: Int
    let title: String
    let calories: Int
    let prep_time: Int
    let image_url: String?
    
    var matchPercentage: Int? = nil
    var usedIngredientsCount: Int? = nil
    var category: String? = nil // 🌟 เพิ่มตัวแปรนี้เข้ามารับหมวดหมู่
}
