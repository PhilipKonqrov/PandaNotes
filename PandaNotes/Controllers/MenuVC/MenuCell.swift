//
//  MenuCell.swift
//  PandaNotes
//
//  Created by Philip Plamenov on 12.08.21.
//

import UIKit

class MenuCell: UITableViewCell {

    @IBOutlet weak var container: UIView!
    @IBOutlet weak var textHolder: UIView!
    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var descriptionText: UILabel!
    var rowIndex: Int!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        container.layer.cornerRadius = 10
        container.layer.masksToBounds = true
    }
    
    func setup() {
        guard rowIndex < Global.menuItems.count else { return }
        titleText.text = Global.menuItems[rowIndex].titleText
        descriptionText.text = Global.menuItems[rowIndex].descriptionText
    }

}
