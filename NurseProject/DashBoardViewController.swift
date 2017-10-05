import UIKit
import XLPagerTabStrip
import YLProgressBar



class DashBoardViewController: UIViewController, IndicatorInfoProvider {


    @IBOutlet var labelLine: UILabel!
    @IBOutlet var progressHour: YLProgressBar!
    @IBOutlet var progressRatings: YLProgressBar!
    @IBOutlet var progressMatchRate: YLProgressBar!
    @IBOutlet var progressEarnings: YLProgressBar!
    @IBOutlet var segmentControl: UISegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.configureUI()
    }


    func configureUI(){
        UILabel.appearance(whenContainedInInstancesOf: [UISegmentedControl.self]).numberOfLines = 0
        segmentControl.frame = CGRect(x: segmentControl.frame.origin.x, y: segmentControl.frame.origin.y, width: self.segmentControl.frame.size.width, height: 40)
        segmentControl.setTitle("1 Day", forSegmentAt: 0)
        segmentControl.setTitle("1 Week", forSegmentAt: 1)
        segmentControl.setTitle("1 Month", forSegmentAt: 2)
        segmentControl.setTitle("1 Year", forSegmentAt: 3)
        segmentControl.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.white], for: UIControlState.selected)
        segmentControl.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.darkGray], for: UIControlState.normal)
        UILabel.appearance(whenContainedInInstancesOf: [UISegmentedControl.self]).numberOfLines = 0

        self.progressHour.progressTintColors = StaticArrayValues().tintGreenColors as! [Any]
        self.progressRatings.progressTintColors = StaticArrayValues().tintYellowColors as! [Any]
        self.progressMatchRate.progressTintColors = StaticArrayValues().tintBlueColors as! [Any]
        self.progressEarnings.progressTintColors = StaticArrayValues().tintRedColors as! [Any]
        
        labelLine.frame = CGRect(x: labelLine.frame.origin.x, y: labelLine.frame.origin.y, width: labelLine.frame.width, height: 1)

    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "DashBoard")
    }
    
    
}
