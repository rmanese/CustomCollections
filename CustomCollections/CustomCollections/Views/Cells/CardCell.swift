//
//  CardCell.swift
//  CustomCollections
//
//  Created by Roberto Manese III on 3/21/19.
//  Copyright © 2019 jawnyawn. All rights reserved.
//

import UIKit

class CardCell: UITableViewCell {

    @IBOutlet var mainView: UIView!
    @IBOutlet var shadowView: UIView!
    @IBOutlet var collectionDescriptionTextViewHC: NSLayoutConstraint!
    @IBOutlet var collectionTitleLabel: UILabel!
    @IBOutlet var collectionDescriptionTextView: UITextView!
    @IBOutlet var collectionImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()

    }

    func configure(collection: CustomCollection?) {
        guard let collection = collection else { return }
        self.collectionTitleLabel.text = collection.title

        self.collectionDescriptionTextView.text = collection.bodyHtml.isEmpty ? "No description" : collection.bodyHtml
        self.loadImage(urlString: collection.image.src)
    }

    private func loadImage(urlString: String) {
        DispatchQueue.global().async {
            if let url = URL(string: urlString) {
                if let imageData = try? Data(contentsOf: url) {
                    if let image = UIImage(data: imageData) {
                        DispatchQueue.main.async {
                            self.collectionImageView.image = image
                        }
                    }
                }
            }
        }
    }
}
