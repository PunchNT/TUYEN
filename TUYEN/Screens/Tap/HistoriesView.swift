import SwiftUI

// MARK: - Models for History API
struct HistoryResponse: Codable {
    let status: String
    let data: [HistoryItem]
}

struct HistoryItem: Codable, Identifiable {
    var id: Int { history_id }
    let history_id: Int
    let recipe_id: Int
    let history_date: String
}

struct HistoriesView: View {
    @State private var historyItems: [HistoryItem] = []
    @State private var isLoading = false
    
    // สร้างปฏิทินย้อนหลัง 7 วัน
    @State private var dates: [Date] = {
        (0..<7).map { Calendar.current.date(byAdding: .day, value: -$0, to: Date())! }.reversed()
    }()
    @State private var selectedDate: Date = Date()
    
    var userId: Int {
        return UserDefaults.standard.integer(forKey: "user_id")
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // TITLE
            HStack {
                Text("Histories").font(.largeTitle).bold()
                Image(systemName: "clock.arrow.circlepath").foregroundColor(.blue).font(.title2)
            }
            .padding(.horizontal)
            .padding(.top, 20)
            
            // DAYS SELECTOR (ปฏิทิน)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(dates, id: \.self) { date in
                        let isSelected = Calendar.current.isDate(date, inSameDayAs: selectedDate)
                        
                        VStack(spacing: 6) {
                            Text(dateFormatter(format: "E", from: date))
                                .font(.caption)
                                .foregroundColor(isSelected ? .white : .black)
                            
                            Text(dateFormatter(format: "d", from: date))
                                .font(.headline)
                                .foregroundColor(isSelected ? .white : .black)
                        }
                        .frame(width: 55, height: 70)
                        .background(isSelected ? Color.green : Color.white)
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.3), lineWidth: 1))
                        .cornerRadius(12)
                        .onTapGesture {
                            withAnimation(.easeInOut) {
                                selectedDate = date
                                fetchHistoryByDate(targetDate: date)
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
            
            // HISTORY LIST (🌟 เปลี่ยนเป็น List เพื่อให้ปัดซ้ายลบได้)
            if isLoading {
                ProgressView("Loading history...")
                    .frame(maxWidth: .infinity)
                    .padding(.top, 40)
                Spacer()
            } else if historyItems.isEmpty {
                Text("No cooking history for this day.")
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity)
                    .padding(.top, 40)
                Spacer()
            } else {
                List {
                    ForEach(historyItems) { item in
                        HistoryCard(history: item)
                            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 15, trailing: 0))
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                        // 🌟 ฟังก์ชันปัดซ้ายเพื่อลบ
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button(role: .destructive) {
                                    deleteHistory(item: item)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                    }
                }
                .listStyle(.plain)
                .padding(.horizontal)
            }
        }
        .background(Color(white: 0.98).ignoresSafeArea())
        .onAppear {
            fetchHistoryByDate(targetDate: selectedDate)
        }
    }
    
    // MARK: - Functions
    func dateFormatter(format: String, from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    
    func fetchHistoryByDate(targetDate: Date) {
        isLoading = true
        let dateString = dateFormatter(format: "yyyy-MM-dd", from: targetDate)
        
        guard let url = URL(string: "https://smartfridge-api-gp-fudkfahvfeazgced.southeastasia-01.azurewebsites.net/history/\(userId)/by-date?target_date=\(dateString)") else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            DispatchQueue.main.async {
                isLoading = false
                guard let data = data, let result = try? JSONDecoder().decode(HistoryResponse.self, from: data) else {
                    historyItems = []
                    return
                }
                self.historyItems = result.data
            }
        }.resume()
    }
    
    // 🌟 ฟังก์ชันยิง API ลบประวัติ
    func deleteHistory(item: HistoryItem) {
        let urlString = "https://smartfridge-api-gp-fudkfahvfeazgced.southeastasia-01.azurewebsites.net/history/remove/\(item.history_id)"
        guard let url = URL(string: urlString) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { _, _, _ in
            DispatchQueue.main.async {
                // พอลบสำเร็จ ก็เอาออกจากหน้าจอทันที
                withAnimation {
                    self.historyItems.removeAll { $0.id == item.id }
                }
            }
        }.resume()
    }
}

// 🌟 สร้างกล่องรับข้อมูลสำหรับหน้าประวัติโดยเฉพาะ (ดึงแค่รูปกับชื่อ เพื่อความเร็วและกันแอปพัง)
struct HistoryRecipeDetailResponse: Codable {
    let status: String?
    let data: HistoryRecipeDetailData?
}

struct HistoryRecipeDetailData: Codable {
    let title: String?
    let calories: Int?
    let image_url: String? // 🌟 ใช้ชื่อนี้ตรงตามตารางฐานข้อมูลเป๊ะๆ
}

// 🌟 การ์ดแสดงประวัติ
struct HistoryCard: View {
    let history: HistoryItem
    
    @State private var recipeTitle: String = "Loading recipe..."
    @State private var recipeKcal: String = ""
    @State private var timeString: String = ""
    @State private var imageUrl: String = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("COOKING").font(.caption).foregroundColor(.gray).fontWeight(.bold)
                Spacer()
                Text(timeString).font(.caption).foregroundColor(.gray)
            }
            .padding(.bottom, 2)
            
            HStack(spacing: 15) {
                // 🌟 ดึงรูปแบบเดียวกับหน้า Search แบบเป๊ะๆ (เอา .frame ไว้ข้างนอกแล้ว)
                if let url = URL(string: imageUrl), !imageUrl.isEmpty {
                    AsyncImage(url: url) { image in
                        image.resizable().scaledToFill()
                    } placeholder: {
                        Color.gray.opacity(0.2).overlay(ProgressView())
                    }
                    .frame(width: 50, height: 50)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                } else {
                    // รูปสำรองตอนยังไม่โหลด หรือลิงก์พัง
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(.systemGray5))
                        .frame(width: 50, height: 50)
                        .overlay(Image(systemName: "fork.knife").foregroundColor(.gray))
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(recipeTitle).font(.headline)
                    if !recipeKcal.isEmpty && recipeKcal != "0" {
                        Text("\(recipeKcal) Cal.").foregroundColor(.gray).font(.caption)
                    }
                }
                Spacer()
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(14)
        .shadow(color: .black.opacity(0.05), radius: 4)
        .onAppear {
            formatTime()
            fetchRecipeInfo()
        }
    }
    
    // 🌟 1. แก้เวลา: หั่นจากช่องว่างตรงๆ ตามรูปแบบ JSON จริง ("2569-03-12 02:08:34")
    func formatTime() {
        let parts = history.history_date.components(separatedBy: " ")
        
        if parts.count == 2 {
            let timePart = parts[1] // ได้ "02:08:34"
            self.timeString = String(timePart.prefix(5)) // หั่นเอาแค่ 5 ตัวแรก จะได้ "02:08"
        } else {
            // เผื่อกรณี API ส่งมามีตัว T
            let tParts = history.history_date.components(separatedBy: "T")
            if tParts.count > 1 {
                self.timeString = String(tParts[1].prefix(5))
            } else {
                self.timeString = history.history_date
            }
        }
    }
    
    // 🌟 2. ดึงข้อมูล API: ใช้ Model ที่ปลอดภัย และแก้บัค Apple บล็อกรูป
    func fetchRecipeInfo() {
        let url = URL(string: "https://smartfridge-api-gp-fudkfahvfeazgced.southeastasia-01.azurewebsites.net/recipes/\(history.recipe_id)/details")!
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            DispatchQueue.main.async {
                // เปลี่ยนมาใช้ HistoryRecipeDetailResponse เพื่อกันแอปพังเวลา API ส่งข้อมูลมาไม่ครบ
                if let data = data, let result = try? JSONDecoder().decode(HistoryRecipeDetailResponse.self, from: data) {
                    if let details = result.data {
                        self.recipeTitle = details.title?.capitalized ?? "Recipe #\(history.recipe_id)"
                        self.recipeKcal = "\(details.calories ?? 0)"
                        
                        // คลีนลิงก์รูปภาพ
                        if let rawUrl = details.image_url, !rawUrl.isEmpty {
                            var cleanUrl = rawUrl.trimmingCharacters(in: .whitespacesAndNewlines)
                            
                            // 🌟 บังคับเปลี่ยน http เป็น https เพื่อไม่ให้ iOS บล็อกการแสดงรูป
                            if cleanUrl.hasPrefix("http://") {
                                cleanUrl = cleanUrl.replacingOccurrences(of: "http://", with: "https://")
                            }
                            
                            self.imageUrl = cleanUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? cleanUrl
                        } else {
                            self.imageUrl = ""
                        }
                    }
                } else {
                    self.recipeTitle = "Recipe #\(history.recipe_id)"
                }
            }
        }.resume()
    }
}
