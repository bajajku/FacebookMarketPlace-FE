import SwiftUI

struct ItemDetailView: View {
    let item: Item
    @State private var selectedImageIndex = 0
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Image carousel
                TabView(selection: $selectedImageIndex) {
                    ForEach(Array(item.images.enumerated()), id: \.element) { index, imageUrl in
                        AsyncImage(url: URL(string: imageUrl)) { phase in
                            switch phase {
                            case .success(let image):
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            case .failure(_):
                                Image(systemName: "photo")
                                    .font(.largeTitle)
                                    .foregroundColor(.gray)
                            case .empty:
                                ProgressView()
                            @unknown default:
                                EmptyView()
                            }
                        }
                    }
                }
                .frame(height: 300)
                .tabViewStyle(PageTabViewStyle())
                
                VStack(alignment: .leading, spacing: 16) {
                    // Title and price
                    Text(item.title)
                        .font(.title2)
                        .bold()
                    
                    Text(item.price.formatted(.currency(code: "USD")))
                        .font(.title)
                        .foregroundColor(.blue)
                        .bold()
                    
                    // Description
                    Text("Description")
                        .font(.headline)
                    Text(item.description)
                        .font(.body)
                        .foregroundColor(.secondary)
                    
                    // Item details
                    VStack(alignment: .leading, spacing: 12) {
                        ItemInfoRow(title: "Category", value: item.category)
                        ItemInfoRow(title: "Condition", value: item.condition)
                        ItemInfoRow(title: "Location", value: item.location)
                        ItemInfoRow(title: "Posted", value: item.datePosted.formatted(date: .abbreviated, time: .shortened))
                    }
                    .padding(.vertical)
                    
                    // Contact button
                    Button(action: {
                        // Add contact action here
                    }) {
                        HStack {
                            Image(systemName: "message")
                            Text("Contact Seller")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                }
                .padding(.horizontal)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ItemInfoRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
        }
    }
} 
