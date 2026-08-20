import Foundation
import UIKit
import Jinx

struct StorePurchaseHook: HookFunc {
    typealias T = @convention(c) (
        UnsafeMutableRawPointer, // this (StoreController instance)
        UnsafeMutableRawPointer  // product (UnityEngine.Purchasing.Product)
    ) -> Void
    
    let name: String = "PurchaseProduct"
    let image: String? = "Frameworks/UnityFramework.framework/UnityFramework"
    
    var replace: T = { storeControllerSelf, productPtr, orig in
        // Satın al butonuna basıldığı an ekranda bu uyarı çıkacak
        AlertHelper.show(
            title: "Başarılı!", 
            message: "PurchaseProduct tetiklendi ve hook yakalandı!"
        )
        
        // Orijinal fonksiyonu isteğe bağlı olarak çağırabilir veya kapatabilirsin
        // orig(storeControllerSelf, productPtr)
    }
}

// Ekran üstü uyarı yardımcısı
struct AlertHelper {
    static func show(title: String, message: String) {
        DispatchQueue.main.async {
            guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) ?? UIApplication.shared.windows.first,
                  let rootVC = window.rootViewController else {
                return
            }
            
            var topController = rootVC
            while let presented = topController.presentedViewController {
                topController = presented
            }
            
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
            topController.present(alert, animated: true, completion: nil)
        }
    }
}

@objc class StoreIAPBypassManager: NSObject {
    @objc public class func loadTweak() {
        StorePurchaseHook().hook()
        
        // Tweak'in yüklendiğini anlamak için açılışta da alert çıkarabiliriz
        AlertHelper.show(
            title: "Tweak Yüklendi", 
            message: "StoreIAPBypassManager aktif edildi."
        )
    }
}
