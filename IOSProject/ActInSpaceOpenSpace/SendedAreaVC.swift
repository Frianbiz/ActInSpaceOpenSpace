import UIKit
import M13Checkbox

class SendedAreaVC: UIViewController {
    @IBOutlet var check: M13Checkbox!
    
    @IBOutlet var continueButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.check.stateChangeAnimation = .spiral
        self.check.animationDuration = 1
        self.continueButton.alpha = 0
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.check.setCheckState(.checked, animated: true)
            UIView.animate(withDuration: 1.3, animations: {
                self.continueButton.alpha = 1
            })
        }
    }
    
    @IBAction func continueButtonHandler(_ sender: Any) {
        self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
    }
}
