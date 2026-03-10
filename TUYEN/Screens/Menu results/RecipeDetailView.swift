import SwiftUI

struct RecipeDetailView: View {
    
    var body: some View {
        
        VStack {
            
            ScrollView {
                
                VStack(alignment: .leading, spacing: 20) {
                    
                    // TITLE
                    HStack {
                        
                        Text("Minced pork omelet")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Spacer()
                        
                        Text("Easy")
                            .font(.caption)
                            .padding(.horizontal,12)
                            .padding(.vertical,5)
                            .background(Color.green.opacity(0.2))
                            .foregroundColor(.green)
                            .cornerRadius(20)
                    }
                    
                    
                    // INFO BOX
                    HStack(spacing:0) {
                        
                        VStack {
                            Text("350")
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            Text("Kcal")
                                .foregroundColor(.gray)
                                .font(.caption)
                        }
                        .frame(maxWidth: .infinity)
                        
                        
                        Divider()
                        
                        
                        VStack {
                            Text("-")
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            Text("Ingredients")
                                .foregroundColor(.gray)
                                .font(.caption)
                        }
                        .frame(maxWidth: .infinity)
                        
                        
                        Divider()
                        
                        
                        VStack {
                            Text("10")
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            Text("Min")
                                .foregroundColor(.gray)
                                .font(.caption)
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(14)
                    
                    
                    // INGREDIENTS
                    Text("Ingredients required")
                        .font(.title3)
                        .fontWeight(.bold)

                    HStack(alignment: .top, spacing: 12) {
                        
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                            .font(.title3)
                        
                        VStack(alignment: .leading, spacing: 6) {
                            
                            Text("It's already in the refrigerator.")
                                .foregroundColor(.green)
                                .fontWeight(.semibold)
                            
                            Text("Chicken eggs, minced pork, fish sauce")
                                .foregroundColor(.black)
                        }
                        
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color.green.opacity(0.12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(Color.green.opacity(0.5), lineWidth: 1)
                    )
                    .cornerRadius(14)
                    
                    
                    // HOW TO
                    Text("How to do it")
                        .font(.title3)
                        .fontWeight(.bold)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        
                        Text("1. Crack the eggs into a bowl and beat them well.")
                        Text("2. Add the minced pork, soy sauce, pepper, and green onions, then mix together.")
                        Text("3. Heat oil in a pan over medium–high heat.")
                        Text("4. When the oil is hot, pour the egg mixture into the pan.")
                        Text("5. Fry for about 2–3 minutes until golden, then flip the omelet.")
                        Text("6. Cook the other side until done and serve with steamed rice.")
                        
                    }
                    .padding(.leading,10)
                    
                    
                    // BUTTONS
                    HStack(spacing: 15) {
                        
                        NavigationLink(destination: HistoriesView()) {
                            
                            HStack {
                                Image(systemName: "fork.knife")
                                Text("Let's Cook")
                                    .fontWeight(.semibold)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(15)
                        }
                        
                        
                        NavigationLink(destination: CommunityReviewsView()) {
                            
                            HStack {
                                Image(systemName: "message.fill")
                                Text("Read reviews")
                                    .fontWeight(.semibold)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.black)
                            .foregroundColor(.white)
                            .cornerRadius(15)
                        }
                    }
                    
                }
                .padding()
            }
        }
    }
}
