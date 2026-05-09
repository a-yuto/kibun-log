import SwiftUI

/// 広告スロット。Pro なら描画しない。AdMob SDK は将来 Phase で別途統合する予定。
/// 現時点ではレイアウトの場所を確保するための薄いプレースホルダー。
struct BannerSlot: View {
    @Environment(EntitlementStore.self) private var entitlementStore

    var body: some View {
        if entitlementStore.isPro {
            EmptyView()
        } else {
            Text("広告")
                .font(.caption2)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color.gray.opacity(0.12))
                )
                .accessibilityHidden(true)
        }
    }
}

#Preview {
    BannerSlot()
        .environment(EntitlementStore())
        .padding()
}
