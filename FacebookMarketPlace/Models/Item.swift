import Foundation

struct Item: Codable, Identifiable {
    let id: Int
    let title: String
    let description: String
    let price: Decimal
    let category: String
    let condition: String
    let location: String
    let images: [String]
    let datePosted: Date
    let sellerId: String
    
    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case title = "Title"
        case description = "Description"
        case price = "Price"
        case category = "Category"
        case condition = "Condition"
        case location = "Location"
        case images = "Images"
        case datePosted = "DatePosted"
        case sellerId = "SellerId"
    }
} 