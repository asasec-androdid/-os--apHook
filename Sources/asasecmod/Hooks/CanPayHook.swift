import Jinx
import StoreKit

struct CanPayHook: Hook {
    typealias T = @convention(c) (AnyObject, Selector) -> Bool

    let cls: AnyClass? = SKPaymentQueue.self
    let sel: Selector = #selector(SKPaymentQueue.canMakePayments)
    let replace: T = { obj, sel in
        if !Preferences.isFreePurchaseEnabled {
            // Hile kapalıyken standart sistem davranışını taklit etmek için false dönebilir 
            // veya orijinal metod yerine doğrudan false verebilirsiniz.
            return false 
        }
        return true
    }
}
