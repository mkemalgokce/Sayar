import Onboarding
import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view, typically from a nib.

        let button = UIButton(type: .roundedRect)
        button.frame = CGRect(x: 20, y: 50, width: 100, height: 30)
        button.setTitle("Test Crash", for: [])
        button.addTarget(self, action: #selector(crashButtonTapped(_:)), for: .touchUpInside)
        view.addSubview(button)
    }

    @IBAction func crashButtonTapped(_ sender: AnyObject) {
        printA()
    }
}
