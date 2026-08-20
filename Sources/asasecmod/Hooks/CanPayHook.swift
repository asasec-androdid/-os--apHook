import Jinx
import StoreKit

struct CanPayHook: Hook {
    typealias T = @convention(c) (AnyObject, Selector) -> Bool

    let cls: AnyClass? = SKPaymentQueue.self
    let sel: Selector = #selector(SKPaymentQueue.canMakePayments)
    let replace: T = { obj, sel in
        // Eğer bedava satın alma kapalıysa orijinal fonksiyonu çalıştır
        if !Preferences.isFreePurchaseEnabled {
            return orig(obj, sel)
        }
        // Açıksa her zaman true döndür
        return true
    }
}
