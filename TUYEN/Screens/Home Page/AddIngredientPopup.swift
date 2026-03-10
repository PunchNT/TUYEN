import SwiftUI

struct AddIngredientPopup: View {

    @Binding var showPopup: Bool

    var onAdd: (Ingredient) -> Void

    @State private var name = ""
    @State private var quantity = ""
    @State private var unit = ""

    @State private var expirationDate = Date()
    @State private var showDatePicker = false

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

                        let days = Calendar.current.dateComponents(
                            [.day],
                            from: Date(),
                            to: expirationDate
                        ).day ?? 0

                        let newIngredient = Ingredient(
                            name: name,
                            quantity: quantity,
                            unit: unit,
                            day: days
                        )

                        onAdd(newIngredient)
                        showPopup = false

                    } label: {

                        Text("OK")
                            .frame(maxWidth:.infinity)
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }

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
