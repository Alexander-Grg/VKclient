//
//  StringExtension.swift
//  VKclient
//
//  Created by Alexander Grigoryev on 08.02.2022.
//

import UIKit

extension String {
    func heightWithConstrainedWidth(width: CGFloat,
                                    font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width,
                                    height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect,
                                            options: [.usesLineFragmentOrigin,
                                                      .usesFontLeading],
                                            attributes: [NSAttributedString.Key.font: font], context: nil)
        return boundingBox.height
    }
}
