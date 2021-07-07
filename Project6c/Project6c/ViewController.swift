import UIKit

class ShoppingListViewController: UITableViewController {
  private var items = [String]()

  override func viewDidLoad() {
    super.viewDidLoad()
  
    title()
    barButton()
  }
  
  private func title() {
    title = "Shopping List"
  }

  private func barButton() {
    navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptToAdd))
  }
  
  @objc private func promptToAdd() {
    let alertController = UIAlertController(title: "Add", message: nil, preferredStyle: .alert)
    alertController.addTextField()
    
    let submitAction = UIAlertAction(title: "Add item", style: .default) { [weak self, weak alertController] _ in
      guard let itemText = alertController?.textFields?[0].text else { return }
    }
    alertController.addAction(submitAction)
    present(alertController, animated: true)
  }
  
  private func add(item: String) {
    items.append(item)
  }
}

