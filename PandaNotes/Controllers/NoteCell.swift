//
//  NoteCell.swift
//  PandaNotes
//
//  Created by Philip Plamenov on 8.08.21.
//

import UIKit
import CoreData
import LocalAuthentication
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
        if let date = note.date {
            dateText.text = stringFromDate(date: date)
        }
        
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
        showOptions()
    }
    
    private func showOptions() {
        let alert = UIAlertController(title: "Notes options", message: "Please Select an Option", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Share", style: .default , handler:{ (UIAlertAction) in
            self.handleShare()
        }))
        handleEncryption(alert: alert)
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive , handler:{ (UIAlertAction) in
            self.deleteNote()
            NotificationCenter.default.post(name: .refreshNotification, object: nil)
        }))
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        
        guard let topVC = Helper.topVC() else { return }
        topVC.present(alert, animated: true, completion: nil)
    }
    
    private func handleShare() {
        // Share note
        guard let topVC = Helper.topVC() else { return }
        guard let noteText: NSAttributedString = Global.notes[self.rowIndex].text else { return }
        
        var activityItems: [Any] = []
        activityItems.append(noteText.string)
        noteText.enumerateAttribute(NSAttributedString.Key.attachment, in: NSRange(location: 0, length: noteText.length), options: [], using: {(value,range,stop) -> Void in
            if (value is NSTextAttachment) {
                let attachment: NSTextAttachment? = value as? NSTextAttachment
                var image: UIImage? = nil
                
                if ((attachment?.image) != nil) {
                    image = attachment?.image
                } else {
                    image = attachment?.image(forBounds: (attachment?.bounds)!, textContainer: nil, characterIndex: range.location)
                }
                if let img = image {
                    activityItems.append(img)
                }
            }
        })
        
        let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = topVC.view
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
        
        topVC.present(activityViewController, animated: true, completion: nil)
    }
    
    private func handleEncryption(alert: UIAlertController) {
        // Encrypt or decrypt the note
        let authContext = LAContext()
        var authErr: NSError?
        authContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authErr)
        if authErr != nil {
            // Auth not available. Don't show action for encryption.
        } else {
            guard Global.notes.count > self.rowIndex else { return }
            if Global.notes[self.rowIndex].encrypted {
                alert.addAction(UIAlertAction(title: "Decrypt", style: .default , handler:{ (UIAlertAction) in
                    authContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Decrypt your notes") { completition, err in
                        if let err = err {
                            print(err.localizedDescription)
                        } else {
                            if completition {
                                print("unlock successful")
                                DispatchQueue.main.async {
                                    Global.notes[self.rowIndex].encrypted = false
                                    try? Global.coreDataContext.save()
                                }
                            } else {
                                print("unlock not successful")
                            }
                        }
                    }
                }))
            } else {
                alert.addAction(UIAlertAction(title: "Encrypt", style: .default , handler:{ (UIAlertAction) in
                    Global.notes[self.rowIndex].encrypted = true
                    try? Global.coreDataContext.save()
                }))
            }
            
        }
    }
}
