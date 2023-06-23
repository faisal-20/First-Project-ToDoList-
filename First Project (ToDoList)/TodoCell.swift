//
//  TodoCell.swift
//  First Project (ToDoList)
//
//  Created by faisal almalki on 20/06/2023.
//

import UIKit

class TodoCell: UITableViewCell {

    @IBOutlet weak var todoTitleLabel: UILabel!
    @IBOutlet weak var todoCreationDateLabel: UILabel!
    @IBOutlet weak var todoImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
