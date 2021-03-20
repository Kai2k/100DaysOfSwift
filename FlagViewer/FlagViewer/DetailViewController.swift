import UIKit

class DetailViewController: UIViewController {
  @IBOutlet weak var flag: UIImageView!
  var image: UIImage?
  
  override func viewWillAppear(_ animated: Bool) {
    flag.image = image
    shareButton()
  }
  
  private func shareButton() {
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
  }
  
  @objc private func shareTapped() {
    guard let image = image?.jpegData(compressionQuality: CGFloat(0.8)) else { return }
    let activityViewController = UIActivityViewController(activityItems: [image, title as Any], applicationActivities: [])
    present(activityViewController, animated: true, completion: nil)
  }
}


