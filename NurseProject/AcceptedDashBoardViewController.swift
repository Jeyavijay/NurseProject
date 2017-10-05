//
//  AcceptedDashBoardViewController.swift
//  NurseProject
//
//  Created by Jeyavijay on 28/09/17.
//  Copyright © 2017 Jeyavijay N. All rights reserved.
//

import UIKit
import XLPagerTabStrip



class AcceptedDashBoardViewController: UIViewController, IndicatorInfoProvider,UICollectionViewDelegate,UICollectionViewDataSource
{

    var collectionViewLayout = LGHorizontalLinearFlowLayout()
    @IBOutlet var collectionViewAccepted: UICollectionView!
    var animationsCount: Int = 0
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.configureCollectionView()
        // Do any additional setup after loading the view.
    }
    
    func configureCollectionView() {
        collectionViewAccepted?.register(UINib(nibName: "AcceptedCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "Accept")
        
        self.collectionViewLayout = LGHorizontalLinearFlowLayout.init(configuredWith: self.collectionViewAccepted, itemSize: CGSize(width: collectionViewAccepted.frame.width-collectionViewAccepted.frame.width/3, height: collectionViewAccepted.frame.width+collectionViewAccepted.frame.width/18), minimumLineSpacing: 0)


        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Accepted")
    }
    
    //MARK:- Collection View Delagates
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return 6
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Accept", for: indexPath as IndexPath) as! AcceptedCollectionViewCell

        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
        if collectionView.isDragging || collectionView.isDecelerating || collectionView.isTracking {
            return
        }
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        animationsCount -= 1
        if animationsCount > 0 {
            return
        }
        collectionViewAccepted?.isUserInteractionEnabled = true
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    }
    
    // MARK: - Convenience
    var pageWidth: CGFloat? {
        return collectionViewLayout.itemSize.width+collectionViewLayout.minimumLineSpacing
    }
    
    var contentOffset: CGFloat {
        return (collectionViewAccepted?.contentOffset.x)!+(collectionViewAccepted?.contentInset.left)!
    }

}
