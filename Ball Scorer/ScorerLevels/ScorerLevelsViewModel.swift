import Foundation
import Combine

struct Level: Codable, Identifiable {
    var id: Int
    var isUnlocked: Bool
    
    init(id: Int, isUnlocked: Bool = false) {
        self.id = id
        self.isUnlocked = isUnlocked
    }
}

class ScorerLevelsViewModel: ObservableObject {
    @Published var levels: [Level] = []
    private let levelsKey = "levelsKey"
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        loadLevels()
        observeChanges()
    }
    
    private func loadLevels() {
        if let data = UserDefaults.standard.data(forKey: levelsKey),
           let savedLevels = try? JSONDecoder().decode([Level].self, from: data) {
            levels = savedLevels
        } else {
            // Initialize levels if not present in UserDefaults
            levels = (1...12).map { Level(id: $0, isUnlocked: $0 == 1) } // Assume 20 levels, unlock only the first one initially
        }
    }
    
    private func saveLevels() {
        if let data = try? JSONEncoder().encode(levels) {
            UserDefaults.standard.set(data, forKey: levelsKey)
        }
    }
    
    private func observeChanges() {
        $levels
            .sink { [weak self] _ in
                self?.saveLevels()
            }
            .store(in: &cancellables)
    }
    
    func unlockLevel(id: Int) {
        if let index = levels.firstIndex(where: { $0.id == id }) {
            levels[index].isUnlocked = true
        }
    }
    
    func isLevelUnlocked(id: Int) -> Bool {
        if let level = levels.first(where: { $0.id == id }) {
            return level.isUnlocked
        }
        return false
    }
}
