//
//  AddNoteVC.swift
//  PandaNotes
//
//  Created by Philip Plamenov on 8.08.21.
//

import UIKit
import CoreData
class AddNoteVC: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var textViewBottom: NSLayoutConstraint!
    @IBOutlet weak var textView: MyTextView!
    var isKeyboardAppear = false
    var noteIndex: Int?
    var note: NoteEntity?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.delegate = self
        keyboardObservers()
        
        if let index = noteIndex, index < Global.notes.count {
            note = Global.notes[index]
        } else {
            note = NoteEntity(context: Global.coreDataContext)
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        textView.attributedText = note?.text
    }
    
    func textViewDidChange(_ textView: UITextView) {
        note?.text = textView.attributedText
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        note?.text = textView.attributedText
        note?.date = Date()
        note?.id = UUID.init()
        
        // Save note obj to CoreData
        try? Global.coreDataContext.save()
        
        // Refresh tableView in MainVC
        NotificationCenter.default.post(name: .refreshNotification, object: nil)
    }
    
}
