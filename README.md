# NutriLens

A SwiftUI food tracking app built for Indian cuisine, with offline nutrition lookup via the Indian Food Composition Tables (IFCT 2017).

Built as a personal project to explore Clean Architecture on iOS, SwiftData persistence, and on-device nutrition data.

## Why I Built This

Most calorie tracking apps are built around Western food databases. I wanted something that actually understands Indian portions — roti, katori, idli, dosa — and uses real Indian government nutrition data. The Indian Food Composition Tables from ICMR-NIN contain 542 foods with complete nutrient breakdowns, and it's public domain.

The app is also a playground for architecture patterns I wanted to get right: protocol-based dependency injection, proper separation of concerns, and testable SwiftData layers.

## What It Does

- **Daily Dashboard** — Calorie ring, macro tracking (protein/carbs/fats), and a quick-add food log
- **Food Search** — Offline search through the full IFCT 2017 database with Hindi/Tamil local names
- **Indian Portions** — Custom portion mapping: 1 roti ≈ 30g atta, 1 katori dal ≈ 150g, etc.
- **Photo Capture** — Camera flow to log food (nutrition parsing is currently a sample service)
- **Goals** — Set daily targets for calories and macros

## Tech Stack

- **SwiftUI** + **SwiftData** (iOS 17+)
- **Clean Architecture** — Data / Domain / Presentation layers
- **MVVM** with `@Observable` macro
- **Protocol-based DI** — all repositories and services are injected via protocols for testability
- **XcodeGen** for project generation (project.yml)

## Architecture

The app follows a strict 3-layer architecture:

```
Presentation (Views + ViewModels)
    ↓
Domain (Entities + UseCases + Protocols)
    ↓
Data (Repositories + SwiftData Models + Services)
```

All dependencies are injected via protocols. ViewModels know nothing about SwiftData — they only talk to repositories through `FoodRepositoryProtocol` and `GoalsRepositoryProtocol`.

This made testing straightforward: the test suite uses `MockFoodRepository` and `MockGoalsRepository` to test use cases and view models without touching the database.

## Project Structure

```
NutriLens/
├── App/                 # App entry, root views
├── Core/                # Theme, constants, utilities
├── Data/
│   ├── SwiftData/       # Models (FoodEntryModel, IFCTFoodModel, etc.)
│   ├── Repositories/    # FoodRepository, GoalsRepository
│   └── Services/        # NutritionParsingService, IFCTDatabaseService
├── Domain/
│   ├── Entities/        # FoodItem, NutritionInfo, MealType, Portion
│   ├── UseCases/        # GetDailySummary, LogFood, ManageGoals
│   └── Protocols/       # Repository & service protocols
├── Presentation/        # Views & ViewModels per feature
└── Resources/Data/      # Bundled ifct2017.json
```

## Testing

Unit tests cover:
- Domain entities (FoodItem, NutritionInfo, Portion, MealType)
- Use cases (with mock repositories)
- ViewModels (with mock dependencies)

Run tests with `Cmd+U` in Xcode.

## Current State

This is a work in progress. The foundation is solid:
- Clean architecture ✅
- SwiftData persistence ✅
- IFCT database search ✅
- Dashboard + goals ✅
- Custom UI components ✅

What's next:
- CoreML food recognition (on-device)
- AVFoundation custom camera
- HealthKit integration
- Proper meal history and analysis charts

## Setup

1. Clone the repo
2. Install [XcodeGen](https://github.com/yonaskolb/XcodeGen) if you don't have it:
   ```bash
   brew install xcodegen
   ```
3. Generate the Xcode project:
   ```bash
   xcodegen generate
   ```
4. Open `NutriLens.xcodeproj` and build

## License

MIT

The IFCT 2017 database is public domain (Government of India / ICMR-NIN, Hyderabad).
