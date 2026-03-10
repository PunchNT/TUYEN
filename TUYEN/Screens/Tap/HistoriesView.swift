import SwiftUI

struct HistoriesView: View {
    
    @State private var selectedDay: Int = 24
    
    let days: [DayItem] = [
        DayItem(day: "S", date: 24),
        DayItem(day: "Sa", date: 23),
        DayItem(day: "F", date: 22),
        DayItem(day: "Th", date: 21),
        DayItem(day: "W", date: 20),
        DayItem(day: "T", date: 19),
        DayItem(day: "M", date: 18)
    ]
    
    let histories: [HistoryFood] = [
        HistoryFood(day: 24, title: "Minced pork omelet", kcal: "350 kcal"),
        HistoryFood(day: 22, title: "Chicken salad", kcal: "250 kcal"),
        HistoryFood(day: 21, title: "Fried rice", kcal: "400 kcal")
    ]
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 20) {
            
            // TITLE
            HStack {
                
                Text("Histories")
                    .font(.title)
                    .bold()
                
                Image(systemName: "clock.arrow.circlepath")
                    .foregroundColor(.blue)
            }
            
            
            // DAYS SELECTOR
            ScrollView(.horizontal, showsIndicators: false) {
                
                HStack(spacing: 12) {
                    
                    ForEach(days, id: \.date) { item in
                        
                        DayCard(
                            day: item.day,
                            date: item.date,
                            isSelected: selectedDay == item.date
                        )
                        .onTapGesture {
                            
                            withAnimation(.easeInOut) {
                                selectedDay = item.date
                            }
                        }
                    }
                }
                .padding(.vertical, 5)
            }
            
            
            // HISTORY LIST
            VStack(spacing: 15) {
                
                ForEach(histories.filter{$0.day == selectedDay}) { food in
                    
                    HistoryCard(food: food)
                }
                
                if histories.filter({$0.day == selectedDay}).isEmpty {
                    
                    Text("No cooking history for this day")
                        .foregroundColor(.gray)
                        .padding(.top,40)
                }
            }
            
            
            Divider()
            
            Spacer()
            
        }
        .padding()
        .background(Color(.systemGray6))
    }
}

struct DayCard: View {
    
    var day: String
    var date: Int
    var isSelected: Bool
    
    var body: some View {
        
        VStack(spacing: 6) {
            
            Text(day)
                .font(.caption)
            
            Text("\(date)")
                .font(.headline)
        }
        .frame(width: 50, height: 60)
        .background(
            isSelected ?
            Color.white :
            Color(.systemGray6)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(
                    isSelected ? Color.black : Color.gray.opacity(0.2),
                    lineWidth: isSelected ? 2 : 1
                )
        )
        .cornerRadius(12)
        .shadow(color: .black.opacity(isSelected ? 0.15 : 0), radius: 4)
    }
}

struct HistoryCard: View {
    
    let food: HistoryFood
    
    var body: some View {
        
        HStack(spacing: 15) {
            
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(.systemGray5))
                .frame(width: 60, height: 60)
            
            
            VStack(alignment: .leading) {
                
                Text(food.title)
                    .font(.headline)
                
                Text(food.kcal)
                    .foregroundColor(.gray)
                    .font(.caption)
            }
            
            Spacer()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(14)
        .shadow(color: .black.opacity(0.05), radius: 4)
    }
}

struct DayItem {
    let day: String
    let date: Int
}

struct HistoryFood: Identifiable {
    
    let id = UUID()
    let day: Int
    let title: String
    let kcal: String
}
