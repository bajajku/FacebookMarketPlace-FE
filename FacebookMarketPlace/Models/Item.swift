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
        case id
        case title
        case description
        case price
        case category
        case condition
        case location
        case images
        case datePosted
        case sellerId
    }
} 
