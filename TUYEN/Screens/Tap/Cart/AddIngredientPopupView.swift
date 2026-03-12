import SwiftUI

struct AddIngredientPopupView: View {
    @Binding var showPopup: Bool
    var onAdd: (String, Int, String) -> Void
    
    @State private var name = ""
    @State private var quantity = ""
    @State private var unit = ""
    @State private var showError = false // ตัวแปรคุมโชว์แจ้งเตือน
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.3).ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("Ingredient")
                    .font(.title2)
                    .fontWeight(.bold)
                
                TextField("Ingredient name (e.g. Eggs)", text: $name)
                    .textFieldStyle(.roundedBorder)
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("Quantity").font(.subheadline).foregroundColor(.gray)
                        TextField("10", text: $quantity)
                            .keyboardType(.numberPad) // บังคับคีย์บอร์ดตัวเลข
                            .textFieldStyle(.roundedBorder)
                    }
                    VStack(alignment: .leading) {
                        Text("Unit").font(.subheadline).foregroundColor(.gray)
                        TextField("units", text: $unit)
                            .textFieldStyle(.roundedBorder)
                    }
                }
                
                // 🌟 โชว์แจ้งเตือนสีแดงถ้าข้อมูลไม่ครบ
                if showError {
                    Text("Please fill all fields and ensure quantity is a number.")
                        .foregroundColor(.red)
                        .font(.footnote)
                }
                
                HStack(spacing: 15) {
                    Button(action: {
                        // 🌟 เช็คว่ากรอกครบไหม และ quantity ต้องแปลงเป็นตัวเลขได้
                        if !name.isEmpty, !unit.isEmpty, let qty = Int(quantity) {
                            onAdd(name, qty, unit)
                            showPopup = false
                        } else {
                            showError = true // กรอกไม่ครบให้โชว์สีแดง
                        }
                    }) {
                        Text("OK")
                            .fontWeight(.bold).frame(maxWidth: .infinity).padding()
                            .background(Color.green).foregroundColor(.white).cornerRadius(10)
                    }
                    
                    Button(action: { showPopup = false }) {
                        Text("Cancel")
                            .fontWeight(.bold).frame(maxWidth: .infinity).padding()
                            .background(Color.red).foregroundColor(.white).cornerRadius(10)
                    }
                }
            }
            .padding().background(Color.white).cornerRadius(15).padding(30)
        }
    }
}
