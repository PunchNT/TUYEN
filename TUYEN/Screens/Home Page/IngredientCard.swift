import SwiftUI

struct IngredientCard: View {

    @Binding var ingredient: Ingredient
    var onDelete: () -> Void

    var body: some View {

        HStack {

            Rectangle()
                .fill(colorForDay(ingredient.day))
                .frame(width: 6)

            VStack(alignment: .leading) {

                Text(ingredient.name)
                    .font(.title3)
                    .fontWeight(.semibold)

                Text("Remaining: \(ingredient.quantity) \(ingredient.unit)")
                    .foregroundColor(.gray)
                    .font(.subheadline)
            }

            Spacer()

            Text("\(ingredient.day) Day")
                .font(.caption)
                .padding(.horizontal,8)
                .padding(.vertical,6)
                .background(backgroundDayColor(ingredient.day))
                .cornerRadius(8)

            Button {
                ingredient.isSelected.toggle()
            } label: {

                Image(systemName: ingredient.isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(14)
        .shadow(color: .black.opacity(0.08), radius: 4, y: 2)

        // ⭐ Swipe delete
        .swipeActions(edge: .trailing) {

            Button(role: .destructive) {
                onDelete()
            } label: {
                Label("Delete", systemImage: "trash.fill")
            }
        }
    }

    func colorForDay(_ day: Int) -> Color {

        if day <= 1 { return .red }
        if day <= 3 { return .yellow }

        return .green
    }

    func backgroundDayColor(_ day: Int) -> Color {

        if day <= 1 { return Color.red.opacity(0.25) }
        if day <= 3 { return Color.orange.opacity(0.25) }

        return Color.gray.opacity(0.2)
    }
}
