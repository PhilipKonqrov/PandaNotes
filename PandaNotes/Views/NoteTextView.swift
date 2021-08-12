//
//  NoteTextView.swift
//  PandaNotes
//
//  Created by Philip Plamenov on 11.08.21.
//

import Foundation
import UIKit
import CoreData
import AVKit
class NoteTextView: UITextView {
    var noteIndex: Int?
    private var note: NoteEntity?
    private let privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
    override func awakeFromNib() {
        super.awakeFromNib()
        createToolbar()
    }
    
    private func createToolbar() {
        let saveBtn = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(save))
        let addImageBtn = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(addImage))
        addImageBtn.image = UIImage(systemName:"camera")
        saveBtn.tintColor = #colorLiteral(red: 0.2112838166, green: 0.2112838166, blue: 0.2112838166, alpha: 1)
        addImageBtn.tintColor = #colorLiteral(red: 0.2112838166, green: 0.2112838166, blue: 0.2112838166, alpha: 1)
        let toolbar: UIToolbar = UIToolbar(frame:CGRect(x:0, y:0, width:100, height:100))
        toolbar.barStyle = .default
        toolbar.items = [
            saveBtn,
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            addImageBtn
        ]
        toolbar.sizeToFit()
        toolbar.barTintColor = #colorLiteral(red: 0.8243550086, green: 0.8243550086, blue: 0.8243550086, alpha: 1)
        self.inputAccessoryView = toolbar
    }
    
    @objc func save() {
        //change keyboard type to number
        print("saving")
        
        privateContext.persistentStoreCoordinator = Global.coreDataContext.persistentStoreCoordinator
        
        if let index = noteIndex {
            note = Global.notes[index]
        } else {
            note = NoteEntity(context: privateContext)
        }
        
        let textToSave = self.attributedText
        
        privateContext.perform {
            // Code in here is now running "in the background" and can safely
            // do anything in privateContext.
            // This is where you will create your entities and save them.
            
            self.note?.text = textToSave
            self.note?.date = Date()
            self.note?.id = UUID.init()
            self.note?.encrypted = false
            try? self.privateContext.save()
            
            DispatchQueue.main.async {
                // Refresh tableView in MainVC
                NotificationCenter.default.post(name: .refreshNotification, object: nil)
            }
            
        }
    }
    @objc func addImage() {
        guard let topVC = Helper.topVC() as? AddNoteVC else { return }
        let picker =  UIImagePickerController()
        picker.delegate = topVC
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            picker.sourceType = UIImagePickerController.SourceType.photoLibrary;
            picker.allowsEditing = false
            topVC.present(picker, animated: true, completion: nil)
        }
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(paste(_:)) && UIPasteboard.general.image != nil {
            return true
        } else {
            return super.canPerformAction(action, withSender: sender)
        }
    }
    
    override func paste(_ sender: Any?) {
        super.paste(sender)
        if let image = UIPasteboard.general.image {
            // Process pasted image
            let imageAttachment = NSTextAttachment()
            imageAttachment.image = image
            
            let oldWidth = imageAttachment.image!.size.width;
            let scaleFactor = oldWidth / (self.frame.size.width - 20); //for the padding inside the textView
            imageAttachment.image = UIImage(cgImage: imageAttachment.image!.cgImage!, scale: scaleFactor, orientation: .up)
            imageAttachment.image = imageAttachment.image?.fixOrientation()
            let attString = NSAttributedString(attachment: imageAttachment)
            
            self.textStorage.insert(attString, at: self.selectedRange.location)
        }
    }
}
