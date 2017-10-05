import UIKit

class AcceptedCollectionViewCell: UICollectionViewCell {

    @IBOutlet var labelCost: UILabel!
    @IBOutlet var labelNoOfDays: UILabel!
    @IBOutlet var labelShift: UILabel!
    @IBOutlet var labelLine1: UILabel!
    @IBOutlet var labelLine2: UILabel!
    @IBOutlet var labelAddress: UILabel!
    @IBOutlet var labelOfferTitle: UILabel!
    @IBOutlet var imageViewLady: UIImageView!
    @IBOutlet var labelDays: UILabel!
    @IBOutlet var labelTimer: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        CornerRadius().viewCircular(circleView: imageViewLady)
        labelLine1.frame = CGRect(x: labelLine1.frame.origin.x, y: labelLine1.frame.origin.y, width: labelLine1.frame.width, height: 1)
        labelLine2.frame = CGRect(x: labelLine1.frame.origin.x, y: labelLine1.frame.origin.y, width: labelLine1.frame.width, height: 1)
        
    }

}
