import SwiftUI

struct DetailView: View {
    private static let pokemonCardAspectRatio = 63.0 / 88.0

    @AppStorage("favoritePokemonCardIDs") private var favoritePokemonCardIDs = ""
    @State private var showDetailContent = false

    let pokemonCard: Pokemon

    private var cardTheme: PokemonCardTheme {
        PokemonCardTheme.theme(for: pokemonCard)
    }

    private var isFavorite: Bool {
        favoriteIDs.contains(pokemonCard.id)
    }

    private var favoriteIDs: Set<Int> {
        Set(
            favoritePokemonCardIDs
                .split(separator: ",")
                .compactMap { Int($0) }
        )
    }

    private var shareText: String {
        "\(pokemonCard.name) dari \(pokemonCard.origin). \(pokemonCard.description)"
    }

    var body: some View {
        GeometryReader { geometry in
            let horizontalPadding = geometry.size.width <= 375 ? 14.0 : 20.0

            ZStack {
                LinearGradient(
                    colors: [
                        cardTheme.primary.opacity(0.42),
                        cardTheme.secondary.opacity(0.24),
                        Color(.systemGroupedBackground)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: 18) {
                        Image(pokemonCard.image)
                            .resizable()
                            .scaledToFit()
                            .aspectRatio(Self.pokemonCardAspectRatio, contentMode: .fit)
                            .frame(maxWidth: geometry.size.width <= 375 ? 260 : 340)
                            .frame(maxWidth: .infinity)
                            .clipShape(RoundedRectangle(cornerRadius: 18))
                            .shadow(color: .black.opacity(0.12), radius: 12, x: 0, y: 6)

                        VStack(alignment: .leading, spacing: 12) {
                            HStack(alignment: .top, spacing: 12) {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text(pokemonCard.name)
                                        .font(.largeTitle)
                                        .bold()
                                        .foregroundStyle(.primary)
                                        .lineLimit(2)

                                    Label(pokemonCard.origin, systemImage: "shippingbox")
                                        .font(.headline)
                                        .foregroundStyle(.secondary)
                                }

                                Spacer(minLength: 8)

                                Image(systemName: isFavorite ? "star.fill" : "star")
                                    .font(.title3)
                                    .foregroundStyle(isFavorite ? .yellow : .secondary)
                                    .frame(width: 42, height: 42)
                                    .background(
                                        Circle()
                                            .fill(Color(.tertiarySystemGroupedBackground))
                                    )
                            }

                            Divider()

                            Text(pokemonCard.description)
                                .font(.body)
                                .foregroundStyle(.primary)
                                .lineSpacing(4)
                        }
                        .padding(18)
                        .background(
                            RoundedRectangle(cornerRadius: 22)
                                .fill(Color(.secondarySystemGroupedBackground).opacity(0.94))
                        )
                        .shadow(color: .black.opacity(0.08), radius: 12, x: 0, y: 6)
                        .opacity(showDetailContent ? 1 : 0)
                        .offset(y: showDetailContent ? 0 : 12)
                    }
                    .frame(maxWidth: 620)
                    .padding(.horizontal, horizontalPadding)
                    .padding(.vertical, 16)
                }
                .frame(maxWidth: .infinity)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.45).delay(0.12)) {
                showDetailContent = true
            }
        }
        .onDisappear {
            showDetailContent = false
        }
        .navigationTitle(pokemonCard.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                Button {
                    toggleFavorite()
                } label: {
                    Label(
                        isFavorite ? "Hapus Favorit" : "Favorite card",
                        systemImage: isFavorite ? "star.fill" : "star"
                    )
                }
                .tint(.yellow)

                ShareLink(item: shareText) {
                    Label("Share card", systemImage: "square.and.arrow.up")
                }
            }
        }
    }

    private func toggleFavorite() {
        var ids = favoriteIDs

        if ids.contains(pokemonCard.id) {
            ids.remove(pokemonCard.id)
        } else {
            ids.insert(pokemonCard.id)
        }

        favoritePokemonCardIDs = ids
            .sorted()
            .map(String.init)
            .joined(separator: ",")
    }
}

private struct PokemonCardTheme {
    let primary: Color
    let secondary: Color

    static func theme(for pokemonCard: Pokemon) -> PokemonCardTheme {
        let name = pokemonCard.name.lowercased()

        if name.contains("charizard") {
            return PokemonCardTheme(
                primary: Color(red: 0.92, green: 0.24, blue: 0.16),
                secondary: Color(red: 1.0, green: 0.62, blue: 0.18)
            )
        }

        if name.contains("pikachu") || name.contains("miraidon") {
            return PokemonCardTheme(
                primary: Color(red: 1.0, green: 0.82, blue: 0.16),
                secondary: Color(red: 0.28, green: 0.54, blue: 1.0)
            )
        }

        if name.contains("mew") || name.contains("gardevoir") {
            return PokemonCardTheme(
                primary: Color(red: 0.94, green: 0.36, blue: 0.70),
                secondary: Color(red: 0.50, green: 0.78, blue: 0.70)
            )
        }

        if name.contains("lugia") {
            return PokemonCardTheme(
                primary: Color(red: 0.62, green: 0.76, blue: 0.90),
                secondary: Color(red: 0.88, green: 0.92, blue: 0.96)
            )
        }

        if name.contains("giratina") || name.contains("umbreon") {
            return PokemonCardTheme(
                primary: Color(red: 0.24, green: 0.18, blue: 0.42),
                secondary: Color(red: 0.76, green: 0.62, blue: 0.18)
            )
        }

        if name.contains("rayquaza") {
            return PokemonCardTheme(
                primary: Color(red: 0.10, green: 0.58, blue: 0.38),
                secondary: Color(red: 0.94, green: 0.76, blue: 0.20)
            )
        }

        if name.contains("arceus") {
            return PokemonCardTheme(
                primary: Color(red: 0.90, green: 0.76, blue: 0.36),
                secondary: Color(red: 0.92, green: 0.92, blue: 0.86)
            )
        }

        return PokemonCardTheme(
            primary: Color(red: 0.36, green: 0.52, blue: 0.86),
            secondary: Color(red: 0.70, green: 0.78, blue: 0.90)
        )
    }
}
