import UIKit

class DetailViewController: UIViewController {
  @IBOutlet weak var flag: UIImageView!
  var flagImage: UIImage?
  
  override func viewWillAppear(_ animated: Bool) {
    flag.image = flagImage
  }
}


