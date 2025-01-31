import SwiftUI

struct ItemDetailView: View {
    let item: Item
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                TabView {
                    ForEach(item.images, id: \.self) { imageUrl in
                        AsyncImage(url: URL(string: imageUrl)) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        } placeholder: {
                            ProgressView()
                        }
                    }
                }
                .frame(height: 300)
                .tabViewStyle(PageTabViewStyle())
                
                Group {
                    Text(item.title)
                        .font(.title)
                    
                    Text(item.price.formatted(.currency(code: "USD")))
                        .font(.title2)
                        .foregroundColor(.blue)
                    
                    Text(item.description)
                        .font(.body)
                    
                    ItemInfoRow(title: "Category", value: item.category)
                    ItemInfoRow(title: "Condition", value: item.condition)
                    ItemInfoRow(title: "Location", value: item.location)
                    ItemInfoRow(title: "Posted", value: item.datePosted.formatted(date: .abbreviated, time: .shortened))
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