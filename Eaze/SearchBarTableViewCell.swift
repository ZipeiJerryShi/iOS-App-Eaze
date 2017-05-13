//
//  NearbyTableViewCell.swift
//  Eaze
//
//  Created by Jerry Shi on 2/23/17.
//  Copyright © 2017 easeapp. All rights reserved.
//

import UIKit

class SearchBarTableViewCell: UITableViewCell {
    
    @IBOutlet var shopSearchBar: UISearchBar!
    
    @IBOutlet var currentLocationLabel: UILabel!
    
    @IBOutlet var changeLocationLabel: UIButton!
    
    @IBAction func changeLocationButton(_ sender: Any) {
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    
    
//MARK: old code for the folding cell part
    
//    @IBOutlet var titleLabel: UILabel!
//    
//    @IBOutlet var detailView: UIView!
//    
//    class var expandedHeight: CGFloat { get {return 200} }
//    
//    class var defaultHeight: CGFloat { get {return 44} }
//    
//    func detailViewHeight() {
//        detailView.isHidden = (frame.size.height < NearbyTableViewCell.expandedHeight)
//    }
//    
//    func watchFrameChanges() {
//        addObserver(self, forKeyPath: "frame", options: .new, context: nil)
//        detailViewHeight()
//    }
//    
//    func ignoreFrameChanges() {
//        removeObserver(self, forKeyPath: "frame")
//    }
//    
//    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//        if keyPath == "frame" {
//            detailViewHeight()
//        }
//    }
}
