import SwiftUI
import StoreKit

/// Pro へのアップグレード画面。月額 / 年額 / Lifetime の 3 プランと復元購入を提供。
struct PurchaseView: View {
    @Environment(EntitlementStore.self) private var entitlementStore
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    header
                    benefitList

                    if entitlementStore.isPro {
                        Label("Pro 加入中です", systemImage: "checkmark.seal.fill")
                            .font(.headline)
                            .foregroundStyle(.green)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.green.opacity(0.1))
                            )
                    } else {
                        plans
                        restoreButton
                    }

                    if let error = entitlementStore.lastError {
                        Text(error)
                            .font(.footnote)
                            .foregroundStyle(.red)
                    }
                }
                .padding()
            }
            .navigationTitle("Pro にアップグレード")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("閉じる") { dismiss() }
                }
            }
            .task {
                await entitlementStore.refresh()
            }
        }
    }

    // MARK: - Sections

    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Pro でできること")
                .font(.title2.bold())
            Text("広告なし、移動平均期間カスタム、PDF エクスポートなどの追加機能")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }

    private var benefitList: some View {
        VStack(alignment: .leading, spacing: 12) {
            benefit(icon: "rectangle.slash.fill", text: "記録画面の広告を非表示")
            benefit(icon: "chart.line.uptrend.xyaxis", text: "移動平均の期間をカスタマイズ")
            benefit(icon: "doc.richtext", text: "PDF レポートエクスポート")
            benefit(icon: "paintbrush", text: "テーマカスタマイズ")
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.secondarySystemBackground))
        )
    }

    private func benefit(icon: String, text: LocalizedStringResource) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .frame(width: 24)
                .foregroundStyle(.tint)
            Text(text)
                .font(.subheadline)
            Spacer()
        }
    }

    private var plans: some View {
        VStack(spacing: 12) {
            ForEach(entitlementStore.products, id: \.id) { product in
                PlanCard(product: product) {
                    Task { await entitlementStore.purchase(product) }
                }
            }
            if entitlementStore.products.isEmpty {
                ProgressView()
                    .frame(maxWidth: .infinity)
                    .padding()
            }
        }
        .disabled(entitlementStore.isPurchasing)
        .opacity(entitlementStore.isPurchasing ? 0.6 : 1.0)
    }

    private var restoreButton: some View {
        Button {
            Task { await entitlementStore.restore() }
        } label: {
            Text("購入を復元")
                .font(.subheadline)
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.bordered)
        .disabled(entitlementStore.isPurchasing)
    }
}

// MARK: - Plan Card

private struct PlanCard: View {
    let product: Product
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(product.displayName)
                        .font(.headline)
                    Text(product.description)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Text(product.displayPrice)
                    .font(.title3.monospacedDigit())
                    .fontWeight(.semibold)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.accentColor.opacity(0.1))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(Color.accentColor, lineWidth: 1.5)
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    PurchaseView()
        .environment(EntitlementStore())
}
