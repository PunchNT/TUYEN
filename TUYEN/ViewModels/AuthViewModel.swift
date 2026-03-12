import Foundation
import SwiftUI
import Combine

// โครงสร้างสำหรับรับข้อมูลจาก API
struct ApiResponse: Codable {
    let status: String
    let message: String
    let user_id: Int?
    let email: String?
    let display_name: String?
}

class AuthViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var errorMessage = ""
    @Published var successMessage = ""
    
    // MARK: - 1. ฟังก์ชันเข้าสู่ระบบ (Login)
        // 👈 เพิ่ม , completion: @escaping (Bool) -> Void เข้าไปด้านหลัง
        func login(email: String, password: String, completion: @escaping (Bool) -> Void) {
            guard !email.isEmpty, !password.isEmpty else {
                self.errorMessage = "Please enter email and password"
                completion(false) // 👈 เพิ่มตรงนี้
                return
            }
            
            isLoading = true
            errorMessage = ""
            
            let url = URL(string: "https://smartfridge-api-gp-fudkfahvfeazgced.southeastasia-01.azurewebsites.net/login")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let body = ["email": email, "password": password]
            request.httpBody = try? JSONEncoder().encode(body)
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                DispatchQueue.main.async {
                    self.isLoading = false
                    if let data = data {
                        do {
                            let result = try JSONDecoder().decode(ApiResponse.self, from: data)
                            if result.status == "success" {
                                // เซฟข้อมูลผู้ใช้ลงเครื่อง
                                UserDefaults.standard.set(result.user_id, forKey: "user_id")
                                UserDefaults.standard.set(result.display_name, forKey: "display_name")
                                
                                // 🌟 ส่งสัญญาณกลับไปที่หน้าจอว่า "ผ่านแล้วเว้ย!"
                                completion(true)
                                
                            } else {
                                self.errorMessage = result.message
                                completion(false) // 👈 เพิ่มตรงนี้
                            }
                        } catch {
                            self.errorMessage = "System error. Please try again."
                            completion(false) // 👈 เพิ่มตรงนี้
                        }
                    }
                }
            }.resume()
        }
    // MARK: - 2. ฟังก์ชันสมัครสมาชิก (Register)
    func register(name: String, email: String, password: String, completion: @escaping (Bool) -> Void) {
        guard !name.isEmpty, !email.isEmpty, !password.isEmpty else {
            self.errorMessage = "Please fill in all fields"
            return
        }
        
        isLoading = true
        errorMessage = ""
        
        let url = URL(string: "https://smartfridge-api-gp-fudkfahvfeazgced.southeastasia-01.azurewebsites.net/register")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = ["display_name": name, "email": email, "password": password]
        request.httpBody = try? JSONEncoder().encode(body)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false
                if let data = data {
                    do {
                        let result = try JSONDecoder().decode(ApiResponse.self, from: data)
                        if result.status == "success" {
                            self.successMessage = result.message
                            completion(true) // ส่งสัญญาณว่าสำเร็จ
                        } else {
                            self.errorMessage = result.message
                            completion(false)
                        }
                    } catch {
                        self.errorMessage = "System error. Please try again."
                        completion(false)
                    }
                }
            }
        }.resume()
    }
    
    // MARK: - 3. ฟังก์ชันรีเซ็ตรหัสผ่าน (Reset Password)
    func resetPassword(email: String, completion: @escaping (Bool) -> Void) {
        guard !email.isEmpty else {
            self.errorMessage = "Please enter your email"
            return
        }
        
        isLoading = true
        errorMessage = ""
        
        let url = URL(string: "https://smartfridge-api-gp-fudkfahvfeazgced.southeastasia-01.azurewebsites.net/user/reset-password")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = ["email": email]
        request.httpBody = try? JSONEncoder().encode(body)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false
                if let data = data {
                    do {
                        let result = try JSONDecoder().decode(ApiResponse.self, from: data)
                        if result.status == "success" {
                            self.successMessage = result.message
                            completion(true)
                        } else {
                            self.errorMessage = result.message
                            completion(false)
                        }
                    } catch {
                        self.errorMessage = "System error. Please try again."
                        completion(false)
                    }
                }
            }
        }.resume()
    }
}
