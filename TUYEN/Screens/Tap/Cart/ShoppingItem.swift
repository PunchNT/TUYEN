import Foundation

// สร้างโครงสร้างมารับข้อมูลก้อนใหญ่จาก API ก่อน
struct ShoppingResponse: Codable {
    let status: String?
    let total: Int?
    let data: [ShoppingItem]?
}

// โครงสร้างของของแต่ละชิ้น
struct ShoppingItem: Codable, Identifiable {
    // ใช้ list_id จาก API เป็น id หลัก
    var id: Int { list_id ?? Int.random(in: 1...99999) }
    
    let list_id: Int?
    var ingredient_name: String?
    var quantity: Int?
    var unit: String?
    var is_bought: Bool?
}
