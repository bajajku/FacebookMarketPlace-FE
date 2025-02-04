import Foundation

enum APIError: Error {
    case invalidURL
    case invalidResponse
    case networkError(Error)
    case decodingError(Error)
}

class APIClient {
    private let baseURL = "https://verbose-space-sniffle-r9xj76jx66v3p9gv-5173.app.github.dev/api/Marketplace"    
    
    private lazy var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        decoder.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)
            
            if let date = formatter.date(from: dateString) {
                return date
            }
            
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Cannot decode date string \(dateString)"
            )
        }
        return decoder
    }()
    
    func getAllItems() async throws -> [Item] {
        guard let url = URL(string: baseURL) else {
            print("Debug: Invalid URL - \(baseURL)")
            throw APIError.invalidURL
        }
        
        do {
            print("Debug: Fetching from URL - \(url)")
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Debug: Invalid response type")
                throw APIError.invalidResponse
            }
            
            print("Debug: Response status code - \(httpResponse.statusCode)")
            
            guard (200...299).contains(httpResponse.statusCode) else {
                print("Debug: Error response - \(httpResponse.statusCode)")
                if let responseString = String(data: data, encoding: .utf8) {
                    print("Debug: Response body - \(responseString)")
                }
                throw APIError.invalidResponse
            }
            
            do {
                let items = try decoder.decode([Item].self, from: data)
                print("Debug: Successfully decoded \(items.count) items")
                return items
            } catch {
                print("Debug: Decoding error - \(error)")
                if let responseString = String(data: data, encoding: .utf8) {
                    print("Debug: Raw JSON - \(responseString)")
                }
                throw APIError.decodingError(error)
            }
        } catch {
            print("Debug: Network error - \(error)")
            throw APIError.networkError(error)
        }
    }
    
    func getItem(byId id: Int) async throws -> Item {
        guard let url = URL(string: "\(baseURL)/\(id)") else {
            throw APIError.invalidURL
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                throw APIError.invalidResponse
            }
            
            return try decoder.decode(Item.self, from: data)
        } catch let error as DecodingError {
            throw APIError.decodingError(error)
        } catch {
            throw APIError.networkError(error)
        }
    }
    
    func searchByCategory(byCategory category: String) async throws -> [Item] {
        guard let url = URL(string: "\(baseURL)/category/\(category)") else {
            throw APIError.invalidURL
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                throw APIError.invalidResponse
            }
            
            return try decoder.decode([Item].self, from: data)
        } catch let error as DecodingError {
            throw APIError.decodingError(error)
        } catch {
            throw APIError.networkError(error)
        }
    }
} 
