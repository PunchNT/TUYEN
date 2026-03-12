import SwiftUI

struct MenuResultsView: View {
    @Environment(\.dismiss) var dismiss
    
    var selectedIngredients: [Ingredient]
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            // HEADER
            VStack(alignment: .leading, spacing: 8) {
                Button(action: { dismiss() }) {
                    Image(systemName: "arrow.left")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.black)
                        .padding(10)
                        .background(Color.white)
                        .clipShape(Circle())
                        .shadow(color: .black.opacity(0.1), radius: 4)
                }
                
                Text("Menu results")
                    .font(.system(size: 30, weight: .bold, design: .rounded))
                
                Text("I found \(viewModel.recipes.count) menu items")
                    .font(.system(size: 16))
                    .foregroundColor(.gray)
            }
            .padding(.horizontal)
            .padding(.top, 10)
            .padding(.bottom, 20)
            
            // MENU LIST
            ScrollView {
                if viewModel.isLoading {
                    ProgressView("Searching for best recipes...")
                        .frame(maxWidth: .infinity) // 🌟 บังคับขยายเต็มจอ
                        .padding(.top, 50)
                }
                else if viewModel.recipes.isEmpty {
                    Text("No recipes found for the selected ingredients.")
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity) // 🌟 บังคับขยายเต็มจอ
                        .padding(.top, 50)
                }
                else {
                    VStack(spacing: 12) {
                        ForEach(viewModel.recipes) { recipe in
                            
                            NavigationLink(destination: RecipeDetailView(
                                recipeId: recipe.id,
                                recipeName: recipe.title,
                                matchPercentage: recipe.matchPercentage,
                                selectedIngredients: selectedIngredients
                            )) {
                                
                                let matchStr = recipe.matchPercentage.map { "\($0)% Match" } ?? "Match"
                                let usedStr = recipe.usedIngredientsCount.map { "\($0) used" } ?? "0 used"
                                
                                MenuCard(
                                    title: recipe.title.capitalized,
                                    category: recipe.category ?? "Unknown",
                                    usage: usedStr,
                                    match: matchStr
                                )
                                
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .frame(maxWidth: .infinity) // 🌟 บังคับตัว ScrollView ให้ขยายเต็มจอด้วย
        }
        .background(Color(white: 0.98)) // พื้นหลังจะเต็มจอสวยงามแล้วครับ
        .navigationBarBackButtonHidden(true)
        .onAppear {
            viewModel.fetchRecommendations(selectedItems: selectedIngredients)
        }
    }
}

// MARK: - MenuCard (เหมือนเดิม)
struct MenuCard: View {
    var title: String
    var category: String
    var usage: String
    var match: String
    
    var body: some View {
        HStack(spacing: 15) {
            VStack(alignment: .leading, spacing: 8) {
                Text(title).font(.system(size: 18, weight: .bold)).foregroundColor(.black)
                HStack(spacing: 15) {
                    Label(category, systemImage: "flame.fill").foregroundColor(.orange)
                    Label(usage, systemImage: "clock").foregroundColor(.blue)
                }.font(.system(size: 13)).foregroundColor(.gray)
            }
            Spacer()
            Text(match).font(.system(size: 12, weight: .bold)).foregroundColor(.green).padding(.vertical, 8).padding(.horizontal, 12).background(Color.green.opacity(0.15)).cornerRadius(18)
        }.padding(20).background(Color.white).cornerRadius(16).shadow(color: Color.black.opacity(0.05), radius: 5)
    }
}
