//
//  AddNoteVC.swift
//  PandaNotes
//
//  Created by Philip Plamenov on 8.08.21.
//

import UIKit

class AddNoteVC: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var textViewBottom: NSLayoutConstraint!
    @IBOutlet weak var textView: MyTextView!
    var isKeyboardAppear = false
    var note: Note?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.delegate = self
        keyboardObservers()
        
        if note == nil {
            note = Note(date: Date(), text: textView.attributedText)
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
        guard let note = self.note else { return }
        Global.notes.append(note)
        NotificationCenter.default.post(name: .refreshNotification, object: nil)
    }
    
}
