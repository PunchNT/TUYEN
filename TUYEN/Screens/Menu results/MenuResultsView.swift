import SwiftUI

struct MenuResultsView: View {
    
    @Environment(\.dismiss) var dismiss
    
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
                
                Text("I found 10 menu items")
                    .font(.system(size: 16))
                    .foregroundColor(.gray)
            }
            .padding(.horizontal)
            .padding(.top, 10)
            .padding(.bottom, 20)
            
            
            // MENU LIST
            ScrollView {
                
                VStack(spacing: 12) {
                    
                    NavigationLink(destination: RecipeDetailView()) {
                        MenuCard(
                            title: "Freezing Eggs",
                            category: "Dessert",
                            usage: "1 used",
                            match: "100% Match"
                        )
                    }
                    .buttonStyle(.plain)
                    
                    
                    NavigationLink(destination: RecipeDetailView()) {
                        MenuCard(
                            title: "Easter Hard Boiled Eggs",
                            category: "Breakfast",
                            usage: "1 used",
                            match: "100% Match"
                        )
                    }
                    .buttonStyle(.plain)
                    
                }
                .padding(.horizontal)
                
            }
            
        }
        .background(Color(white: 0.98))
        .navigationBarBackButtonHidden(true)
        
    }
}



struct MenuCard: View {
    
    var title: String
    var category: String
    var usage: String
    var match: String
    
    var body: some View {
        
        HStack(spacing: 15) {
            
            VStack(alignment: .leading, spacing: 8) {
                
                Text(title)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.black)
                
                
                HStack(spacing: 15) {
                    
                    Label(category, systemImage: "flame.fill")
                        .foregroundColor(.orange)
                    
                    Label(usage, systemImage: "clock")
                        .foregroundColor(.blue)
                    
                }
                .font(.system(size: 13))
                .foregroundColor(.gray)
            }
            
            Spacer()
            
            
            Text(match)
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(.green)
                .padding(.vertical, 8)
                .padding(.horizontal, 12)
                .background(Color.green.opacity(0.15))
                .cornerRadius(18)
        }
        .padding(20)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 5)
    }
}
