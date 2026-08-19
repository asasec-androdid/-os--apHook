import Jinx
import UIKit

struct Tweak {
    static func ctor() {
        // Temel hook'lar bir kez çalıştırılır
        CanPayHook().hook()
        DelegateHook().hook()
        TransactionHook().hook()
            
            guard !Preferences.isHidden else {
                return
            }
            
            // İlk açılışta menüyü ekle
            showMenu()
            
            // Oyundan çık-gir yapıldığında veya sahneler arası geçişte kaybolmayı önlemek için
            NotificationCenter.default.addObserver(
                forName: UIApplication.didBecomeActiveNotification,
                object: nil,
                queue: .main
            ) { _ in
                showMenu()
            }
        }
    }
    
    @available(iOS 15.0, *)
    private static func showMenu() {
        DispatchQueue.main.async {
            guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) ?? UIApplication.shared.windows.first,
                  let rootVC = window.rootViewController else {
                return
            }
            
            // AsasecController kullanılarak menü ekleniyor
            let controller = AsasecController.shared
            if controller.parent == nil {
                rootVC.add(controller)
            }
        }
    }
}

@_cdecl("jinx_entry")
func jinxEntry() {
    Tweak.ctor()
}
