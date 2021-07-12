import UIKit

class ShoppingListViewController: UITableViewController {
  private var items = [String]()

  override func viewDidLoad() {
    super.viewDidLoad()
  
    title()
    addButton()
    clearAndShareButtons()
  }
  
  private func title() {
    title = "Shopping List"
  }

  private func addButton() {
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
  
  private func clearAndShareButtons() {
    navigationItem.rightBarButtonItems = [clearButton(), shareButton()]
  }
  
  private func clearButton() -> UIBarButtonItem {
    UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(clear))
  }
  
  @objc func clear() {
    items.removeAll()
    tableView.reloadData()
  }
  
  private func shareButton() -> UIBarButtonItem {
    UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(share))
  }
  
  @objc private func share() {
    let activityController = UIActivityViewController(activityItems: [prettyList()], applicationActivities: nil)
    present(activityController, animated: true)
  }
  
  private func prettyList() -> String {
    items.joined(separator: ",")
  }
  
  private func add(item: String) {
    if !isValid(item: item) { return }
    items.append(item)
    tableView.insertRows(at: [IndexPath(row: items.count - 1, section: 0)], with: .automatic)
  }
  
  private func isValid(item: String) -> Bool {
    item.count >= 0
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

