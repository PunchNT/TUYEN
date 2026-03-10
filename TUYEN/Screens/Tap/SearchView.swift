import SwiftUI

struct SearchView: View {
    
    @State private var searchText = ""
    @State private var selectedKeyword: String? = nil
    @State private var favorites: Set<String> = []
    
    let keywords = ["Egg","Rice","Pork","Omelet","Soup","Salad"]
    
    let foods: [Food] = [
        Food(name: "Minced pork omelet", remain: 10),
        Food(name: "Chicken Salad", remain: 8),
        Food(name: "Chicken Soup", remain: 6),
        Food(name: "Fried Rice", remain: 12),
        Food(name: "Pork Basil", remain: 9),
        Food(name: "Egg Sandwich", remain: 7)
    ]
    
    
    var filteredFoods: [Food] {
        
        let filtered = foods.filter { food in
            
            let searchMatch =
            searchText.isEmpty ||
            food.name.localizedCaseInsensitiveContains(searchText)
            
            let keywordMatch =
            selectedKeyword == nil ||
            food.name.localizedCaseInsensitiveContains(selectedKeyword!)
            
            return searchMatch && keywordMatch
        }
        
        return filtered.sorted {
            favorites.contains($0.name) && !favorites.contains($1.name)
        }
    }
    
    
    var body: some View {
        
        NavigationStack {
            
            ScrollView {
                
                VStack(alignment: .leading, spacing: 20) {
                    
                    Text("Search menu")
                        .font(.largeTitle)
                        .bold()
                    
                    
                    // SEARCH BAR
                    HStack {
                        
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        
                        TextField("Type the name of the menu item...", text: $searchText)
                        
                    }
                    .padding()
                    .background(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                    )
                    
                    
                    // KEYWORDS
                    ScrollView(.horizontal, showsIndicators: false) {
                        
                        HStack(spacing: 12) {
                            
                            ForEach(keywords, id: \.self) { key in
                                
                                Button {
                                    
                                    if selectedKeyword == key {
                                        selectedKeyword = nil
                                    } else {
                                        selectedKeyword = key
                                    }
                                    
                                } label: {
                                    
                                    Text(key)
                                        .foregroundColor(.black)
                                        .padding(.horizontal,16)
                                        .padding(.vertical,8)
                                        .background(
                                            selectedKeyword == key
                                            ? Color.green.opacity(0.25)
                                            : Color.white
                                        )
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(
                                                    selectedKeyword == key
                                                    ? Color.green
                                                    : Color.gray.opacity(0.4),
                                                    lineWidth: 1
                                                )
                                        )
                                }
                            }
                        }
                    }
                    
                    
                    Text("Menu")
                        .font(.title3)
                        .bold()
                    
                    
                    // MENU GRID
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 16) {
                        
                        ForEach(filteredFoods) { food in
                            
                            ZStack(alignment: .topTrailing) {
                                
                                NavigationLink {
                                    
                                    RecipeDetailView()
                                    
                                } label: {
                                    
                                    ZStack {
                                        
                                        RoundedRectangle(cornerRadius: 16)
                                            .fill(
                                                favorites.contains(food.name)
                                                ? Color.green.opacity(0.25)
                                                : Color.white
                                            )
                                        
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                        
                                        Text(food.name)
                                            .foregroundColor(.black)
                                            .font(.headline)
                                            .padding()
                                    }
                                    .frame(height: 100)
                                }
                                
                                
                                // HEART BUTTON
                                Button {
                                    
                                    if favorites.contains(food.name) {
                                        favorites.remove(food.name)
                                    } else {
                                        favorites.insert(food.name)
                                    }
                                    
                                } label: {
                                    
                                    Image(systemName:
                                            favorites.contains(food.name)
                                          ? "heart.fill"
                                          : "heart")
                                    
                                        .foregroundColor(
                                            favorites.contains(food.name)
                                            ? .pink
                                            : .black
                                        )
                                        .padding(10)
                                }
                            }
                        }
                    }
                }
                .padding()
            }
        }
    }
}



struct Food: Identifiable {
    let id = UUID()
    let name: String
    let remain: Int
}
