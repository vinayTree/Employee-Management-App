//
//  UiViewExtension.swift
//  Collabera Team
//
//  Created by vinay kumar bg on 30/10/22.
//

import Foundation
import UIKit

extension UIView {
    
    func tableViewCell() -> UITableViewCell? {
        
        var tableViewcell : UIView? = self
        
        while(tableViewcell != nil) {
            
            if tableViewcell! is UITableViewCell {
                break
            }
            tableViewcell = tableViewcell!.superview
        }
        return tableViewcell as? UITableViewCell
    }
    
    
    func tableViewIndexPath(tableView: UITableView) -> NSIndexPath? {
        
        if let cell = self.tableViewCell() {
            return tableView.indexPath(for: cell) as NSIndexPath?
        }
        return nil
    }
}
