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
    let rowHeight: CGFloat = 80
    let defaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.title = "Menu"
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
    
    private func hideEncryptedItems() {
        defaults.set(true, forKey: "hideEncryptedItems")
        NotificationCenter.default.post(name: .refreshNotification, object: nil)
    }
    
    private func showEncryptedItems() {
        defaults.set(false, forKey: "hideEncryptedItems")
        NotificationCenter.default.post(name: .refreshNotification, object: nil)
    }
    
}

// MARK: Table view delegate methods
extension MenuVC:  UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath) as! MenuCell
        cell.rowIndex = indexPath.row
        cell.setup()
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Global.menuItems.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0:
            hideEncryptedItems()
        case 1:
            showEncryptedItems()
        default:
            return
        }
    }
}
