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



extension Notification.Name {
    public static let refreshNotification = Notification.Name(rawValue: "refreshHomeVC")
}
extension UIImage {
    func fixOrientation() -> UIImage {
        if self.imageOrientation == UIImage.Orientation.up {
            return self
        }
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        if let normalizedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext() {
            UIGraphicsEndImageContext()
            return normalizedImage
        } else {
            return self
        }
    }
}

extension UIViewController {
    func customizeNavBar() {
        guard let navBar = navigationController?.navigationBar else { return }
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.3607843137, green: 0.4196078431, blue: 0.9490196078, alpha: 1)
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.backgroundColor = #colorLiteral(red: 0.3607843137, green: 0.4196078431, blue: 0.9490196078, alpha: 1)
        
        let contentView = UIView(frame: navBar.frame)
        let frame = CGRect(x: 8, y: 0, width: 200, height: 40)
        let tlabel = UILabel(frame: frame)
        tlabel.text = self.title
        tlabel.textColor = UIColor.white
        tlabel.font = UIFont.systemFont(ofSize: 30, weight: .heavy)
        tlabel.backgroundColor = UIColor.clear
        tlabel.adjustsFontSizeToFitWidth = true
        tlabel.textAlignment = .left
        contentView.addSubview(tlabel)
        self.navigationItem.titleView = contentView
        
        if #available(iOS 11.0, *) {
            navBar.largeTitleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 36, weight: .heavy)]
        }
    }
    
}
