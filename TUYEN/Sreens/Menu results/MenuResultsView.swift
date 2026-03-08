import SwiftUI

struct MenuResultsView: View {
    
    var body: some View {
        
        NavigationStack {
            
            VStack(alignment:.leading){
                
                HStack{
                    
                    VStack(alignment:.leading){
                        Text("Menu results")
                            .font(.title3)
                            .fontWeight(.bold)
                        
                        Text("I found 4 menu items from the ingredients in the cupboard.")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                .padding()
                
                ScrollView{
                    
                    NavigationLink(destination: RecipeDetailView()) {
                        MenuCard(
                            title:"Minced pork omelet",
                            kcal:"350 kcal",
                            time:"10 Min",
                            match:"100% Match"
                        )
                    }
                    .buttonStyle(.plain)
                    
                    
                    NavigationLink(destination: RecipeDetailView()) {
                        MenuCard(
                            title:"Chicken Salad",
                            kcal:"250 kcal",
                            time:"",
                            match:""
                        )
                    }
                    .buttonStyle(.plain)
                    
                    
                    NavigationLink(destination: RecipeDetailView()) {
                        MenuCard(
                            title:"Chicken Salad",
                            kcal:"250 kcal",
                            time:"",
                            match:""
                        )
                    }
                    .buttonStyle(.plain)
                    
                }
            }
            .background(Color(.systemGray6))
        }
    }
}

struct MenuCard: View {
    
    var title:String
    var kcal:String
    var time:String
    var match:String
    
    var body: some View {
        
        VStack(alignment:.leading){
            
            Rectangle()
                .fill(Color.green)
                .frame(height:120)
                .overlay(
                    HStack{
                        Spacer()
                        
                        if match != "" {
                            Text(match)
                                .font(.caption)
                                .padding(6)
                                .background(Color.white)
                                .cornerRadius(8)
                                .padding()
                        }
                    }
                )
            
            VStack(alignment:.leading){
                
                Text(title)
                    .font(.headline)
                
                HStack{
                    
                    Image(systemName:"flame")
                        .foregroundColor(.orange)
                    
                    Text(kcal)
                        .font(.caption)
                    
                    if time != ""{
                        
                        Image(systemName:"clock")
                            .foregroundColor(.blue)
                        
                        Text(time)
                            .font(.caption)
                    }
                }
                .foregroundColor(.gray)
            }
            .padding()
        }
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius:3)
        .padding(.horizontal)
        .padding(.bottom,10)
    }
}
