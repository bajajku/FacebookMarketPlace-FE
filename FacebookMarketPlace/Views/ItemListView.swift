import SwiftUI

struct ItemListView: View {
    @StateObject private var viewModel = ItemsViewModel()
    @State private var searchCategory = ""
    
    var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading {
                    ProgressView()
                } else if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                } else {
                    List(viewModel.items) { item in
                        NavigationLink(destination: ItemDetailView(item: item)) {
                            ItemRowView(item: item)
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
        VStack(alignment: .leading) {
            Text(item.title)
                .font(.headline)
            Text(item.price.formatted(.currency(code: "USD")))
                .font(.subheadline)
            Text(item.location)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
} 