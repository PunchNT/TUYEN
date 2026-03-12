import SwiftUI

struct CartView: View {
    @StateObject private var viewModel = CartViewModel()
    @State private var showAddPopup = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGray6).ignoresSafeArea()
                
                VStack(alignment: .leading) {
                    Text("Shopping List 🛒")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                        .padding(.top, 10)
                    
                    if viewModel.isLoading && viewModel.items.isEmpty {
                        ProgressView().frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        List {
                            ForEach($viewModel.items) { $item in
                                ShoppingRow(item: $item)
                                // 🌟 1. ปรับระยะห่างบน-ล่างให้เหลือน้อยลง (top: 6, bottom: 6)
                                    .listRowInsets(EdgeInsets(top: 6, leading: 20, bottom: 6, trailing: 20))
                                    .listRowBackground(Color.clear)
                                    .listRowSeparator(.hidden)
                                    .swipeActions(edge: .trailing) {
                                        Button(role: .destructive) {
                                            if let listId = item.list_id {
                                                viewModel.deleteItem(listId: listId)
                                            }
                                        } label: {
                                            Label("Delete", systemImage: "trash.fill")
                                        }
                                    }
                            }
                            
                            // ปุ่ม + Add Item
                            // ปุ่ม + Add Item
                            Button(action: { showAddPopup = true }) {
                                HStack {
                                    Spacer()
                                    Text("+ Add item").foregroundColor(.gray)
                                    Spacer()
                                }
                                .padding()
                                .background(Color(.systemGray6))
                                .overlay(RoundedRectangle(cornerRadius: 10).stroke(style: StrokeStyle(lineWidth: 1, dash: [5])))
                            }
                            // 🌟 2. ปรับระยะห่างของปุ่ม Add ด้วย
                            .listRowInsets(EdgeInsets(top: 10, leading: 20, bottom: 20, trailing: 20))
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                        }
                        .listStyle(.plain)
                        .scrollContentBackground(.hidden)
                        // 🌟 3. ปลดล็อกความสูงขั้นต่ำของแถว ให้มันยอมชิดกันได้มากขึ้น
                        .environment(\.defaultMinListRowHeight, 10)
                    }
                    // 🌟 ปุ่ม MAP ลิ้งก์ไปหน้า MapMarket
                    NavigationLink(destination: MapMarket()) {
                        Text("Map")
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.black)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                            .padding(.horizontal)
                            .padding(.bottom, 15)
                    }
                }
                
                // โชว์ Popup
                if showAddPopup {
                    AddIngredientPopupView(showPopup: $showAddPopup) { name, qty, unit in
                        viewModel.addItem(name: name, quantity: qty, unit: unit) { _ in }
                    }
                }
            }
            .onAppear {
                viewModel.fetchShoppingList()
            }
        }
    }
}
