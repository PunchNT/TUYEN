import Foundation

// โครงสร้างสำหรับรับข้อมูลทั้งหมดจาก API (มี status, total, data)
struct FridgeResponseData: Codable {
    let status: String
    let total: Int
    let data: [Ingredient]
}

// โครงสร้างของวัตถุดิบ 1 ชิ้น
struct Ingredient: Identifiable, Codable {
    var id: Int { fridge_id ?? UUID().hashValue }
    
    let fridge_id: Int?
    var ingredient_name: String
    var quantity: Double
    var unit: String
    var expiry_date: String
    
    // 🌟 1. เพิ่มตัวแปรนี้กลับมาเพื่อใช้กับการกดติ๊กถูกในการ์ด
    var isSelected: Bool = false
    
    var remainingDays: Int {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        guard let expDate = formatter.date(from: expiry_date) else { return 0 }
        
        let startOfToday = Calendar.current.startOfDay(for: Date())
        let components = Calendar.current.dateComponents([.day], from: startOfToday, to: expDate)
        return max(0, components.day ?? 0)
    }
    
    // 🌟 2. เพิ่ม CodingKeys เพื่อบอกว่าตอนรับ API ให้รับแค่ 5 ตัวนี้นะ (ไม่ต้องหา isSelected)
    enum CodingKeys: String, CodingKey {
        case fridge_id
        case ingredient_name
        case quantity
        case unit
        case expiry_date
    }
}
