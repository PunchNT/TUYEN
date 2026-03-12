import SwiftUI
import Combine

struct BasicResponse: Codable {
    let status: String?
    let message: String?
}

class ProfileViewModel: ObservableObject {
    @Published var name: String = "Loading..."
    @Published var email: String = ""
    @Published var targetCal: Int = 2000
    @Published var consumedCal: Int = 0
    @Published var allergies: [String] = []
    @Published var diets: [String] = []
    
    @Published var isLoading = false
    
    // 🌟 ดึง ID ผู้ใช้ตัวจริงที่ล็อกอินอยู่ 100%
    var userId: Int {
        return UserDefaults.standard.integer(forKey: "user_id")
    }
    
    func fetchProfile() {
        if userId == 0 { return } // ป้องกันบักถ้ายังไม่ล็อกอิน
        
        let url = URL(string: "https://smartfridge-api-gp-fudkfahvfeazgced.southeastasia-01.azurewebsites.net/user/\(userId)/profile")!
        URLSession.shared.dataTask(with: url) { data, _, _ in
            DispatchQueue.main.async {
                guard let data = data else { return }
                
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let dataDict = json["data"] as? [String: Any] {
                        
                        self.name = dataDict["display_name"] as? String ?? "User"
                        
                        if let tInt = dataDict["target_cal"] as? Int, tInt > 0 {
                            self.targetCal = tInt
                        } else if let tStr = dataDict["target_cal"] as? String, let tInt = Int(tStr), tInt > 0 {
                            self.targetCal = tInt
                        } else {
                            self.targetCal = 2000
                        }
                        
                        self.allergies = dataDict["allergies"] as? [String] ?? []
                        self.diets = dataDict["diet_types"] as? [String] ?? []
                        
                        // 🌟 โหลดโปรไฟล์เสร็จ ให้ไปคำนวณแคลอรี่จาก "ประวัติวันนี้" มาโชว์
                        self.calculateTodayCalories()
                    }
                } catch {
                    print("🔴 Profile Parse Error: \(error)")
                }
            }
        }.resume()
    }
    
    func fetchAccountInfo(completion: @escaping (String, String, Int) -> Void) {
        if userId == 0 {
            completion("", "", 2000)
            return
        }
        
        let url = URL(string: "https://smartfridge-api-gp-fudkfahvfeazgced.southeastasia-01.azurewebsites.net/user/\(userId)/account")!
        URLSession.shared.dataTask(with: url) { data, _, _ in
            DispatchQueue.main.async {
                guard let data = data else {
                    completion("", "", 2000)
                    return
                }
                
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let dataDict = json["data"] as? [String: Any] {
                        
                        let em = dataDict["email"] as? String ?? ""
                        let nm = dataDict["display_name"] as? String ?? ""
                        
                        var tg = 2000
                        if let tInt = dataDict["target_cal"] as? Int, tInt > 0 {
                            tg = tInt
                        } else if let tStr = dataDict["target_cal"] as? String, let tInt = Int(tStr), tInt > 0 {
                            tg = tInt
                        }
                        
                        completion(em, nm, tg)
                    } else {
                        completion("", "", 2000)
                    }
                } catch {
                    completion("", "", 2000)
                }
            }
        }.resume()
    }
    
    // 🌟 ระบบคำนวณแคลอรี่จาก "ประวัติการทำอาหารของวันนี้"
    func calculateTodayCalories() {
        if userId == 0 { return }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone(identifier: "Asia/Bangkok")
        let todayString = formatter.string(from: Date())
        
        // 1. ดึงประวัติของวันนี้มาก่อน
        let url = URL(string: "https://smartfridge-api-gp-fudkfahvfeazgced.southeastasia-01.azurewebsites.net/history/\(userId)/by-date?target_date=\(todayString)")!
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let dataArray = json["data"] as? [[String: Any]] else { return }
            
            if dataArray.isEmpty {
                DispatchQueue.main.async { self.consumedCal = 0 }
                return
            }
            
            var totalCalories = 0
            let group = DispatchGroup()
            
            // 2. เอา recipe_id ของวันนี้ ไปดึงแคลอรี่จาก API Recipe Details ทีละอัน
            for item in dataArray {
                if let recipeId = item["recipe_id"] as? Int {
                    group.enter()
                    let recipeUrl = URL(string: "https://smartfridge-api-gp-fudkfahvfeazgced.southeastasia-01.azurewebsites.net/recipes/\(recipeId)/details")!
                    
                    URLSession.shared.dataTask(with: recipeUrl) { rData, _, _ in
                        defer { group.leave() }
                        if let rData = rData,
                           let rJson = try? JSONSerialization.jsonObject(with: rData) as? [String: Any],
                           let rDataDict = rJson["data"] as? [String: Any],
                           let cals = rDataDict["calories"] as? Int {
                            DispatchQueue.main.async {
                                totalCalories += cals
                            }
                        }
                    }.resume()
                }
            }
            
            // 3. เมื่อดึงข้อมูลแคลอรี่ของทุกเมนูเสร็จ ให้อัปเดตค่าเข้าหลอด
            group.notify(queue: .main) {
                self.consumedCal = totalCalories
            }
        }.resume()
    }
    
    // 🌟 ระบบอัปเดตข้อมูล (แก้เป็น PUT ตาม Swagger)
    func updateAccount(email: String, name: String, target: Int, password: String?, completion: @escaping (Bool, String) -> Void) {
        if userId == 0 {
            completion(false, "ไม่พบข้อมูลผู้ใช้")
            return
        }
        
        let url = URL(string: "https://smartfridge-api-gp-fudkfahvfeazgced.southeastasia-01.azurewebsites.net/user/\(userId)/edit")!
        var request = URLRequest(url: url)
        
        request.httpMethod = "PUT" // 🌟 ตามเอกสารของคุณต้องเป็น PUT
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        var body: [String: Any] = [
            "email": email,
            "display_name": name,
            "target_cal": target
        ]
        
        // ส่งรหัสผ่านเฉพาะตอนที่พิมพ์ลงไปเท่านั้น
        if let pw = password, !pw.isEmpty {
            body["password"] = pw
        }
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(false, "การเชื่อมต่อล้มเหลว: \(error.localizedDescription)")
                    return
                }
                
                guard let data = data, let result = try? JSONDecoder().decode(BasicResponse.self, from: data) else {
                    completion(false, "รูปแบบข้อมูลตอบกลับไม่ถูกต้อง")
                    return
                }
                
                if result.status == "success" {
                    self.fetchProfile()
                    completion(true, result.message ?? "อัปเดตข้อมูลสำเร็จ")
                } else {
                    completion(false, result.message ?? "อัปเดตข้อมูลล้มเหลว")
                }
            }
        }.resume()
    }
    
    func addAllergy(_ item: String) {
        if userId == 0 { return }
        let url = URL(string: "https://smartfridge-api-gp-fudkfahvfeazgced.southeastasia-01.azurewebsites.net/user/\(userId)/allergies/add")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: String] = ["allergy_name": item]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { _, _, _ in
            DispatchQueue.main.async { self.fetchProfile() }
        }.resume()
    }
    
    func removeAllergy(_ item: String) {
        if userId == 0 { return }
        let encodedItem = item.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let url = URL(string: "https://smartfridge-api-gp-fudkfahvfeazgced.southeastasia-01.azurewebsites.net/user/\(userId)/allergies/remove?allergy_name=\(encodedItem)")!
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { _, _, _ in
            DispatchQueue.main.async { self.fetchProfile() }
        }.resume()
    }
    
    func addDiet(_ item: String) {
        if userId == 0 { return }
        let url = URL(string: "https://smartfridge-api-gp-fudkfahvfeazgced.southeastasia-01.azurewebsites.net/user/\(userId)/diet-type/add")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: String] = ["diet_name": item]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { _, _, _ in
            DispatchQueue.main.async { self.fetchProfile() }
        }.resume()
    }
    
    func removeDiet(_ item: String) {
        if userId == 0 { return }
        let encodedItem = item.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let url = URL(string: "https://smartfridge-api-gp-fudkfahvfeazgced.southeastasia-01.azurewebsites.net/user/\(userId)/diet-type/remove?diet_name=\(encodedItem)")!
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { _, _, _ in
            DispatchQueue.main.async { self.fetchProfile() }
        }.resume()
    }
}
