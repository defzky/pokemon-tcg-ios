import SwiftUI

struct HomeView: View {
    private static let allOrigins = "Semua Pack"

    @AppStorage("favoritePokemonCardIDs") private var favoritePokemonCardIDs = ""
    @Namespace private var cardTransitionNamespace
    @State private var searchText = ""
    @State private var selectedOrigin = allOrigins
    @State private var showFavoritesOnly = false

    let pokemonCards = DataLoader.loadPokemon()

    private var origins: [String] {
        [Self.allOrigins] + Set(pokemonCards.map(\.origin)).sorted()
    }

    private var filteredPokemonCards: [Pokemon] {
        pokemonCards.filter { pokemonCard in
            let matchesSearch = searchText.isEmpty ||
                pokemonCard.name.localizedCaseInsensitiveContains(searchText) ||
                pokemonCard.origin.localizedCaseInsensitiveContains(searchText) ||
                pokemonCard.description.localizedCaseInsensitiveContains(searchText)

            let matchesOrigin = selectedOrigin == Self.allOrigins ||
                pokemonCard.origin == selectedOrigin

            let matchesFavorite = !showFavoritesOnly ||
                isFavorite(pokemonCard)

            return matchesSearch && matchesOrigin && matchesFavorite
        }
    }

    private var favoriteIDs: Set<Int> {
        Set(
            favoritePokemonCardIDs
                .split(separator: ",")
                .compactMap { Int($0) }
        )
    }

    private var hasActiveFilters: Bool {
        !searchText.isEmpty ||
            selectedOrigin != Self.allOrigins ||
            showFavoritesOnly
    }

    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                let horizontalPadding = geometry.size.width <= 375 ? 14.0 : 20.0

                ScrollView {
                    LazyVStack(spacing: 14) {
                        ForEach(filteredPokemonCards) { pokemonCard in
                            NavigationLink {
                                DetailView(pokemonCard: pokemonCard)
                                    .pokemonCardNavigationTransition(
                                        sourceID: pokemonCard.id,
                                        in: cardTransitionNamespace
                                    )
                            } label: {
                                PokemonCardRowView(
                                    pokemonCard: pokemonCard,
                                    isFavorite: isFavorite(pokemonCard),
                                    onFavoriteTapped: {
                                        toggleFavorite(pokemonCard)
                                    }
                                )
                                .pokemonCardTransitionSource(
                                    id: pokemonCard.id,
                                    in: cardTransitionNamespace
                                )
                            }
                            .buttonStyle(.plain)
                            .contextMenu {
                                Button {
                                    toggleFavorite(pokemonCard)
                                } label: {
                                    Label(
                                        isFavorite(pokemonCard) ? "Hapus Favorit" : "Favorit",
                                        systemImage: isFavorite(pokemonCard) ? "star.fill" : "star"
                                    )
                                }

                                ShareLink(item: shareText(for: pokemonCard)) {
                                    Label("Share Pokemon Card", systemImage: "square.and.arrow.up")
                                }
                            }
                        }
                    }
                    .padding(.horizontal, horizontalPadding)
                    .padding(.vertical, 16)
                }
                .background(Color(.systemGroupedBackground))
                .overlay {
                    if filteredPokemonCards.isEmpty {
                        VStack(spacing: 12) {
                            Image(systemName: "magnifyingglass")
                                .font(.largeTitle)
                                .foregroundStyle(.secondary)

                            Text("Pokemon card tidak ditemukan")
                                .font(.headline)

                            Text("Coba kata kunci, pack, atau filter favorit lain.")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.center)
                        }
                        .padding(24)
                        .frame(maxWidth: 320)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color(.secondarySystemGroupedBackground))
                        )
                        .shadow(color: .black.opacity(0.08), radius: 12, x: 0, y: 6)
                    }
                }
            }
            .navigationTitle("Pokemon TCG List")
            .navigationBarTitleDisplayMode(.large)
            .searchable(
                text: $searchText,
                prompt: "Search Pokemon card"
            )
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Button {
                            if hasActiveFilters {
                                showAllPokemonCards()
                            } else {
                                showFavoritesOnly = true
                            }
                        } label: {
                            Label(
                                hasActiveFilters ? "Tampilkan Semua" : "Favorite cards",
                                systemImage: hasActiveFilters ? "list.bullet" : "star"
                            )
                        }

                        Divider()

                        Picker("Filter pack", selection: $selectedOrigin) {
                            ForEach(origins, id: \.self) { origin in
                                Text(origin).tag(origin)
                            }
                        }
                    } label: {
                        Label("Filter pack", systemImage: "line.3.horizontal.decrease.circle")
                    }
                }
            }
        }
    }

    private func isFavorite(_ pokemonCard: Pokemon) -> Bool {
        favoriteIDs.contains(pokemonCard.id)
    }

    private func toggleFavorite(_ pokemonCard: Pokemon) {
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

    private func showAllPokemonCards() {
        searchText = ""
        selectedOrigin = Self.allOrigins
        showFavoritesOnly = false
    }

    private func shareText(for pokemonCard: Pokemon) -> String {
        "\(pokemonCard.name) dari \(pokemonCard.origin). \(pokemonCard.description)"
    }
}

private struct PokemonCardRowView: View {
    private static let pokemonCardAspectRatio = 63.0 / 88.0

    let pokemonCard: Pokemon
    let isFavorite: Bool
    let onFavoriteTapped: () -> Void

    var body: some View {
        HStack(spacing: 14) {
            Image(pokemonCard.image)
                .resizable()
                .scaledToFit()
                .aspectRatio(Self.pokemonCardAspectRatio, contentMode: .fit)
                .frame(width: 72, height: 100)
                .clipShape(RoundedRectangle(cornerRadius: 10))

            VStack(alignment: .leading, spacing: 8) {
                HStack(alignment: .top, spacing: 8) {
                    Text(pokemonCard.name)
                        .font(.headline)
                        .foregroundStyle(.primary)
                        .lineLimit(2)

                    Spacer(minLength: 8)

                    Button(action: onFavoriteTapped) {
                        Image(systemName: isFavorite ? "star.fill" : "star")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(isFavorite ? .yellow : .secondary)
                            .frame(width: 34, height: 34)
                            .background(
                                Circle()
                                    .fill(Color(.tertiarySystemGroupedBackground))
                            )
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel(isFavorite ? "Hapus favorit" : "Favorite Pokemon card")
                }

                Text(pokemonCard.origin)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                Text(pokemonCard.description)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.secondarySystemGroupedBackground))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.primary.opacity(0.05), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.08), radius: 12, x: 0, y: 6)
    }
}

private extension View {
    @ViewBuilder
    func pokemonCardTransitionSource(id: Int, in namespace: Namespace.ID) -> some View {
        if #available(iOS 18.0, *) {
            matchedTransitionSource(id: id, in: namespace) { source in
                source.clipShape(RoundedRectangle(cornerRadius: 20))
            }
        } else {
            self
        }
    }

    @ViewBuilder
    func pokemonCardNavigationTransition(sourceID: Int, in namespace: Namespace.ID) -> some View {
        if #available(iOS 18.0, *) {
            navigationTransition(.zoom(sourceID: sourceID, in: namespace))
        } else {
            self
        }
    }
}
