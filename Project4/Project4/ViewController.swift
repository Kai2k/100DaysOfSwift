import UIKit

class ViewController: UITableViewController {
  private let allowedWebsites = ["apple.com", "bbc.co.uk", "googe.com", "ebay.co.uk"]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Web Browser"
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    allowedWebsites.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "website")!
    
    cell.textLabel?.text = allowedWebsites[indexPath.row]
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let detailViewController = (storyboard?.instantiateViewController(identifier: "DetailViewController")) as? DetailViewController else { return }
    
    detailViewController.allowedWebsites = allowedWebsites
    detailViewController.websiteToLoad = (allowedWebsites[indexPath.row])
    navigationController?.pushViewController(detailViewController, animated: true)
  }
}
