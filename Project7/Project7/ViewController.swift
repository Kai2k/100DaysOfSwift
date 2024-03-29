
import UIKit

class ViewController: UITableViewController {
  
  private var petitions = [Petition]()
  private var filteredPetitions = [Petition]()
  private var filterString: String = ""
  
  override func viewDidLoad() {
    super.viewDidLoad()
    filter()
    credits()
    
    var urlString: String
    
    if navigationController?.tabBarItem.tag == 0 {
      urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
    } else {
      urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
    }
    
    if let url = URL(string: urlString) {
      if let data = try? Data(contentsOf: url) {
        parse(json: data)
        return
      }
    }
    showError()
  }
  
  private func filter() {
    let filter = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(showFilter))
    navigationItem.rightBarButtonItem = filter
  }
  
  @objc private func showFilter() {
    let alertController = UIAlertController(title: "Enter filter term", message: nil, preferredStyle: .alert)
    alertController.addTextField()
    let submitAction = UIAlertAction(title: "OK", style: .default) { [unowned alertController] _ in
      self.filterString = alertController.textFields![0].text!
      self.applyFilter()
    }
    alertController.addAction(submitAction)
    alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
    present(alertController, animated: true)
  }
  
  private func credits() {
    let credits = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(showCredits))
    navigationItem.rightBarButtonItems?.append(credits)
  }
  
  @objc private func showCredits() {
    let alertController = UIAlertController(title: nil, message: "Data courtesy of We The People API of the Whitehouse", preferredStyle: .alert)
    alertController.addAction(UIAlertAction(title: "OK", style: .default))
    present(alertController, animated: true)
  }
  
  private func parse(json: Data) {
    let decoder = JSONDecoder()
    
    if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
      petitions = jsonPetitions.results
      applyFilter()
    }
  }
  
  private func applyFilter() {
    filterString.isEmpty ? unfilterPetitions() : filterPetitions()
  }
  
  private func filterPetitions() {
    filteredPetitions.removeAll()
    let _ = petitions.map({
      if $0.body.contains(self.filterString) ||
          $0.title.contains(self.filterString) {
        filteredPetitions.append($0)
      }
    })
    tableView.reloadData()
  }
  private func unfilterPetitions() {
    let _ = petitions.map({
        filteredPetitions.append($0)
    })
    tableView.reloadData()
  }
  
  private func showError() {
    let ac = UIAlertController(title: "Loading Error", message: "There was an error loading the feed. Please check your connection and try again.", preferredStyle: .alert)
    ac.addAction(UIAlertAction(title: "OK", style: .default))
    present(ac, animated: true)
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    filteredPetitions.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    let petition = filteredPetitions[indexPath.row]
    cell.textLabel?.text = petition.title
    cell.detailTextLabel?.text = petition.body
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let dvc = DetailViewController()
    dvc.detailItem = filteredPetitions[indexPath.row]
    navigationController?.pushViewController(dvc, animated: true)
  }
}

