
import UIKit

class ViewController: UITableViewController {
  private var flags = [String]()

  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Flags"
    loadFlags()
  }

  private func loadFlags() {
    let fm = FileManager.default
    let path = Bundle.main.resourcePath!
    var items: [String]
    do {
    items = try fm.contentsOfDirectory(atPath: path)
    } catch { return }
    let _ = items.map({ item in
      if item.hasSuffix(".png") {
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
    cell.textLabel?.text = prettyName(forFlag: flags[indexPath.row])
    cell.imageView?.image = image(forFlag: flags[indexPath.row])
    return cell
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return flags.count
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    show(flag: flags[indexPath.row])
  }
  
  private func show(flag: String) {
    guard let detailViewController = storyboard?.instantiateViewController(identifier: "DetailViewController") as? DetailViewController else { return }
    detailViewController.title = prettyName(forFlag: flag)
    detailViewController.flagImage = image(forFlag: flag)
    navigationController?.pushViewController(detailViewController, animated: true)
  }
  
  private func image(forFlag flag: String) -> UIImage? {
    var name: String = Bundle.main.resourcePath!
    name.append("/\(flag)")
    name.append(".png")
    print(name)
    return UIImage(contentsOfFile: name)
  }
  
  private func prettyName(forFlag flag: String) -> String {
    return flag.count > 2 ?  flag.capitalized : flag.uppercased()
  }
}

