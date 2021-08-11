//
//  NoteCell.swift
//  PandaNotes
//
//  Created by Philip Plamenov on 8.08.21.
//

import UIKit

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
        titleText.text = note.text.string
        dateText.text = stringFromDate(date: note.date)
    }
    
    private func stringFromDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd HH:mm"
        return formatter.string(from: date)
    }
    
    
    @IBAction func editNote(_ sender: Any) {
        
    }
}
