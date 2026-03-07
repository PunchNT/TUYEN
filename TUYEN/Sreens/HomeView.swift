import SwiftUI

struct HomeView: View {
    
    @State private var showAddIngredient = false
    
    var body: some View {
        
        ZStack {
            
            VStack(spacing:20) {
                
                // HEADER
                HStack {
                    
                    Image("tuyen_logo")
                        .resizable()
                        .frame(width:40,height:40)
                    
                    VStack(alignment:.leading) {
                        Text("My TuYen")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text("TuYen")
                            .foregroundColor(.gray)
                            .font(.caption)
                    }
                    
                    Spacer()
                    
                    // ปุ่ม +
                    Button {
                        withAnimation(.spring()) {
                            showAddIngredient = true
                        }
                    } label: {
                        Image(systemName: "plus")
                            .font(.title2)
                            .foregroundColor(.green)
                    }
                    
                }
                .padding(.horizontal)
                
                
                // EXPIRE CARD
                HStack {
                    
                    Image(systemName: "clock")
                        .foregroundColor(.orange)
                    
                    VStack(alignment:.leading){
                        
                        Text("Expired notification")
                            .fontWeight(.bold)
                            .foregroundColor(.orange)
                        
                        Text("Spring onion will expire in 1 days!!")
                            .font(.caption)
                            .foregroundColor(.orange)
                    }
                    
                    Spacer()
                    
                }
                .padding()
                .background(Color.orange.opacity(0.2))
                .cornerRadius(15)
                .padding(.horizontal)
                
                
                // LIST
                VStack(spacing:15){
                    
                    IngredientCard(
                        name:"Egg",
                        remain:"Remaining: 4 eggs",
                        day:"10 Day",
                        color:.green
                    )
                    
                    IngredientCard(
                        name:"Minced pork",
                        remain:"Remaining: 300g",
                        day:"2 Day",
                        color:.yellow
                    )
                    
                    IngredientCard(
                        name:"Spring onion",
                        remain:"Remaining: 2 plants",
                        day:"1 Day",
                        color:.red
                    )
                    
                    IngredientCard(
                        name:"Garlic",
                        remain:"Remaining: 1 head",
                        day:"20 Day",
                        color:.green
                    )
                    
                }
                .padding(.horizontal)
                
                
                Spacer()
                
                
                // BUTTON
                Button {
                    
                } label: {
                    
                    HStack{
                        Image(systemName:"fork.knife")
                        Text("Find the menu from the available items.")
                    }
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth:.infinity)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(15)
                }
                .padding(.horizontal)
                
            }
            
            
            // POPUP
            if showAddIngredient {
                AddIngredientPopup(show: $showAddIngredient)
            }
        }
    }
}

#Preview {
    HomeView()
}
