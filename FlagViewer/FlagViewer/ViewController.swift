
import UIKit

class ViewController: UITableViewController {
  private var flags = [String]()

  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Flags"
    load()
  }

  private func load() {
    let fm = FileManager.default
    let path = Bundle.main.resourcePath!
    var items: [String]
    do {
    items = try fm.contentsOfDirectory(atPath: path)
    } catch { return }
    let _ = items.map({ item in
      if item.isValid() {
        flags.append(self.removeSuffixFrom(item))
      }
    })
  }
  
  private func removeSuffixFrom(_ item: String) -> String {
    guard let separator = item.firstIndex(of: ".") else { return item }
    return String(item[..<separator])
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "flag", for: indexPath)
    cell.textLabel?.text = prettyName(for: flags[indexPath.row])
    cell.imageView?.image = image(for: flags[indexPath.row])
    return cell
  }
  
  private func prettyName(for flag: String) -> String {
    flag.count > 2 ? flag.capitalized : flag.uppercased()
  }
  
  private func image(for flag: String) -> UIImage? {
    var name: String = Bundle.main.resourcePath!
    name.append("/\(flag)")
    name.append(".png")
    return UIImage(contentsOfFile: name)
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    flags.count
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    show(flags[indexPath.row])
  }
  
  private func show(_ flag: String) {
    guard let detailViewController = storyboard?.instantiateViewController(identifier: "DetailViewController") as? DetailViewController else { return }
    detailViewController.title = prettyName(for: flag)
    detailViewController.image = image(for: flag)
    navigationController?.pushViewController(detailViewController, animated: true)
  }
}

fileprivate extension String {
  func isValid() -> Bool {
    self.hasSuffix(".png") &&
      !self.contains("@")
  }
}

