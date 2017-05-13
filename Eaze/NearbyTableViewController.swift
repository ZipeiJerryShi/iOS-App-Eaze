//
//  NearbyTableViewCell.swift
//  Eaze
//
//  Created by Jerry Shi on 2/23/17.
//  Copyright © 2017 easeapp. All rights reserved.
//

import UIKit

class NearbyTableViewController: UITableViewController {
    
    //MARK: TableView Methods
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        //searchBarCell
        case 0:
            return 1
        //favoriteCell
        case 1:
            return 1
        //nearbyCell
        case 2:
            return 4
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return "Favorites"
        } else if section == 2 {
            return "Nearby Shops"
        } else {
            return ""
        }
    }
    
    //moves the first header upwards
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            // hide the header
            return CGFloat.leastNonzeroMagnitude
        default:
            return 20
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
//        switch indexPath.section {
//        case 1:
//            if indexPath.row == 0 {
//                updateMileageByCell()
//            }
//        case 3:
//            if indexPath.row == 0 {
//                //TODO: Past Appointments
//                self.performSegue(withIdentifier: "showPastAppointment", sender: self)
//                
//            } else if indexPath.row == 1 {
//                self.performSegue(withIdentifier: "showTripHistory", sender: self)
//                
//            } else if indexPath.row == 2 {
//                isTentative = serviceRequestCellTypeIsTentative
//                mixpanelHelper(kButtonTappedEvent, parameters: ["Button": "Open Request Service Calendar", "isTentative": isTentative ? "True":"False"], view: kDashboard)
//                requestService()
//            }
//            
//            
//        default:
//            break;
//        }
    }
    
    
    
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
//
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let nearbyShopCell = tableView.dequeueReusableCell(withIdentifier: "nearbyShopCell", for: indexPath)

        //search bar cell
        let searchBarCell = tableView.dequeueReusableCell(withIdentifier: "searchBarCell", for: indexPath) as! SearchBarTableViewCell
        
        
        
        //favorite Cell
        let favoriteCell = tableView.dequeueReusableCell(withIdentifier: "favoriteCell", for: indexPath) as! FavoriteTableViewCell
        
        var cellType: Int = 0
        if indexPath.section == 0 {
            cellType = 1
            
        } else if indexPath.section == 1 {
            cellType = 2
        } else if indexPath.section == 2 {
        }
        
        if cellType == 1 {
            return searchBarCell
        } else if cellType == 2 {
            return favoriteCell
        } else {
            return nearbyShopCell
        }
    }
    
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        
//        if indexPath.section == 0 {
//            return 84
//        } else if indexPath.section == 1 {
//            return 160
//        } else {
//            return 160
//        }
//    }
}


    
//    var selectedIndexPath: IndexPath?
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 44))
//        self.tableView.tableHeaderView = searchBar
//    }
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        var contentOffset: CGPoint = self.tableView.contentOffset
//        contentOffset.y += (self.tableView.tableHeaderView?.frame)!.height
//        self.tableView.contentOffset = contentOffset
//    }
//    
//    
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//    
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 5
//    }
//    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: nearbyCellId, for: indexPath) as! NearbyTableViewCell
//        
//        cell.titleLabel.text = "test title"
//        
//        return cell
//    }
//    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        
//        let previousIndexPath = selectedIndexPath
//        
//        if indexPath == selectedIndexPath {
//            selectedIndexPath = nil
//        }else{
//            selectedIndexPath = indexPath
//        }
//        
//        tableView.reloadData()
//        
//        var indexPaths: Array<IndexPath> = []
//        
//        if let previous = previousIndexPath {
//            indexPaths = [previous]
//        }
//        
//        if let current = selectedIndexPath {
//            indexPaths = [current]
//        }
//        
//        if indexPaths.count > 0 {
//            tableView.reloadRows(at: indexPaths, with: UITableViewRowAnimation.automatic)
//        }
//    }
//    
//    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        (cell as! NearbyTableViewCell).watchFrameChanges()
//    }
//    
//    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        (cell as! NearbyTableViewCell).ignoreFrameChanges()
//    }
//    
//    
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if indexPath == selectedIndexPath {
//            return NearbyTableViewCell.expandedHeight
//        }else {
//            return NearbyTableViewCell.defaultHeight
//        }
//    }
















