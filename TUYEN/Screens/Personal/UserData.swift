import SwiftUI
import Combine

class UserData: ObservableObject {
    
    @Published var name: String {
        didSet { UserDefaults.standard.set(name, forKey: "name") }
    }
    
    @Published var email: String {
        didSet { UserDefaults.standard.set(email, forKey: "email") }
    }
    
    @Published var password: String {
        didSet { UserDefaults.standard.set(password, forKey: "password") }
    }
    
    @Published var target: Int {
        didSet { UserDefaults.standard.set(target, forKey: "target") }
    }
    
    @Published var allergies: [String] {
        didSet { UserDefaults.standard.set(allergies, forKey: "allergies") }
    }
    
    @Published var diets: [String] {
        didSet { UserDefaults.standard.set(diets, forKey: "diets") }
    }
    
    
    init() {
        
        self.name = UserDefaults.standard.string(forKey: "name") ?? "Ohm"
        self.email = UserDefaults.standard.string(forKey: "email") ?? "Ohm@gmail.com"
        self.password = UserDefaults.standard.string(forKey: "password") ?? "12345678"
        
        let savedTarget = UserDefaults.standard.integer(forKey: "target")
        self.target = savedTarget == 0 ? 2000 : savedTarget
        
        self.allergies = UserDefaults.standard.stringArray(forKey: "allergies") ?? []
        self.diets = UserDefaults.standard.stringArray(forKey: "diets") ?? []
    }
}
