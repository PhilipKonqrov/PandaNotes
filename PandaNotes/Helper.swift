//
//  Helper.swift
//  PandaNotes
//
//  Created by Philip Plamenov on 8.08.21.
//
import UIKit
import Foundation


class Helper {
    class func topVC() -> UIViewController? {
        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first

        if var topController = keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            return topController
        }
        return nil
    }
}

class MyTextView: UITextView {
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
    }
    @objc func addImage() {
        //change keyboard type to number
        print("addImage")
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
            
            let attString = NSAttributedString(attachment: imageAttachment)
            
            self.textStorage.insert(attString, at: self.selectedRange.location)
        } 
    }
}

extension Notification.Name {
    public static let refreshNotification = Notification.Name(rawValue: "refreshHomeVC")
}
