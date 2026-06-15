import Foundation

enum FoodSource: String, Codable, Equatable {
    case camera = "camera"
    case manualSearch = "manualSearch"
    case manualEntry = "manualEntry"
    case pinned = "pinned"

    var displayName: String {
        switch self {
        case .camera:
            return "Camera"
        case .manualSearch:
            return "Search"
        case .manualEntry:
            return "Manual Entry"
        case .pinned:
            return "Pinned"
        }
    }

    var icon: String {
        switch self {
        case .camera:
            return "camera.fill"
        case .manualSearch:
            return "magnifyingglass"
        case .manualEntry:
            return "keyboard"
        case .pinned:
            return "pin.fill"
        }
    }
}
