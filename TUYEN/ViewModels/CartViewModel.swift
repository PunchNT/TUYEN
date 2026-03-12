import Foundation
import SwiftUI
import Combine

class CartViewModel: ObservableObject {
    @Published var items: [ShoppingItem] = []
    @Published var isLoading = false
    
    // ดึง user_id จากเครื่อง ถ้าไม่มีค่าให้ใช้ 16 ตามตัวอย่างของคุณ
    var userId: Int {
        let id = UserDefaults.standard.integer(forKey: "user_id")
        return id == 0 ? 16 : id
    }
    
    // 1. ดึงข้อมูล
    func fetchShoppingList() {
        isLoading = true
        let url = URL(string: "https://smartfridge-api-gp-fudkfahvfeazgced.southeastasia-01.azurewebsites.net/shopping-list/\(userId)")!
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            DispatchQueue.main.async {
                self.isLoading = false
                if let data = data {
                    do {
                        let result = try JSONDecoder().decode(ShoppingResponse.self, from: data)
                        self.items = result.data ?? []
                    } catch {
                        print("Fetch Error: \(error)")
                    }
                }
            }
        }.resume()
    }
    
    // 2. เพิ่มข้อมูล
    func addItem(name: String, quantity: Int, unit: String, completion: @escaping (Bool) -> Void) {
        let url = URL(string: "https://smartfridge-api-gp-fudkfahvfeazgced.southeastasia-01.azurewebsites.net/shopping-list/add")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "user_id": userId,
            "ingredient_name": name,
            "quantity": quantity,
            "unit": unit
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { data, response, _ in
            DispatchQueue.main.async {
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                    self.fetchShoppingList() // โหลดใหม่เมื่อเพิ่มเสร็จ
                    completion(true)
                } else {
                    completion(false)
                }
            }
        }.resume()
    }
    
    // 3. ลบข้อมูล
    func deleteItem(listId: Int) {
        // ลบจากหน้าจอก่อนเพื่อให้ผู้ใช้รู้สึกไว
        withAnimation {
            self.items.removeAll { $0.list_id == listId }
        }
        
        let url = URL(string: "https://smartfridge-api-gp-fudkfahvfeazgced.southeastasia-01.azurewebsites.net/shopping-list/remove/\(listId)")!
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        URLSession.shared.dataTask(with: request) { _, _, _ in }.resume()
    }
}
