//
//  GroupsTableViewCell.swift
//  VKclient
//
//  Created by Alexander Grigoryev on 16.01.2022.
//

import UIKit

class GroupsTableViewCell: UITableViewCell {
    

    @IBOutlet var avatarView: UIImageView!
    @IBOutlet var labelGroup: UILabel!
    static let reusedIdentifier = "myGroupsCells"

    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(from viewModel: GroupsViewModel) {
        avatarView.sd_setImage(with: viewModel.photo)
        labelGroup.text = viewModel.name
    }
    
}
