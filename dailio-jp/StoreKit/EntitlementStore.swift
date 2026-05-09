import Foundation
import StoreKit

/// StoreKit 2 の購入状態を監視・公開する @Observable ストア。
/// アプリ起動時に listenForTransactions を開始し、Transaction.updates を購読する。
@Observable
@MainActor
final class EntitlementStore {

    private(set) var isPro: Bool = false
    private(set) var products: [Product] = []
    private(set) var isPurchasing: Bool = false
    private(set) var lastError: String?

    private var updatesTask: Task<Void, Never>?

    init() {
        updatesTask = listenForTransactions()
    }
    // Task は weak self をキャプチャするので deinit でのキャンセルは不要。
    // EntitlementStore は実質シングルトン運用のため、アプリ寿命と一致する。

    // MARK: - Refresh

    /// プロダクト取得 + 現エンタイトルメント反映を一括で行う。
    func refresh() async {
        await loadProducts()
        await refreshEntitlements()
    }

    func loadProducts() async {
        do {
            let fetched = try await Product.products(for: ProductIDs.all)
            products = ProductIDs.displayOrder.compactMap { id in
                fetched.first { $0.id == id }
            }
            lastError = nil
        } catch {
            products = []
            lastError = error.localizedDescription
        }
    }

    func refreshEntitlements() async {
        var pro = false
        for await result in Transaction.currentEntitlements {
            guard case .verified(let transaction) = result else { continue }
            guard ProductIDs.all.contains(transaction.productID) else { continue }
            if transaction.revocationDate == nil {
                pro = true
            }
        }
        isPro = pro
    }

    // MARK: - Purchase

    func purchase(_ product: Product) async {
        guard !isPurchasing else { return }
        isPurchasing = true
        defer { isPurchasing = false }

        do {
            let result = try await product.purchase()
            switch result {
            case .success(let verification):
                if case .verified(let transaction) = verification {
                    await transaction.finish()
                    await refreshEntitlements()
                } else {
                    lastError = String(localized: "購入の検証に失敗しました")
                }
            case .userCancelled, .pending:
                break
            @unknown default:
                break
            }
        } catch {
            lastError = error.localizedDescription
        }
    }

    /// 復元購入。Transaction.updates 経由で同期される他、明示的に AppStore.sync を呼ぶ。
    func restore() async {
        do {
            try await AppStore.sync()
            await refreshEntitlements()
        } catch {
            lastError = error.localizedDescription
        }
    }

    // MARK: - Background updates

    private func listenForTransactions() -> Task<Void, Never> {
        Task.detached { [weak self] in
            for await result in Transaction.updates {
                guard case .verified(let transaction) = result else { continue }
                await transaction.finish()
                await self?.refreshEntitlements()
            }
        }
    }
}
