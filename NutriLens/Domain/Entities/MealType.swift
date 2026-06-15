import Foundation

enum MealType: String, Codable, Equatable, CaseIterable {
    case breakfast = "Breakfast"
    case lunch = "Lunch"
    case dinner = "Dinner"
    case snack = "Snack"
    
    var emoji: String {
        switch self {
        case .breakfast:
            return "🍳"
        case .lunch:
            return "🥗"
        case .dinner:
            return "🍽️"
        case .snack:
            return "🍎"
        }
    }
    
    var displayName: String {
        rawValue
    }
    
    static func from(time: Date) -> MealType {
        let hour = Calendar.current.component(.hour, from: time)
        
        switch hour {
        case 5..<11:
            return .breakfast
        case 11..<15:
            return .lunch
        case 15..<21:
            return .dinner
        default:
            return .snack
        }
    }
}
