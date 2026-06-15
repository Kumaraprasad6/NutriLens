import Foundation
import SwiftData

@Model
final class IFCTFoodModel {
    @Attribute(.unique) var code: String
    var name: String
    var scientificName: String
    var localNames: String
    var group: String
    var region: String
    var tags: String
    var energy: Double
    var water: Double
    var protein: Double
    var fat: Double
    var carbs: Double
    var fiber: Double
    var sugar: Double
    var sodium: Double
    var iron: Double
    var calcium: Double
    var vitaminC: Double
    var vitaminA: Double
    var vitaminB1: Double
    var vitaminB2: Double
    var niacin: Double
    var folate: Double
    var potassium: Double
    var magnesium: Double
    var phosphorus: Double
    var zinc: Double
    var saturatedFat: Double
    var monounsaturatedFat: Double
    var polyunsaturatedFat: Double
    var cholesterol: Double
    var ash: Double

    init(
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
}

extension IFCTFoodModel {
    static func from(entity: IFCTFoodItem) -> IFCTFoodModel {
        IFCTFoodModel(
            code: entity.code,
            name: entity.name,
            scientificName: entity.scientificName,
            localNames: entity.localNames,
            group: entity.group,
            region: entity.region,
            tags: entity.tags,
            energy: entity.energy,
            water: entity.water,
            protein: entity.protein,
            fat: entity.fat,
            carbs: entity.carbs,
            fiber: entity.fiber,
            sugar: entity.sugar,
            sodium: entity.sodium,
            iron: entity.iron,
            calcium: entity.calcium,
            vitaminC: entity.vitaminC,
            vitaminA: entity.vitaminA,
            vitaminB1: entity.vitaminB1,
            vitaminB2: entity.vitaminB2,
            niacin: entity.niacin,
            folate: entity.folate,
            potassium: entity.potassium,
            magnesium: entity.magnesium,
            phosphorus: entity.phosphorus,
            zinc: entity.zinc,
            saturatedFat: entity.saturatedFat,
            monounsaturatedFat: entity.monounsaturatedFat,
            polyunsaturatedFat: entity.polyunsaturatedFat,
            cholesterol: entity.cholesterol,
            ash: entity.ash
        )
    }

    func toEntity() -> IFCTFoodItem {
        IFCTFoodItem(
            code: code,
            name: name,
            scientificName: scientificName,
            localNames: localNames,
            group: group,
            region: region,
            tags: tags,
            energy: energy,
            water: water,
            protein: protein,
            fat: fat,
            carbs: carbs,
            fiber: fiber,
            sugar: sugar,
            sodium: sodium,
            iron: iron,
            calcium: calcium,
            vitaminC: vitaminC,
            vitaminA: vitaminA,
            vitaminB1: vitaminB1,
            vitaminB2: vitaminB2,
            niacin: niacin,
            folate: folate,
            potassium: potassium,
            magnesium: magnesium,
            phosphorus: phosphorus,
            zinc: zinc,
            saturatedFat: saturatedFat,
            monounsaturatedFat: monounsaturatedFat,
            polyunsaturatedFat: polyunsaturatedFat,
            cholesterol: cholesterol,
            ash: ash
        )
    }
}
