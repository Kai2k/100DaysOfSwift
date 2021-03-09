
import UIKit
import LinkPresentation

class ViewController: UITableViewController {
  private var pictures = [String]()
  private var metadata: LPLinkMetadata?

  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Storm Viewer"
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
    navigationController?.navigationBar.prefersLargeTitles = true
    let fm = FileManager.default
    let path = Bundle.main.resourcePath!
    let items = try! fm.contentsOfDirectory(atPath: path)
    
    for item in items {
      if item.hasPrefix("nssl") {
        pictures.append(item)
      }
    }
    pictures.sort()
    print(pictures)
  }
  
  @objc private func shareTapped() {
    let vc = UIActivityViewController(activityItems: [self], applicationActivities: [])
    vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
    present(vc, animated: true)
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return pictures.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
    cell.textLabel?.text = pictures[indexPath.row]
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let vc = storyboard?.instantiateViewController(identifier: "Detail") as? DetailViewController {
      vc.selectedImage = pictures[indexPath.row]
      vc.title = title(forRow: indexPath.row)
      navigationController?.pushViewController(vc, animated: true)
    }
  }
  
  private func title(forRow row: Int) -> String {
    return "Picture \(row + 1) of \(pictures.count)"
  }
}

extension ViewController: UIActivityItemSource {

  func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
    return metadata
  }
  
  func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
    return metadata
  }
  
  func activityViewControllerLinkMetadata(_: UIActivityViewController) -> LPLinkMetadata? {
    let metadata = LPLinkMetadata()
    let image = #imageLiteral(resourceName: "nssl0049.jpg")
    metadata.title = "Storm Viewer"
    metadata.originalURL = URL(string: "https://www.hackingwithswift.com/read/3/3/wrap-up")
    metadata.url = metadata.originalURL
    metadata.iconProvider = NSItemProvider(object: image)
    metadata.imageProvider = NSItemProvider.init(contentsOf:
                                                  Bundle.main.url(forResource: "nssl0049", withExtension: "JPG"))
    return metadata
  }
}

