import SwiftUI
import Combine

// MARK: - API Models
struct SearchRecipeAPIResponse: Codable {
    let status: String?
    let data: [SearchRecipeData]?
}

struct SearchRecipeData: Codable, Identifiable {
    var id: Int { recipe_id }
    let recipe_id: Int
    let title: String
    let calories: Int?
    let image_url: String?
}

struct FavoriteAPIResponse: Codable {
    let status: String?
    let data: [FavoriteRecipeData]?
}

struct FavoriteRecipeData: Codable, Identifiable {
    var id: Int { recipe_id }
    let favorite_id: Int?
    let recipe_id: Int
    let title: String
    let calories: Int?
    let image_url: String?
}

// MARK: - ViewModel
class SearchViewModel: ObservableObject {
    @Published var searchResults: [SearchRecipeData] = []
    @Published var favoriteRecipes: [FavoriteRecipeData] = []
    @Published var favoriteRecipeIDs: Set<Int> = []
    
    @Published var isSearching = false
    @Published var isLoading = false
    
    var userId: Int {
        UserDefaults.standard.integer(forKey: "user_id") == 0 ? 15 : UserDefaults.standard.integer(forKey: "user_id")
    }
    
    func fetchFavorites() {
        let url = URL(string: "https://smartfridge-api-gp-fudkfahvfeazgced.southeastasia-01.azurewebsites.net/favorites/\(userId)")!
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else { return }
            DispatchQueue.main.async {
                if let result = try? JSONDecoder().decode(FavoriteAPIResponse.self, from: data), let faves = result.data {
                    self.favoriteRecipes = faves
                    self.favoriteRecipeIDs = Set(faves.map { $0.recipe_id })
                }
            }
        }.resume()
    }
    
    func searchRecipes(query: String) {
        guard !query.isEmpty else {
            DispatchQueue.main.async {
                self.searchResults = []
                self.isSearching = false
            }
            return
        }
        
        DispatchQueue.main.async {
            self.isLoading = true
            self.isSearching = true
        }
        
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let url = URL(string: "https://smartfridge-api-gp-fudkfahvfeazgced.southeastasia-01.azurewebsites.net/recipes/search?q=\(encodedQuery)")!
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            DispatchQueue.main.async {
                self.isLoading = false
                guard let data = data else { return }
                
                if let result = try? JSONDecoder().decode(SearchRecipeAPIResponse.self, from: data), let recipes = result.data {
                    self.searchResults = recipes
                } else {
                    self.searchResults = []
                }
            }
        }.resume()
    }
    
    func toggleFavorite(recipeId: Int, recipeTitle: String, calories: Int?, imageUrl: String?) {
        let isFave = favoriteRecipeIDs.contains(recipeId)
        
        if isFave {
            favoriteRecipeIDs.remove(recipeId)
            favoriteRecipes.removeAll { $0.recipe_id == recipeId }
            removeFavoriteAPI(recipeId: recipeId)
        } else {
            favoriteRecipeIDs.insert(recipeId)
            let newFave = FavoriteRecipeData(favorite_id: nil, recipe_id: recipeId, title: recipeTitle, calories: calories, image_url: imageUrl)
            favoriteRecipes.insert(newFave, at: 0)
            addFavoriteAPI(recipeId: recipeId)
        }
    }
    
    private func addFavoriteAPI(recipeId: Int) {
        let url = URL(string: "https://smartfridge-api-gp-fudkfahvfeazgced.southeastasia-01.azurewebsites.net/favorite/add")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: Any] = ["user_id": userId, "recipe_id": recipeId]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        URLSession.shared.dataTask(with: request).resume()
    }
    
    private func removeFavoriteAPI(recipeId: Int) {
        let url = URL(string: "https://smartfridge-api-gp-fudkfahvfeazgced.southeastasia-01.azurewebsites.net/favorite/remove/\(userId)/\(recipeId)")!
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        URLSession.shared.dataTask(with: request).resume()
    }
}

// MARK: - SearchView
struct SearchView: View {
    @StateObject private var viewModel = SearchViewModel()
    
    @State private var searchText = ""
    @State private var selectedKeyword: String? = nil
    let keywords = ["Egg", "Rice", "Pork", "Omelet", "Chicken", "Fried Rice"]
    
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 15) {
                
                // HEADER
                HStack {
                    Text("Search menu")
                        .font(.title)
                        .bold()
                    Image(systemName: "magnifyingglass")
                        .font(.title2)
                        .foregroundColor(.black)
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 10)
                
                // SEARCH BAR
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    
                    TextField("Type the name of the menu item...", text: $searchText)
                        .onSubmit {
                            selectedKeyword = nil
                            viewModel.searchRecipes(query: searchText)
                        }
                    
                    if !searchText.isEmpty {
                        Button(action: {
                            searchText = ""
                            selectedKeyword = nil
                            viewModel.searchRecipes(query: "")
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding()
                // 🌟 แก้ขอบขาวทะลุช่องค้นหา
                .background(RoundedRectangle(cornerRadius: 12).fill(Color.white))
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.3), lineWidth: 1))
                .padding(.horizontal)
                
                // KEYWORDS CHIPS
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(keywords, id: \.self) { key in
                            Button {
                                if selectedKeyword == key {
                                    selectedKeyword = nil
                                    searchText = ""
                                    viewModel.searchRecipes(query: "")
                                } else {
                                    selectedKeyword = key
                                    searchText = key
                                    viewModel.searchRecipes(query: key)
                                }
                            } label: {
                                Text(key)
                                    .font(.subheadline)
                                    .foregroundColor(selectedKeyword == key ? .green : .gray)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    // 🌟 แก้ขอบขาวทะลุปุ่มหมวดหมู่
                                    .background(
                                        RoundedRectangle(cornerRadius: 20)
                                            .fill(selectedKeyword == key ? Color.green.opacity(0.1) : Color.white)
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(selectedKeyword == key ? Color.green : Color.gray.opacity(0.3), lineWidth: 1)
                                    )
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                
                // CONTENT AREA
                ScrollView {
                    VStack(alignment: .leading) {
                        if viewModel.isSearching {
                            Text("Search Results")
                                .font(.title3)
                                .bold()
                                .padding(.horizontal)
                                .padding(.top, 10)
                            
                            if viewModel.isLoading {
                                ProgressView("Searching...")
                                    .frame(maxWidth: .infinity)
                                    .padding(.top, 50)
                            } else if viewModel.searchResults.isEmpty {
                                Text("No recipes found.")
                                    .foregroundColor(.gray)
                                    .frame(maxWidth: .infinity)
                                    .padding(.top, 50)
                            } else {
                                LazyVGrid(columns: columns, spacing: 15) {
                                    ForEach(viewModel.searchResults) { recipe in
                                        SearchRecipeCard(
                                            recipeId: recipe.recipe_id,
                                            title: recipe.title,
                                            calories: recipe.calories,
                                            imageUrl: recipe.image_url,
                                            isFavorite: viewModel.favoriteRecipeIDs.contains(recipe.recipe_id),
                                            onHeartTapped: {
                                                viewModel.toggleFavorite(recipeId: recipe.recipe_id, recipeTitle: recipe.title, calories: recipe.calories, imageUrl: recipe.image_url)
                                            }
                                        )
                                    }
                                }
                                .padding(.horizontal)
                            }
                        } else {
                            Text("My Favorites")
                                .font(.title3)
                                .bold()
                                .padding(.horizontal)
                                .padding(.top, 10)
                            
                            if viewModel.favoriteRecipes.isEmpty {
                                VStack(spacing: 15) {
                                    Image(systemName: "fork.knife")
                                        .font(.system(size: 60))
                                        .foregroundColor(Color.gray.opacity(0.3))
                                    
                                    Text("What do you want to cook today?")
                                        .font(.headline)
                                        .foregroundColor(.black)
                                    
                                    Text("Try searching for menu like 'Omelet' or 'Fried Rice'")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.top, 80)
                            } else {
                                LazyVGrid(columns: columns, spacing: 15) {
                                    ForEach(viewModel.favoriteRecipes) { recipe in
                                        SearchRecipeCard(
                                            recipeId: recipe.recipe_id,
                                            title: recipe.title,
                                            calories: recipe.calories,
                                            imageUrl: recipe.image_url,
                                            isFavorite: true,
                                            onHeartTapped: {
                                                viewModel.toggleFavorite(recipeId: recipe.recipe_id, recipeTitle: recipe.title, calories: recipe.calories, imageUrl: recipe.image_url)
                                            }
                                        )
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                    }
                    .padding(.bottom, 30)
                }
            }
            .background(Color(white: 0.98).ignoresSafeArea())
            .onAppear {
                viewModel.fetchFavorites()
            }
        }
    }
}

/// MARK: - Recipe Card
struct SearchRecipeCard: View {
    let recipeId: Int
    let title: String
    let calories: Int?
    let imageUrl: String?
    let isFavorite: Bool
    let onHeartTapped: () -> Void
    
    var body: some View {
        // 🌟 เพิ่ม showCookButton: false เข้าไปตรงนี้
        NavigationLink(destination: RecipeDetailView(recipeId: recipeId, recipeName: title, showCookButton: false)) {
            
            VStack(alignment: .leading, spacing: 8) {
                ZStack(alignment: .topTrailing) {
                    if let imgStr = imageUrl, let url = URL(string: imgStr) {
                        AsyncImage(url: url) { image in
                            image.resizable().scaledToFill()
                        } placeholder: {
                            Color.gray.opacity(0.2).overlay(ProgressView())
                        }
                        .frame(height: 120)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    } else {
                        Color.gray.opacity(0.2)
                            .frame(height: 120)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .overlay(Image(systemName: "photo").foregroundColor(.gray))
                    }
                    
                    Button(action: onHeartTapped) {
                        Image(systemName: isFavorite ? "heart.fill" : "heart")
                            .font(.system(size: 18))
                            .foregroundColor(isFavorite ? .red : .gray)
                            .padding(8)
                            .background(Color.white.opacity(0.8))
                            .clipShape(Circle())
                            .padding(6)
                    }
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title.capitalized)
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .lineLimit(1)
                    
                    Text("\(calories ?? 0) Cal.")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .padding(.horizontal, 4)
                .padding(.bottom, 10)
            }
            // 🌟 แก้ขอบขาวทะลุในการ์ดอาหาร
            .background(RoundedRectangle(cornerRadius: 12).fill(Color.white))
            .shadow(color: .black.opacity(0.05), radius: 4, y: 2)
        }
    }
}
