//
//  HomeVC.swift
//  PandaNotes
//
//  Created by Philip Plamenov on 6.08.21.
//

import UIKit
import CoreData
class HomeVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    let rowHeight: CGFloat = 80
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        customizeNavBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tableView.reloadData()
        NotificationCenter.default.addObserver(self, selector: #selector(self.notificationReceived(_:)), name: .refreshNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        NotificationCenter.default.removeObserver(self, name: .refreshNotification, object: nil)
    }
    
    @objc func notificationReceived(_ notification: Notification) {
        tableView.reloadData()
    }
    
}

// MARK: Table view delegate methods
extension HomeVC:  UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "noteCell", for: indexPath) as! NoteCell
        cell.rowIndex = indexPath.row
        cell.setup()
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Global.notes.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if Global.notes[indexPath.row].encrypted == true {
            let alert = UIAlertController(title: "Error", message: "This note is encrypted!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        
        let st = UIStoryboard(name: "Home", bundle: nil)
        let vc = st.instantiateViewController(withIdentifier: "addNoteVC") as! AddNoteVC
        vc.modalTransitionStyle = .coverVertical
        vc.modalPresentationStyle = .formSheet
        vc.noteIndex = indexPath.row
        present(vc, animated: true, completion: nil)
    }
}
