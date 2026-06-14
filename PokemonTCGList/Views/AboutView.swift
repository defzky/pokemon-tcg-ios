import SwiftUI

struct AboutView: View {
    @AppStorage("useDarkMode") private var useDarkMode = false

    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                let horizontalPadding = geometry.size.width <= 375 ? 14.0 : 20.0

                ScrollView {
                    VStack(spacing: 20) {
                        Image("profile")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 160, height: 160)
                            .clipShape(Circle())
                            .overlay(
                                Circle()
                                    .stroke(Color.primary.opacity(0.08), lineWidth: 1)
                            )
                            .shadow(color: .black.opacity(0.12), radius: 14, x: 0, y: 8)

                        VStack(spacing: 8) {
                            Text("Muhammad Fajrizky Diputra")
                                .font(.title2)
                                .bold()
                                .multilineTextAlignment(.center)

                            Text("Software Engineer")
                                .foregroundStyle(.secondary)
                        }

                        Toggle(isOn: $useDarkMode) {
                            Label("Dark mode", systemImage: "moon.fill")
                        }
                        .padding(16)
                        .background(
                            RoundedRectangle(cornerRadius: 18)
                                .fill(Color(.tertiarySystemGroupedBackground))
                        )
                    }
                    .padding(22)
                    .frame(maxWidth: 520)
                    .background(
                        RoundedRectangle(cornerRadius: 24)
                            .fill(Color(.secondarySystemGroupedBackground))
                    )
                    .shadow(color: .black.opacity(0.08), radius: 12, x: 0, y: 6)
                    .padding(.horizontal, horizontalPadding)
                    .padding(.vertical, 16)
                }
                .frame(maxWidth: .infinity)
                .background(Color(.systemGroupedBackground))
            }
            .navigationTitle("About")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}
