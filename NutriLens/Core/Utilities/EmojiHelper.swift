import Foundation

enum EmojiHelper {
    static func emoji(for foodName: String) -> String {
        let name = foodName.lowercased()
        
        // Fruits
        if name.contains("apple") { return "🍎" }
        if name.contains("banana") { return "🍌" }
        if name.contains("orange") { return "🍊" }
        if name.contains("grape") { return "🍇" }
        if name.contains("strawberry") { return "🍓" }
        if name.contains("blueberry") { return "🫐" }
        if name.contains("watermelon") { return "🍉" }
        if name.contains("pineapple") { return "🍍" }
        if name.contains("peach") { return "🍑" }
        if name.contains("pear") { return "🍐" }
        if name.contains("cherry") { return "🍒" }
        if name.contains("mango") { return "🥭" }
        if name.contains("kiwi") { return "🥝" }
        if name.contains("lemon") { return "🍋" }
        if name.contains("lime") { return "🍈" }
        if name.contains("coconut") { return "🥥" }
        if name.contains("avocado") { return "🥑" }
        
        // Vegetables
        if name.contains("tomato") { return "🍅" }
        if name.contains("eggplant") { return "🍆" }
        if name.contains("broccoli") { return "🥦" }
        if name.contains("carrot") { return "🥕" }
        if name.contains("corn") { return "🌽" }
        if name.contains("potato") { return "🥔" }
        if name.contains("sweet potato") { return "🍠" }
        if name.contains("cucumber") { return "🥒" }
        if name.contains("leafy") || name.contains("green") || name.contains("spinach") || name.contains("lettuce") { return "🥬" }
        if name.contains("onion") { return "🧅" }
        if name.contains("garlic") { return "🧄" }
        if name.contains("mushroom") { return "🍄" }
        if name.contains("pepper") { return "🫑" }
        if name.contains("chili") || name.contains("hot pepper") { return "🌶️" }
        
        // Proteins
        if name.contains("chicken") { return "🍗" }
        if name.contains("beef") || name.contains("steak") || name.contains("meat") { return "🥩" }
        if name.contains("pork") || name.contains("bacon") || name.contains("ham") { return "🥓" }
        if name.contains("fish") || name.contains("salmon") || name.contains("tuna") { return "🐟" }
        if name.contains("shrimp") || name.contains("prawn") { return "🍤" }
        if name.contains("egg") { return "🥚" }
        if name.contains("tofu") || name.contains("soy") { return "🧈" }
        
        // Dairy
        if name.contains("cheese") { return "🧀" }
        if name.contains("milk") { return "🥛" }
        if name.contains("yogurt") { return "🥣" }
        if name.contains("butter") { return "🧈" }
        if name.contains("ice cream") { return "🍦" }
        
        // Grains & Breads
        if name.contains("bread") || name.contains("toast") { return "🍞" }
        if name.contains("bagel") { return "🥯" }
        if name.contains("croissant") { return "🥐" }
        if name.contains("pretzel") { return "🥨" }
        if name.contains("baguette") { return "🥖" }
        if name.contains("pancake") { return "🥞" }
        if name.contains("waffle") { return "🧇" }
        if name.contains("rice") { return "🍚" }
        if name.contains("pasta") || name.contains("spaghetti") || name.contains("noodle") { return "🍝" }
        if name.contains("burger") || name.contains("hamburger") { return "🍔" }
        if name.contains("sandwich") { return "🥪" }
        if name.contains("taco") { return "🌮" }
        if name.contains("burrito") { return "🌯" }
        if name.contains("pizza") { return "🍕" }
        if name.contains("fries") || name.contains("french fry") { return "🍟" }
        if name.contains("popcorn") { return "🍿" }
        
        // Salads & Bowls
        if name.contains("salad") { return "🥗" }
        if name.contains("soup") { return "🍲" }
        if name.contains("stew") { return "🥘" }
        if name.contains("curry") { return "🍛" }
        if name.contains("sushi") || name.contains("roll") { return "🍣" }
        if name.contains("bowl") || name.contains("poke") { return "🥙" }
        
        // Snacks
        if name.contains("cookie") { return "🍪" }
        if name.contains("donut") || name.contains("doughnut") { return "🍩" }
        if name.contains("cake") { return "🍰" }
        if name.contains("chocolate") { return "🍫" }
        if name.contains("candy") { return "🍬" }
        if name.contains("chips") || name.contains("crisp") { return "🥔" }
        if name.contains("nuts") || name.contains("almond") || name.contains("walnut") { return "🥜" }
        
        // Drinks
        if name.contains("coffee") { return "☕" }
        if name.contains("tea") { return "🍵" }
        if name.contains("juice") { return "🧃" }
        if name.contains("soda") || name.contains("coke") || name.contains("pop") { return "🥤" }
        if name.contains("beer") { return "🍺" }
        if name.contains("wine") { return "🍷" }
        if name.contains("cocktail") { return "🍸" }
        if name.contains("smoothie") || name.contains("shake") { return "🥤" }
        if name.contains("water") { return "💧" }
        
        // Breakfast
        if name.contains("cereal") { return "🥣" }
        if name.contains("oatmeal") || name.contains("oats") { return "🥣" }
        if name.contains("granola") { return "🥣" }
        
        // Default
        return "🍽️"
    }
}