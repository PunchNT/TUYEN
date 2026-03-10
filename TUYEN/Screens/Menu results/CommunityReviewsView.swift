import SwiftUI

struct CommunityReviewsView: View {
    
    @State private var messageText: String = ""
    
    @State private var reviews: [Review] = [
        Review(name: "User_99", time: "2 hours ago", text: "This recipe is so easy, even dorm students can make it!", rating: 5),
        Review(name: "HealtyGuy", time: "1 day ago", text: "Reduce the oil a bit; it'll be delicious and healthier.", rating: 4)
    ]
    
    var body: some View {
        
        VStack {
            
            // Top bar
            HStack {
                
                Spacer()
                
                Image(systemName: "message.fill")
                    .foregroundColor(.green)
                    .font(.title2)
            }
            .padding()
            
            
            // Reviews
            ScrollView {
                VStack(spacing:16){
                    
                    ForEach(reviews) { review in
                        ReviewCard(review: review)
                    }
                }
                .padding(.horizontal)
            }
            
            
            Spacer()
            
            
            // Input bar
            HStack{
                
                TextField("Write your review...", text: $messageText)
                    .padding()
                
                Button {
                    sendReview()
                } label: {
                    Image(systemName: "paperplane")
                        .font(.title3)
                        .foregroundColor(.white)
                        .padding(14)
                        .background(Color.black)
                        .cornerRadius(12)
                }
            }
            .background(Color.white)
            .cornerRadius(14)
            .shadow(radius:3)
            .padding()
        }
        .background(Color(.systemGray6))
    }
    
    
    // Add review
    func sendReview(){
        
        guard !messageText.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        
        let newReview = Review(
            name: "You",
            time: "Just now",
            text: messageText,
            rating: 5
        )
        
        reviews.insert(newReview, at: 0)
        messageText = ""
    }
}

struct ReviewCard: View {
    
    let review: Review
    
    var body: some View {
        
        HStack(alignment:.top, spacing:12){
            
            // Avatar
            Circle()
                .fill(Color.green)
                .frame(width:45,height:45)
                .overlay(
                    Text(String(review.name.prefix(1)))
                        .foregroundColor(.white)
                        .font(.headline)
                )
            
            
            VStack(alignment:.leading, spacing:6){
                
                HStack{
                    
                    VStack(alignment:.leading){
                        
                        Text(review.name)
                            .font(.headline)
                        
                        Text(review.time)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                    HStack(spacing:2){
                        ForEach(0..<review.rating, id:\.self){ _ in
                            Image(systemName:"star.fill")
                                .foregroundColor(.yellow)
                                .font(.caption)
                        }
                    }
                }
                
                Text(review.text)
                    .font(.body)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius:2)
    }
}

struct Review: Identifiable {
    
    let id = UUID()
    let name: String
    let time: String
    let text: String
    let rating: Int
}
