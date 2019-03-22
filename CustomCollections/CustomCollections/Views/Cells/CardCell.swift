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

        selectionStyle = .none
    }

    override func prepareForReuse() {
        collectionImageView.image = nil
        collectionDescriptionTextView.text = ""
        collectionTitleLabel.text = ""
    }

    func configure(collection: CustomCollection?) {
        guard let collection = collection else { return }
        collectionTitleLabel.text = collection.title

        collectionDescriptionTextView.text = collection.bodyHtml.isEmpty ? "No description" : collection.bodyHtml
        loadImage(urlString: collection.image.src)
    }

    private func loadImage(urlString: String) {
        DispatchQueue.global().async {
            if let url = URL(string: urlString),
                let imageData = try? Data(contentsOf: url),
                let image = UIImage(data: imageData) {
                DispatchQueue.main.async {
                    self.collectionImageView.image = image
                }
            }
        }
    }

}
