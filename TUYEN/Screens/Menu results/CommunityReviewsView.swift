import SwiftUI

// MARK: - โครงสร้าง API สำหรับรีวิว
struct ReviewResponse: Codable {
    let status: String?
    let data: [ReviewItem]?
}

struct ReviewItem: Codable, Identifiable {
    var id: String { "\(review_id ?? Int.random(in: 1...9999))-\(created_at ?? "now")" }
    
    let review_id: Int?
    let user_id: Int?
    let recipe_id: Int?
    let rating: Int?
    let comment: String?
    let created_at: String?
    
    let reviewer_name: String?
    let username: String?
    
    // (ส่วนนี้ไม่แตะต้อง ทำงานได้ดีแล้ว)
    var getDisplayName: String {
        if let n = reviewer_name, !n.isEmpty, n.lowercased() != "null" { return n }
        if let n = username, !n.isEmpty, n.lowercased() != "null" { return n }
        if let uid = user_id, uid != 0 { return "User #\(uid)" }
        let savedName = UserDefaults.standard.string(forKey: "username") ?? ""
        return savedName.isEmpty ? "Anonymous" : savedName
    }
}

struct CommunityReviewsView: View {
    let recipeId: Int
    
    @State private var reviews: [ReviewItem] = []
    @State private var isLoading = true
    
    @State private var newComment: String = ""
    @State private var newRating: Int = 5
    @State private var isSubmitting = false
    @Environment(\.dismiss) var dismiss
    
    @State private var showToast = false
    @State private var toastMessage = ""
    
    var userId: Int {
        UserDefaults.standard.integer(forKey: "user_id") == 0 ? 15 : UserDefaults.standard.integer(forKey: "user_id")
    }
    
    var currentUsername: String {
        // 🌟 แก้คีย์เป็น display_name
        let savedName = UserDefaults.standard.string(forKey: "display_name") ?? ""
        return savedName.isEmpty ? "User \(userId)" : savedName
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                // HEADER
                HStack(spacing: 15) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "arrow.left")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.black)
                            .padding(10)
                            .background(Color.white)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.gray.opacity(0.3), lineWidth: 1))
                    }
                    Text("Community reviews")
                        .font(.title2)
                        .fontWeight(.bold)
                    Spacer()
                }
                .padding()
                .background(Color.white)
                
                // LIST REVIEWS
                ScrollView {
                    if isLoading {
                        ProgressView("Loading reviews...")
                            .frame(maxWidth: .infinity)
                            .padding(.top, 50)
                    } else if reviews.isEmpty {
                        VStack(spacing: 15) {
                            Image(systemName: "bubble.left.and.bubble.right")
                                .font(.system(size: 50))
                                .foregroundColor(.gray.opacity(0.5))
                            Text("No reviews yet.")
                                .font(.headline)
                                .foregroundColor(.gray)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.top, 80)
                    } else {
                        LazyVStack(spacing: 15) {
                            ForEach(reviews) { review in
                                ReviewCard(
                                    review: review,
                                    currentUserId: userId,
                                    currentUsername: currentUsername
                                ) {
                                    deleteReview(review: review)
                                }
                            }
                        }
                        .padding()
                    }
                }
                .frame(maxWidth: .infinity)
                .background(Color(.systemGray6))
                
                // WRITE REVIEW SECTION
                VStack(spacing: 10) {
                    HStack {
                        Text("Your Rating:")
                            .fontWeight(.semibold)
                        Spacer()
                        HStack(spacing: 5) {
                            ForEach(1...5, id: \.self) { index in
                                Image(systemName: index <= newRating ? "star.fill" : "star")
                                    .foregroundColor(.yellow)
                                    .font(.title3)
                                    .onTapGesture {
                                        withAnimation(.spring()) {
                                            newRating = index
                                        }
                                    }
                            }
                        }
                    }
                    
                    HStack(alignment: .bottom, spacing: 10) {
                        TextField("Write a review...", text: $newComment, axis: .vertical)
                            .padding(12)
                            .background(Color.white)
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.green, lineWidth: 1.5))
                            .lineLimit(1...4)
                        
                        Button(action: {
                            submitReview()
                        }) {
                            if isSubmitting {
                                ProgressView()
                                    .padding(12)
                                    .background(Color.black)
                                    .cornerRadius(10)
                            } else {
                                Image(systemName: "paperplane.fill")
                                    .foregroundColor(.white)
                                    .padding(12)
                                    .background(newComment.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? Color.gray : Color.black)
                                    .cornerRadius(10)
                            }
                        }
                        .disabled(newComment.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || isSubmitting)
                    }
                }
                .padding()
                .padding(.bottom, 20)
                .background(Color.white)
                .shadow(color: .black.opacity(0.1), radius: 5, y: -5)
            }
            
            // 🌟 แก้ไข: ย้ายแจ้งเตือนมาไว้ "กลางหน้าจอ" สไตล์เท่ๆ
            if showToast {
                VStack {
                    Text(toastMessage)
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 14)
                        .background(Color.black.opacity(0.85))
                        .clipShape(Capsule())
                        .shadow(color: .black.opacity(0.2), radius: 10, y: 5)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center) // ยึดให้อยู่กลางหน้าจอ
                .ignoresSafeArea()
                .transition(.scale.combined(with: .opacity)) // เด้งดึ๋งขึ้นมา
                .animation(.spring(), value: showToast)
                .zIndex(2) // ดันให้อยู่บนสุด
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            fetchReviews()
        }
    }
    
    // MARK: - 1. Fetch Reviews
    func fetchReviews() {
        isLoading = true
        let url = URL(string: "https://smartfridge-api-gp-fudkfahvfeazgced.southeastasia-01.azurewebsites.net/recipes/\(recipeId)/reviews")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            DispatchQueue.main.async {
                self.isLoading = false
                guard let data = data else { return }
                
                do {
                    let result = try JSONDecoder().decode(ReviewResponse.self, from: data)
                    self.reviews = (result.data ?? []).sorted(by: { ($0.created_at ?? "") > ($1.created_at ?? "") })
                } catch {
                    if let directArray = try? JSONDecoder().decode([ReviewItem].self, from: data) {
                        self.reviews = directArray.sorted(by: { ($0.created_at ?? "") > ($1.created_at ?? "") })
                    }
                }
            }
        }.resume()
    }
    
    // MARK: - 2. Add Review
    func submitReview() {
        isSubmitting = true
        let url = URL(string: "https://smartfridge-api-gp-fudkfahvfeazgced.southeastasia-01.azurewebsites.net/review/add")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        formatter.timeZone = TimeZone(identifier: "UTC")
        let dateString = formatter.string(from: Date())
        
        let body: [String: Any] = [
            "user_id": userId,
            "recipe_id": recipeId,
            "rating": newRating,
            "comment": newComment,
            "created_at": dateString
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { _, response, _ in
            DispatchQueue.main.async {
                self.isSubmitting = false
                
                if let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) {
                    self.toastMessage = "Review submitted!"
                    withAnimation { self.showToast = true }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation { self.showToast = false }
                    }
                    self.newComment = ""
                    self.newRating = 5
                    self.fetchReviews()
                } else {
                    self.toastMessage = "Failed to submit review!"
                    withAnimation { self.showToast = true }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation { self.showToast = false }
                    }
                }
            }
        }.resume()
    }
    
    // MARK: - 3. Delete Review
    func deleteReview(review: ReviewItem) {
        guard let rId = review.review_id else { return }
        
        // ลบออกจากหน้าจอก่อน ให้ผู้ใช้รู้สึกว่าลบแล้วจริงๆ ทันที
        withAnimation {
            self.reviews.removeAll { $0.id == review.id }
        }
        
        let url = URL(string: "https://smartfridge-api-gp-fudkfahvfeazgced.southeastasia-01.azurewebsites.net/review/remove/\(rId)")!
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        // 🌟 เพิ่มบรรทัดนี้ ตามเอกสาร API ที่ส่งมา
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        URLSession.shared.dataTask(with: request) { _, response, _ in
            DispatchQueue.main.async {
                if let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) {
                    // API ตอบกลับว่า "ลบรีวิวเรียบร้อยแล้ว!" เราก็โชว์ตามนั้นเลย
                    self.toastMessage = "ลบรีวิวเรียบร้อยแล้ว!"
                    withAnimation { self.showToast = true }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation { self.showToast = false }
                    }
                } else {
                    // ❌ ถ้าลบไม่สำเร็จที่ Server ให้เด้งข้อความ แล้วดึงรีวิวเดิมกลับมาโชว์
                    self.toastMessage = "เกิดข้อผิดพลาดในการลบ"
                    withAnimation { self.showToast = true }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation { self.showToast = false }
                    }
                    self.fetchReviews()
                }
            }
        }.resume()
    }
    // MARK: - ReviewCard
    struct ReviewCard: View {
        let review: ReviewItem
        let currentUserId: Int
        let currentUsername: String
        let onDelete: () -> Void
        
        // 🌟 แก้ไขจุดนี้: เช็กชื่อแบบ Case-Insensitive (ไม่สนตัวเล็กตัวใหญ่)
        var isMyReview: Bool {
            // 1. ลองเช็กจาก user_id ก่อน (ถ้ามี)
            if let uid = review.user_id, uid != 0 {
                if uid == currentUserId { return true }
            }
            
            // 2. เช็กจากชื่อ (🌟 เปลี่ยน user_name เป็น reviewer_name ให้ตรงกับ JSON)
            let reviewName = review.reviewer_name ?? review.username ?? ""
            if !reviewName.isEmpty && !currentUsername.isEmpty {
                if reviewName.lowercased() == currentUsername.lowercased() {
                    return true
                }
            }
            
            return false
        }
        
        var body: some View {
            VStack(alignment: .leading, spacing: 10) {
                HStack(alignment: .top) {
                    Circle()
                        .fill(Color.green)
                        .frame(width: 45, height: 45)
                        .overlay(
                            Text(review.getDisplayName.prefix(1).uppercased())
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                        )
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(review.getDisplayName)
                            .font(.subheadline)
                            .fontWeight(.bold)
                        
                        Text(formatDateString(review.created_at ?? ""))
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 6) {
                        HStack(spacing: 2) {
                            ForEach(1...5, id: \.self) { index in
                                Image(systemName: "star.fill")
                                    .foregroundColor(index <= (review.rating ?? 0) ? .yellow : .gray.opacity(0.3))
                                    .font(.caption)
                            }
                        }
                        
                        // 🌟 ถ้าเงื่อนไข isMyReview เป็นจริง ปุ่มลบจะแสดงผล
                        if isMyReview {
                            Menu {
                                Button(role: .destructive, action: onDelete) {
                                    Label("Delete Review", systemImage: "trash")
                                }
                            } label: {
                                Image(systemName: "ellipsis")
                                    .foregroundColor(.gray)
                                    .padding(8) // เพิ่มพื้นที่ให้กดง่ายขึ้น
                                    .contentShape(Rectangle())
                            }
                        }
                    }
                }
                
                Text(review.comment ?? "")
                    .font(.body)
                    .foregroundColor(.black)
                    .padding(.top, 5)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(15)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
            )
        }
        
        // ฟังก์ชันจัดการวันที่ (เหมือนเดิม)
        func formatDateString(_ rawDate: String) -> String {
            guard !rawDate.isEmpty else { return "" }
            var clean = rawDate.replacingOccurrences(of: "T", with: " ")
            clean = clean.replacingOccurrences(of: "Z", with: "")
            let formatter = DateFormatter()
            formatter.calendar = Calendar(identifier: .gregorian)
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.timeZone = TimeZone(identifier: "UTC")
            var parsedDate: Date? = nil
            let formats = ["yyyy-MM-dd HH:mm:ss.SSS", "yyyy-MM-dd HH:mm:ss", "yyyy-MM-dd HH:mm"]
            for format in formats {
                formatter.dateFormat = format
                if let date = formatter.date(from: clean) {
                    parsedDate = date
                    break
                }
            }
            if let date = parsedDate {
                let displayFormatter = DateFormatter()
                displayFormatter.calendar = Calendar(identifier: .gregorian)
                displayFormatter.locale = Locale(identifier: "en_US_POSIX")
                displayFormatter.timeZone = TimeZone.current
                displayFormatter.dateFormat = "dd/MM/yyyy - HH:mm"
                return displayFormatter.string(from: date)
            }
            return String(clean.prefix(16))
        }
    }
}
