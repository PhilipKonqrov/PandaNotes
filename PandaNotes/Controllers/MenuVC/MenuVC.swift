//
//  MenuVC.swift
//  PandaNotes
//
//  Created by Philip Plamenov on 6.08.21.
//

import UIKit
import CoreData
class MenuVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeNavBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        NotificationCenter.default.addObserver(self, selector: #selector(self.notificationReceived(_:)), name: .refreshNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        NotificationCenter.default.removeObserver(self, name: .refreshNotification, object: nil)
    }
    
    @objc func notificationReceived(_ notification: Notification) {
//        tableView.reloadData()
    }
    
    
}


