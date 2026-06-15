import Foundation

struct Portion: Codable, Equatable {
    var amount: Double
    var unit: String
    var description: String
    
    init(
        amount: Double = 1.0,
        unit: String = "serving",
        description: String = "1 serving"
    ) {
        self.amount = amount
        self.unit = unit
        self.description = description
    }
    
    static let `default` = Portion()
    
    static func grams(_ amount: Double) -> Portion {
        Portion(amount: amount, unit: "g", description: "\(Int(amount))g")
    }
    
    static func cups(_ amount: Double) -> Portion {
        let desc = amount == 1.0 ? "1 cup" : "\(amount) cups"
        return Portion(amount: amount, unit: "cup", description: desc)
    }
    
    static func pieces(_ amount: Double) -> Portion {
        let desc = amount == 1.0 ? "1 piece" : "\(Int(amount)) pieces"
        return Portion(amount: amount, unit: "piece", description: desc)
    }
    
    static func ounces(_ amount: Double) -> Portion {
        Portion(amount: amount, unit: "oz", description: "\(amount)oz")
    }
    
    static func tablespoons(_ amount: Double) -> Portion {
        let desc = amount == 1.0 ? "1 tbsp" : "\(Int(amount)) tbsp"
        return Portion(amount: amount, unit: "tbsp", description: desc)
    }
    
    static func teaspoons(_ amount: Double) -> Portion {
        let desc = amount == 1.0 ? "1 tsp" : "\(Int(amount)) tsp"
        return Portion(amount: amount, unit: "tsp", description: desc)
    }
    
    func scaled(by factor: Double) -> Portion {
        Portion(
            amount: amount * factor,
            unit: unit,
            description: "\(String(format: "%.1f", amount * factor)) \(unit)"
        )
    }
}
