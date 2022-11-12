import UIKit

class ResultViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
//    Кнопка Done на экране результата
    @IBAction func barButtonPressed(_ sender: UIBarButtonItem) {
// Способ 1 - вернуться на корневой ViewController
//        view.window?.rootViewController?.dismiss(animated: true)
// Способ 2 - закрыть все окна, находящиеся внутри Navigation Controller
        navigationController?.dismiss(animated: true)
        
    }
}
