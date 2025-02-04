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
        errorMessage = nil
        
        Task {
            do {
                items = try await apiClient.getAllItems()
            } catch APIError.invalidURL {
                errorMessage = "Invalid URL configuration"
            } catch APIError.invalidResponse {
                errorMessage = "Server returned an invalid response"
            } catch APIError.decodingError(let error) {
                errorMessage = "Failed to decode response: \(error.localizedDescription)"
            } catch APIError.networkError(let error) {
                errorMessage = "Network error: \(error.localizedDescription)"
            } catch {
                errorMessage = "Unexpected error: \(error.localizedDescription)"
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
                items = try await apiClient.searchByCategory(byCategory: category)
                errorMessage = nil
            } catch {
                errorMessage = error.localizedDescription
            }
            isLoading = false
        }
    }
} 
