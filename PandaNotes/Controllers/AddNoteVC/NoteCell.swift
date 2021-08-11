//
//  NoteCell.swift
//  PandaNotes
//
//  Created by Philip Plamenov on 8.08.21.
//

import UIKit
import CoreData
class NoteCell: UITableViewCell {
    
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var textHolder: UIView!
    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var dateText: UILabel!
    @IBOutlet weak var noteImg: UIImageView!
    @IBOutlet weak var edit: UIButton!
    var rowIndex: Int!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        container.layer.cornerRadius = 10
        container.layer.masksToBounds = true
    }
    
    func setup() {
        guard Global.notes.count > rowIndex else { return }
        let note = Global.notes[rowIndex]
        titleText.text = note.text?.string
        dateText.text = stringFromDate(date: note.date!)
    }
    
    private func stringFromDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "E dd.MM.yy h:mm a"
        return formatter.string(from: date)
    }
    
    func deleteNote() {
        guard Global.notes.count > rowIndex else { return }
        let note = Global.notes[rowIndex]
        Global.coreDataContext.delete(note)
        try? Global.coreDataContext.save()
    }
    
    @IBAction func editNote(_ sender: Any) {
        print("test edit")
        showAddressOptions()
    }
    
    private func showAddressOptions() {
        let alert = UIAlertController(title: "Notes options", message: "Please Select an Option", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Encrypt", style: .default , handler:{ (UIAlertAction) in
            
        }))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive , handler:{ (UIAlertAction) in
            self.deleteNote()
            NotificationCenter.default.post(name: .refreshNotification, object: nil)
        }))
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        
        guard let topVC = Helper.topVC() else { return }
        topVC.present(alert, animated: true, completion: nil)
    }
}
