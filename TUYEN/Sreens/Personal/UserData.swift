import SwiftUI

class UserData: ObservableObject {
    
    @Published var allergies: [String] = []
    @Published var diets: [String] = []
    
}
