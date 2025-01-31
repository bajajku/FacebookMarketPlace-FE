import Foundation

@MainActor
class ItemsViewModel: ObservableObject {
    @Published var items: [Item] = []
    @Published var selectedItem: Item?
    @Published var errorMessage: String?
    @Published var isLoading = false
    
    private let apiClient = APIClient()
    
    func loadAllItems() {
        isLoading = true
        
        Task {
            do {
                items = try await apiClient.getAllItems()
                errorMessage = nil
            } catch {
                errorMessage = error.localizedDescription
            }
            isLoading = false
        }
    }
    
    func loadItem(byId id: Int) {
        isLoading = true
        
        Task {
            do {
                selectedItem = try await apiClient.getItem(byId: id)
                errorMessage = nil
            } catch {
                errorMessage = error.localizedDescription
            }
            isLoading = false
        }
    }
    
    func searchItems(byCategory category: String) {
        isLoading = true
        
        Task {
            do {
                items = try await apiClient.searchItems(byCategory: category)
                errorMessage = nil
            } catch {
                errorMessage = error.localizedDescription
            }
            isLoading = false
        }
    }
} 