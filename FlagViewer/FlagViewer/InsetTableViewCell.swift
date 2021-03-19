import UIKit

class InsetTableViewCell: UITableViewCell {
  override func layoutSubviews() {
    super.layoutSubviews()
    
    contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 1, left: 0, bottom: 1, right: 0))
  }
}
