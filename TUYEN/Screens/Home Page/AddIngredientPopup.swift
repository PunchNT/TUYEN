import SwiftUI

struct AddIngredientPopup: View {

    @Binding var showPopup: Bool

    var onAdd: (Ingredient) -> Void

    @State private var name = ""
    @State private var quantity = ""
    @State private var unit = ""

    @State private var expirationDate = Date()
    @State private var showDatePicker = false
    // 🌟 เพิ่มตัวแปรเช็กว่ากรอกครบหรือยัง
    var isFormValid: Bool {
            !name.isEmpty && !quantity.isEmpty && !unit.isEmpty
    }

    var body: some View {

        ZStack {

            Color.black.opacity(0.3)
                .ignoresSafeArea()

            VStack(spacing:16) {

                Text("Ingredient")
                    .font(.headline)

                TextField("Cheese", text: $name)
                    .textFieldStyle(.roundedBorder)

                HStack {

                    VStack(alignment:.leading) {

                        Text("Quantity")

                        TextField("3", text: $quantity)
                            .textFieldStyle(.roundedBorder)
                    }

                    Spacer()

                    VStack {

                        Text("Expiration date")

                        Button {

                            showDatePicker.toggle()

                        } label: {

                            Image(systemName: "calendar")
                                .font(.largeTitle)
                        }
                    }
                }

                if showDatePicker {

                    DatePicker(
                        "Select date",
                        selection: $expirationDate,
                        displayedComponents: .date
                    )
                    .datePickerStyle(.graphical)
                }

                VStack(alignment:.leading) {

                    Text("Unit")

                    TextField("sheets", text: $unit)
                        .textFieldStyle(.roundedBorder)
                }

                HStack {

                    Button {
                                            // ... (โค้ดแปลงวันที่และสร้าง newIngredient เหมือนเดิม) ...
                                            let formatter = DateFormatter()
                                            formatter.dateFormat = "yyyy-MM-dd"
                                            let dateString = formatter.string(from: expirationDate)
                                            
                                            let qtyDouble = Double(quantity) ?? 0.0
                                            
                                            let newIngredient = Ingredient(
                                                fridge_id: nil,
                                                ingredient_name: name,
                                                quantity: qtyDouble,
                                                unit: unit,
                                                expiry_date: dateString
                                            )
                                            
                                            onAdd(newIngredient)
                                            showPopup = false
                                            
                                        } label: {
                                            Text("OK")
                                                .frame(maxWidth: .infinity)
                                                .padding()
                                                // 🌟 เปลี่ยนสีปุ่ม: ถ้าครบเป็นเขียว ถ้าไม่ครบเป็นเทา
                                                .background(isFormValid ? Color.green : Color.gray.opacity(0.5))
                                                .foregroundColor(.white)
                                                .cornerRadius(10)
                                        }
                                        .disabled(!isFormValid) // 🌟 บังคับล็อกปุ่ม ห้ามกดถ้ากรอกไม่ครบ!
                    Button {

                        showPopup = false

                    } label: {

                        Text("Cancel")
                            .frame(maxWidth:.infinity)
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }

            }
            .padding()
            .background(Color.white)
            .cornerRadius(15)
            .padding(40)
        }
    }
}
