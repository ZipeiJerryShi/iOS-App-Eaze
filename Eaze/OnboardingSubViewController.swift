//
//  OnboardingSubViewController.swift
//  Eaze
//
//  Created by Jerry Shi on 2/26/17.
//  Copyright © 2017 easeapp. All rights reserved.
//

import Foundation
import SnapKit


class OnboardingSubViewController: UIViewController {
    var pageIndex: Int!
    var titleText: String!
    var subTitleText: String!
    var imageView: UIImageView!
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subTitleLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.statusBarStyle = .lightContent
        self.titleLabel.text = self.titleText
        self.subTitleLabel.text = self.subTitleText
        self.view.backgroundColor = UIColor.clear
        self.setupImageViews()
        self.setupLabels()
    }
    
    func setupImageViews() {
        self.view.addSubview(self.imageView)
        imageView.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(self.view.snp.centerX)
            make.top.equalTo(self.view).offset(100)
//            if pageIndex == 0 {
//                make.top.equalTo(self.view).offset(72)
//            }
            if pageIndex == 0 {
                imageView.alpha = 0.66
            }
        }
    }
    
    func setupLabels() {
        self.titleLabel.numberOfLines = 0
        self.subTitleLabel.numberOfLines = 0
        self.titleLabel.textAlignment = .center
        self.subTitleLabel.textAlignment = .center
        
        titleLabel.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(self.view.snp.centerX)
            make.left.greaterThanOrEqualTo(self.view).offset(20)
            make.right.greaterThanOrEqualTo(self.view).offset(-20)
            if pageIndex == 0 {
                make.top.equalTo(imageView.snp.bottom).offset(72)
            } else {
                make.top.equalTo(imageView.snp.bottom).offset(32)
            }
        }
        subTitleLabel.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(self.view.snp.centerX)
            make.left.lessThanOrEqualTo(self.view).offset(20)
            make.right.lessThanOrEqualTo(self.view).offset(-20)
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
        }
    }
    
    
}
