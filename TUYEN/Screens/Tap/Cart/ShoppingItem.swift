import SwiftUI

struct ShoppingItem: Identifiable {
    let id = UUID()
    var name: String
    var quantity: String
    var unit: String
    var isChecked: Bool = false
}
