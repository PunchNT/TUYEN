import SwiftUI

struct AddPopupView: View {
    
    var title: String
    var onAdd: (String) -> Void
    var onCancel: () -> Void
    
    @State private var text = ""
    
    var body: some View {
        
        ZStack {
            
            
            Color.black.opacity(0.35)
                .ignoresSafeArea()
                .onTapGesture {
                    onCancel()
                }
            
            VStack(spacing: 15) {
                
                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)
                
                TextField("Enter here", text: $text)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.green)
                    )
                    .padding(.horizontal)
                
                
                HStack(spacing: 10) {
                    
                    Button {
                        if !text.isEmpty {
                            onAdd(text)
                        }
                    } label: {
                        Text("OK")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    
                    Button {
                        onCancel()
                    } label: {
                        Text("Cancel")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
                .padding(.horizontal)
            }
            .padding()
            .frame(width: 300)
            .background(Color.white)
            .cornerRadius(15)
        }
    }
}
