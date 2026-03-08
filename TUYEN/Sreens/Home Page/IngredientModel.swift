import SwiftUI

struct Ingredient: Identifiable {

    let id = UUID()

    var name: String
    var quantity: String
    var unit: String
    var day: Int
    var isSelected: Bool = false
}
