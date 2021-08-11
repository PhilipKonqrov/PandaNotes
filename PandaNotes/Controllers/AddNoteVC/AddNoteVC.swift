//
//  AddNoteVC.swift
//  PandaNotes
//
//  Created by Philip Plamenov on 8.08.21.
//

import UIKit
import CoreData
class AddNoteVC: UIViewController, UITextViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var textViewBottom: NSLayoutConstraint!
    @IBOutlet weak var textView: NoteTextView!
    var isKeyboardAppear = false
    var noteIndex: Int?
    var note: NoteEntity?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.delegate = self
        keyboardObservers()
        textView.noteIndex = noteIndex
        
        if let index = noteIndex, index < Global.notes.count {
            note = Global.notes[index]
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        textView.attributedText = note?.text
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        textView.becomeFirstResponder()
    }
    
    
    // MARK: UIImagePickerControllerDelegate methods
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            // Process pasted image
            let imageAttachment = NSTextAttachment()
            imageAttachment.image = image
            
            let oldWidth = imageAttachment.image!.size.width;
            let scaleFactor = oldWidth / (textView.frame.size.width - 20); //for the padding inside the textView
            imageAttachment.image = UIImage(cgImage: imageAttachment.image!.cgImage!, scale: scaleFactor, orientation: .up)
            imageAttachment.image = imageAttachment.image?.fixOrientation()
            let attString = NSAttributedString(attachment: imageAttachment)
            
            textView.textStorage.insert(attString, at: textView.selectedRange.location)
        }
        dismiss(animated: true, completion: nil)
    }
    
}
