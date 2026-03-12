import SwiftUI

struct ShoppingRow: View {
    @Binding var item: ShoppingItem
    
    var body: some View {
        HStack(spacing: 15) {
            Button {
                withAnimation {
                    // สลับค่า true/false ของการซื้อ
                    item.is_bought = !(item.is_bought ?? false)
                    // 💡 หมายเหตุ: ตอนนี้ API ที่ส่งมาให้ยังไม่มีเส้นทางอัปเดต is_bought
                    // มันเลยจะโชว์ขีดฆ่าแค่บนหน้าจอนะครับ ปิดแอปเปิดใหม่จะกลับมาเป็นค่าเดิม
                }
            } label: {
                ZStack {
                    Circle()
                        .stroke(item.is_bought == true ? Color.green : Color.gray, lineWidth: 2)
                        .frame(width: 25, height: 25)
                    
                    if item.is_bought == true {
                        Image(systemName: "checkmark")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.green)
                    }
                }
            }
            
            VStack(alignment: .leading, spacing: 3) {
                Text(item.ingredient_name ?? "")
                    .font(.headline)
                    // 🌟 ถ้า is_bought เป็น true ตัวหนังสือจะสีอ่อนลง และขีดฆ่า
                    .foregroundColor(item.is_bought == true ? .gray.opacity(0.6) : .black)
                    .strikethrough(item.is_bought == true, color: .gray)
                
                Text("\(item.quantity ?? 0) \(item.unit ?? "")")
                    .foregroundColor(item.is_bought == true ? .gray.opacity(0.5) : .gray)
                    .font(.subheadline)
            }
            
            Spacer()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: .black.opacity(0.05), radius: 5, y: 3)
    }
}
