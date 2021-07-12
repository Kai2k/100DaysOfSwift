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
      self?.add(item: itemText)
    }
    alertController.addAction(submitAction)
    present(alertController, animated: true)
  }
  
  private func add(item: String) {
    if !isValid(item: item) { return }
    items.append(item)
    tableView.reloadData()
  }
  
  private func isValid(item: String) -> {
    item.count > 0
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    items.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath)
    cell.textLabel?.text = items[indexPath.row]
    return cell
  }
}

