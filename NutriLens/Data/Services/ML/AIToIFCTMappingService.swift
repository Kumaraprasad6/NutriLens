import Foundation

protocol AIToIFCTMappingProtocol {
    func map(predictions: [FoodRecognitionResult], databaseService: IFCTDatabaseServiceProtocol) async -> [FoodRecognitionResult]
}

final class AIToIFCTMappingService: AIToIFCTMappingProtocol {
    private let keywordMap: [String: String] = [
        "apple": "A001",
        "banana": "A002",
        "orange": "A003",
        "rice": "B001",
        "dal": "C001",
        "roti": "D001",
        "chapati": "D001",
        "idli": "D002",
        "dosa": "D003",
        "chicken": "E001",
        "fish": "E002",
        "bread": "D004",
        "egg": "E003",
        "pasta": "D005",
        "pizza": "D006",
        "curry": "C002",
        "biryani": "B002",
        "noodles": "D007",
        "yogurt": "F001",
        "milk": "F002",
        "cheese": "F003",
        "tomato": "G001",
        "potato": "G002",
        "onion": "G003",
        "carrot": "G004",
        "spinach": "G005",
        "cauliflower": "G006",
        "cabbage": "G007",
        "cucumber": "G008",
        "peas": "G009",
        "beans": "G010",
        "lentils": "C001",
        "chickpeas": "C003",
        "tofu": "C004",
        "paneer": "F004",
        "mango": "A004",
        "grapes": "A005",
        "watermelon": "A006",
        "pineapple": "A007",
        "papaya": "A008",
        "pomegranate": "A009",
        "guava": "A010",
        "strawberry": "A011",
        "coconut": "A012",
        "corn": "G011",
        "mushroom": "G012",
        "garlic": "G013",
        "ginger": "G014",
        "beetroot": "G015",
        "radish": "G016",
        "sweet potato": "G017",
        "yam": "G018",
        "okra": "G019",
        "eggplant": "G020",
        "bitter gourd": "G021",
        "bottle gourd": "G022",
        "green chili": "G023",
        "bell pepper": "G024",
        "lettuce": "G025",
        "pumpkin": "G026",
        "melon": "A006",
        "cake": "H001",
        "cookie": "H002",
        "chocolate": "H003",
        "halwa": "H004",
        "kheer": "H005",
        "gulab jamun": "H006",
        "samosa": "H007",
        "pakora": "H008",
        "naan": "D008",
        "paratha": "D009",
        "poori": "D010",
        "poha": "D011",
        "upma": "D012",
        "vada": "D013",
        "uttapam": "D014",
        "besan": "D015",
        "daliya": "D016",
        "khichdi": "B003",
        "pulao": "B004",
        "rajma": "C005",
        "chole": "C006",
        "sambar": "C007",
        "rasam": "C008",
        "palak paneer": "C009",
        "dal makhani": "C010",
        "butter chicken": "C011",
        "tikka": "C012",
        "tandoori": "C013",
        "kebab": "C014",
        "korma": "C015",
        "saag": "C016",
        "bharta": "C017",
        "raita": "C018",
        "chutney": "C019",
        "pickle": "C020",
        "papad": "C021",
        "salad": "C022",
        "soup": "C023",
        "sandwich": "D017",
        "burger": "D018",
        "tea": "I001",
        "coffee": "I002",
        "lassi": "F005",
        "juice": "I003",
        "smoothie": "I004",
        "almonds": "J001",
        "cashews": "J002",
        "walnuts": "J003",
        "peanuts": "J004",
        "raisins": "J005",
        "dates": "J006",
        "honey": "J007",
        "jaggery": "J008",
        "sugar": "J009",
        "ghee": "F006",
        "butter": "F007",
        "oil": "F008",
        "mustard oil": "F009",
        "coconut oil": "F010",
        "garam masala": "K001",
        "turmeric": "K002",
        "cumin": "K003",
        "coriander": "K004",
        "cardamom": "K005",
        "cinnamon": "K006",
        "clove": "K007",
        "fenugreek": "K008",
        "mint": "K009",
        "basil": "K010",
        "cilantro": "K011"
    ]

    func map(
        predictions: [FoodRecognitionResult],
        databaseService: IFCTDatabaseServiceProtocol
    ) async -> [FoodRecognitionResult] {
        var mapped: [FoodRecognitionResult] = []

        for prediction in predictions {
            let keyword = prediction.foodName.lowercased()
            if let code = keywordMap[keyword] {
                if let food = try? await databaseService.getFoodByCode(code: code) {
                    var result = prediction
                    result.mappedFoodItem = food
                    result.mappedNutrition = food.nutritionForGrams(100)
                    mapped.append(result)
                    continue
                }
            }

            let searchResults = try? await databaseService.searchFoods(query: keyword)
            if let first = searchResults?.first {
                var result = prediction
                result.mappedFoodItem = first
                result.mappedNutrition = first.nutritionForGrams(100)
                mapped.append(result)
                continue
            }

            mapped.append(prediction)
        }

        return mapped
    }
}
