import SwiftUI

struct ItemListView: View {
    @StateObject private var viewModel = ItemsViewModel()
    @State private var searchCategory = ""
    
    let availableCategories = ["Electronics", "Footwear"]
    
    var filteredCategories: [String] {
        if searchCategory.isEmpty {
            return []
        }
        return availableCategories.filter { $0.lowercased().contains(searchCategory.lowercased()) }
    }
    
    var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading {
                    ProgressView()
                } else if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                } else {
                    List {
                        // Search suggestions
                        if !searchCategory.isEmpty {
                            ForEach(filteredCategories, id: \.self) { suggestion in
                                Button(action: {
                                    searchCategory = suggestion
                                }) {
                                    Text(suggestion)
                                }
                            }
                        }
                        
                        // Items section
                        ForEach(viewModel.items) { item in
                            NavigationLink(destination: ItemDetailView(item: item)) {
                                ItemRowView(item: item)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Marketplace Items")
            .searchable(text: $searchCategory, prompt: "Search by category")
            .onChange(of: searchCategory) { newValue in
                if !newValue.isEmpty {
                    viewModel.searchItems(byCategory: newValue)
                } else {
                    viewModel.loadAllItems()
                }
            }
        }
        .onAppear {
            viewModel.loadAllItems()
        }
    }
}

struct ItemRowView: View {
    let item: Item
    
    var body: some View {
        HStack(spacing: 12) {
            // Add thumbnail image
            AsyncImage(url: URL(string: item.images.first ?? "")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 80, height: 80)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            } placeholder: {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 80, height: 80)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .font(.headline)
                    .lineLimit(2)
                Text(item.price.formatted(.currency(code: "USD")))
                    .font(.subheadline)
                    .foregroundColor(.blue)
                Text(item.location)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
} 