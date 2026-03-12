import SwiftUI

struct IngredientCard: View {
    @Binding var ingredient: Ingredient
    var onDelete: () -> Void

    var body: some View {
        HStack {
            Rectangle()
                .fill(colorForDay(ingredient.remainingDays))
                .frame(width: 6)

            VStack(alignment: .leading) {
                Text(ingredient.ingredient_name)
                    .font(.title3)
                    .fontWeight(.semibold)

                Text("Remaining: \(Int(ingredient.quantity)) \(ingredient.unit)")
                    .foregroundColor(.gray)
                    .font(.subheadline)
            }

            Spacer()

            Text("\(ingredient.remainingDays) Day")
                .font(.caption)
                .padding(.horizontal, 8)
                .padding(.vertical, 6)
                .background(backgroundDayColor(ingredient.remainingDays))
                .cornerRadius(8)

            Button {
                ingredient.isSelected.toggle()
            } label: {
                // 🌟 ปรับไอคอนติ๊กถูกให้ตรงกับรูป
                Image(systemName: ingredient.isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundColor(ingredient.isSelected ? .green : .gray.opacity(0.5))
            }
        }
        .padding()
        // 🌟 ปรับสีพื้นหลังและกรอบเวลาถูกเลือก
        .background(ingredient.isSelected ? Color.green.opacity(0.05) : Color.white)
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(ingredient.isSelected ? Color.green.opacity(0.3) : Color.clear, lineWidth: 1.5)
        )
        .cornerRadius(14)
        .shadow(color: .black.opacity(0.05), radius: 4, y: 2)
        .swipeActions(edge: .trailing) {
            Button(role: .destructive) {
                onDelete()
            } label: {
                Label("Delete", systemImage: "trash.fill")
            }
        }
    }

    func colorForDay(_ day: Int) -> Color {
        if day <= 2 { return .orange } // ปรับให้เข้ากับสีในดีไซน์
        return .green
    }

    func backgroundDayColor(_ day: Int) -> Color {
        if day <= 2 { return Color.red.opacity(0.15) }
        return Color.gray.opacity(0.15)
    }
}
