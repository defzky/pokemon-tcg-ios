import Foundation

final class DataLoader {
    static func loadPokemon() -> [Pokemon] {
        guard let url = Bundle.main.url(
            forResource: "pokemon",
            withExtension: "json"
        ) else {
            return []
        }

        do {
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode(
                [Pokemon].self,
                from: data
            )
        } catch {
            print(error)
            return []
        }
    }
}
