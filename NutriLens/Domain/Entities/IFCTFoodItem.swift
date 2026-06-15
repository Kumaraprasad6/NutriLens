import Foundation

struct IFCTFoodItem: Identifiable, Equatable, Codable {
    let id: UUID
    let code: String
    let name: String
    let scientificName: String
    let localNames: String
    let group: String
    let region: String
    let tags: String
    let energy: Double
    let water: Double
    let protein: Double
    let fat: Double
    let carbs: Double
    let fiber: Double
    let sugar: Double
    let sodium: Double
    let iron: Double
    let calcium: Double
    let vitaminC: Double
    let vitaminA: Double
    let vitaminB1: Double
    let vitaminB2: Double
    let niacin: Double
    let folate: Double
    let potassium: Double
    let magnesium: Double
    let phosphorus: Double
    let zinc: Double
    let saturatedFat: Double
    let monounsaturatedFat: Double
    let polyunsaturatedFat: Double
    let cholesterol: Double
    let ash: Double

    init(
        id: UUID = UUID(),
        code: String,
        name: String,
        scientificName: String = "",
        localNames: String = "",
        group: String,
        region: String = "",
        tags: String = "",
        energy: Double = 0,
        water: Double = 0,
        protein: Double = 0,
        fat: Double = 0,
        carbs: Double = 0,
        fiber: Double = 0,
        sugar: Double = 0,
        sodium: Double = 0,
        iron: Double = 0,
        calcium: Double = 0,
        vitaminC: Double = 0,
        vitaminA: Double = 0,
        vitaminB1: Double = 0,
        vitaminB2: Double = 0,
        niacin: Double = 0,
        folate: Double = 0,
        potassium: Double = 0,
        magnesium: Double = 0,
        phosphorus: Double = 0,
        zinc: Double = 0,
        saturatedFat: Double = 0,
        monounsaturatedFat: Double = 0,
        polyunsaturatedFat: Double = 0,
        cholesterol: Double = 0,
        ash: Double = 0
    ) {
        self.id = id
        self.code = code
        self.name = name
        self.scientificName = scientificName
        self.localNames = localNames
        self.group = group
        self.region = region
        self.tags = tags
        self.energy = energy
        self.water = water
        self.protein = protein
        self.fat = fat
        self.carbs = carbs
        self.fiber = fiber
        self.sugar = sugar
        self.sodium = sodium
        self.iron = iron
        self.calcium = calcium
        self.vitaminC = vitaminC
        self.vitaminA = vitaminA
        self.vitaminB1 = vitaminB1
        self.vitaminB2 = vitaminB2
        self.niacin = niacin
        self.folate = folate
        self.potassium = potassium
        self.magnesium = magnesium
        self.phosphorus = phosphorus
        self.zinc = zinc
        self.saturatedFat = saturatedFat
        self.monounsaturatedFat = monounsaturatedFat
        self.polyunsaturatedFat = polyunsaturatedFat
        self.cholesterol = cholesterol
        self.ash = ash
    }

    enum CodingKeys: String, CodingKey {
        case code, name, scientificName, localNames, group, region, tags
        case energy, water, protein, fat, carbs, fiber, sugar, sodium
        case iron, calcium, vitaminC, vitaminA, vitaminB1, vitaminB2, niacin, folate
        case potassium, magnesium, phosphorus, zinc
        case saturatedFat, monounsaturatedFat, polyunsaturatedFat, cholesterol, ash
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = UUID()
        self.code = try container.decode(String.self, forKey: .code)
        self.name = try container.decode(String.self, forKey: .name)
        self.scientificName = try container.decodeIfPresent(String.self, forKey: .scientificName) ?? ""
        self.localNames = try container.decodeIfPresent(String.self, forKey: .localNames) ?? ""
        self.group = try container.decode(String.self, forKey: .group)
        self.region = try container.decodeIfPresent(String.self, forKey: .region) ?? ""
        self.tags = try container.decodeIfPresent(String.self, forKey: .tags) ?? ""
        self.energy = try container.decodeIfPresent(Double.self, forKey: .energy) ?? 0
        self.water = try container.decodeIfPresent(Double.self, forKey: .water) ?? 0
        self.protein = try container.decodeIfPresent(Double.self, forKey: .protein) ?? 0
        self.fat = try container.decodeIfPresent(Double.self, forKey: .fat) ?? 0
        self.carbs = try container.decodeIfPresent(Double.self, forKey: .carbs) ?? 0
        self.fiber = try container.decodeIfPresent(Double.self, forKey: .fiber) ?? 0
        self.sugar = try container.decodeIfPresent(Double.self, forKey: .sugar) ?? 0
        self.sodium = try container.decodeIfPresent(Double.self, forKey: .sodium) ?? 0
        self.iron = try container.decodeIfPresent(Double.self, forKey: .iron) ?? 0
        self.calcium = try container.decodeIfPresent(Double.self, forKey: .calcium) ?? 0
        self.vitaminC = try container.decodeIfPresent(Double.self, forKey: .vitaminC) ?? 0
        self.vitaminA = try container.decodeIfPresent(Double.self, forKey: .vitaminA) ?? 0
        self.vitaminB1 = try container.decodeIfPresent(Double.self, forKey: .vitaminB1) ?? 0
        self.vitaminB2 = try container.decodeIfPresent(Double.self, forKey: .vitaminB2) ?? 0
        self.niacin = try container.decodeIfPresent(Double.self, forKey: .niacin) ?? 0
        self.folate = try container.decodeIfPresent(Double.self, forKey: .folate) ?? 0
        self.potassium = try container.decodeIfPresent(Double.self, forKey: .potassium) ?? 0
        self.magnesium = try container.decodeIfPresent(Double.self, forKey: .magnesium) ?? 0
        self.phosphorus = try container.decodeIfPresent(Double.self, forKey: .phosphorus) ?? 0
        self.zinc = try container.decodeIfPresent(Double.self, forKey: .zinc) ?? 0
        self.saturatedFat = try container.decodeIfPresent(Double.self, forKey: .saturatedFat) ?? 0
        self.monounsaturatedFat = try container.decodeIfPresent(Double.self, forKey: .monounsaturatedFat) ?? 0
        self.polyunsaturatedFat = try container.decodeIfPresent(Double.self, forKey: .polyunsaturatedFat) ?? 0
        self.cholesterol = try container.decodeIfPresent(Double.self, forKey: .cholesterol) ?? 0
        self.ash = try container.decodeIfPresent(Double.self, forKey: .ash) ?? 0
    }

    var displayName: String {
        name
    }

    var localNameDisplay: String {
        guard !localNames.isEmpty else { return "" }
        let names = localNames.split(separator: ";").map { $0.trimmingCharacters(in: .whitespaces) }
        return names.first ?? ""
    }

    func nutritionPerPortion(_ portion: IndianPortion) -> NutritionInfo {
        let scale = portion.weightInGrams / 100.0
        return NutritionInfo(
            calories: energy * scale,
            protein: protein * scale,
            carbs: carbs * scale,
            fats: fat * scale,
            fiber: fiber * scale,
            sugar: sugar * scale,
            sodium: sodium * scale,
            perServing: true,
            basePortion: .grams(100)
        )
    }

    func nutritionForGrams(_ grams: Double) -> NutritionInfo {
        let scale = grams / 100.0
        return NutritionInfo(
            calories: energy * scale,
            protein: protein * scale,
            carbs: carbs * scale,
            fats: fat * scale,
            fiber: fiber * scale,
            sugar: sugar * scale,
            sodium: sodium * scale,
            perServing: true,
            basePortion: .grams(100)
        )
    }
}
