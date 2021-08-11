//
//  CustomTabBar.swift
//  PandaNotes
//
//  Created by Philip Plamenov on 6.08.21.
//

import UIKit

class CustomTabBar: UITabBar {
    
    let shapeLayer = CAShapeLayer()  // Create a CAShapeLayer
    var hasTopNotch: Bool {
        if #available(iOS 11.0, tvOS 11.0, *) {
            return UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0 > 20
        }
        return false
    }
    var fix: CGFloat = {
        // Fixes tab bar height for phones older than iphone X
        let screen = UIScreen.main.bounds
        let screenHeight = screen.size.height
        if screenHeight <= 736 {
            return 20
        }
        return 0
    }()
    override func draw(_ rect: CGRect) {
        backgroundColor = UIColor.clear
        backgroundImage = UIImage()
        shapeLayer.path = createPath().cgPath
        shapeLayer.strokeColor = UIColor.clear.cgColor
        shapeLayer.fillColor =  UIColor.white.cgColor
        shapeLayer.lineWidth = 1.0
        
        // Shadow
        shapeLayer.shadowOffset = CGSize(width:0, height:0)
        shapeLayer.shadowRadius = 10
        shapeLayer.shadowColor = UIColor.gray.cgColor
        shapeLayer.shadowOpacity = 0.3
        
        self.layer.insertSublayer(shapeLayer, at: 0) // add the new layer to our custom view
        
        let button = UIButton()
        button.frame = CGRect(x: self.center.x - 35, y: self.bounds.height - (115 - fix), width: 70, height: 70)
        let btnImage = UIImage(named: "plusButton")
        button.setImage(btnImage, for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        button.addTarget(self, action: #selector(buttonPress(_:)), for: .touchUpInside)
        button.clipsToBounds = false
        self.insertSubview(button, aboveSubview: self)
        
        
        setTabBarItems()
        //        Global.appTabBar = self
    }
    
    
    // This enables touches outside of tabbar for the custom button.
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView?
    {
        guard !clipsToBounds && !isHidden && alpha > 0 else { return nil }
        
        for member in subviews.reversed()
        {
            let subPoint = member.convert(point, from: self)
            guard let result = member.hitTest(subPoint, with: event)
            else { continue }
            return result
        }
        
        return nil
    }
    
    @objc func buttonPress(_ button: UIButton?) {
        if let topVC = Helper.topVC() {
            let st = UIStoryboard(name: "Home", bundle: nil)
            let vc = st.instantiateViewController(withIdentifier: "addNoteVC") as! AddNoteVC
            vc.modalTransitionStyle = .coverVertical
            vc.modalPresentationStyle = .formSheet
            topVC.present(vc, animated: true, completion: nil)
        }
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var size = super.sizeThatFits(size)
        size.height = 80 - fix
        return size
    }
    
    func createPath() -> UIBezierPath {
        let radius : CGFloat = 40
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        
        path.addLine(to: CGPoint(x: ((self.frame.width/2) - radius), y: 0))
        
        path.addLine(to: CGPoint(x:self.frame.width/2 - 10, y: 30))
        
        path.addQuadCurve(to: CGPoint(x: self.frame.width/2 + 10, y: 30), controlPoint: CGPoint(x: self.frame.width/2, y: 40))
        
        path.addLine(to: CGPoint(x:self.frame.width/2 + radius, y: 0))
        path.addLine(to: CGPoint(x:self.frame.width, y: 0))
        path.addLine(to: CGPoint(x: self.frame.width, y: self.frame.height))
        path.addLine(to: CGPoint(x: 0, y: self.frame.height))
        path.close()
        return path
    }
    
    func setTabBarItems(){
        if !hasTopNotch {
            UITabBarItem.appearance().titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -10)
        }
        self.tintColor = #colorLiteral(red: 0.3294117647, green: 0.4235294118, blue: 0.9647058824, alpha: 1)
        let barItem1 = (self.items?[0])! as UITabBarItem
        barItem1.image = UIImage(named: "dashboard")?.withRenderingMode(.alwaysTemplate)
        barItem1.selectedImage = UIImage(named: "dashboard")?.withRenderingMode(.alwaysTemplate)
        barItem1.title = "Home"
        
        let barItem2 = (self.items?[1])! as UITabBarItem
        barItem2.isEnabled = false
        
        let barItem3 = (self.items?[2])! as UITabBarItem
        barItem3.image = UIImage(named: "menu-icon")?.withRenderingMode(.alwaysTemplate)
        barItem3.selectedImage = UIImage(named: "menu-icon")?.withRenderingMode(.alwaysTemplate)
        barItem3.title = "Menu"
        
    }
    
}
