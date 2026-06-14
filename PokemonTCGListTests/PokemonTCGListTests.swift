import Testing
@testable import PokemonTCGList

struct PokemonTCGListTests {
    @Test func pokemonStoresCardData() {
        let pokemon = Pokemon(
            id: 1,
            name: "Pikachu",
            image: "pikachu",
            description: "Electric type Pokemon card",
            origin: "Base Set"
        )

        #expect(pokemon.id == 1)
        #expect(pokemon.name == "Pikachu")
        #expect(pokemon.image == "pikachu")
        #expect(pokemon.description == "Electric type Pokemon card")
        #expect(pokemon.origin == "Base Set")
    }
}
