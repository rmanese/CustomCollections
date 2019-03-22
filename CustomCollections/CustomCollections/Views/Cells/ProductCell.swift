//
//  ProductCell.swift
//  CustomCollections
//
//  Created by Roberto Manese III on 3/17/19.
//  Copyright © 2019 jawnyawn. All rights reserved.
//

import UIKit

class ProductCell: UITableViewCell {

    @IBOutlet var collectionImage: UIImageView!
    @IBOutlet var collectionTitleLabel: UILabel!
    @IBOutlet var productTitleLabel: UILabel!
    @IBOutlet var totalQuantityLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        self.selectionStyle = .none
    }

    override func prepareForReuse() {
        self.collectionTitleLabel.text = ""
        self.productTitleLabel.text = ""
        self.totalQuantityLabel.text = ""
        self.collectionImage.image = nil
    }

    func configure(collection: CustomCollection?, product: Product) {
        guard let collection = collection else { return }
        let quantity = product.countQuantity(variants: product.variants)

        let attributedText = NSMutableAttributedString(string: "$\(product.variants[0].price)", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16)])
        attributedText.append(NSAttributedString(string: " (\(quantity) units left)", attributes: [NSAttributedString.Key.font :UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.lightGray]))

        self.loadImage(urlString: product.image.src)
        self.collectionTitleLabel.text = collection.title.capitalized
        self.productTitleLabel.text = product.title.capitalized
        self.totalQuantityLabel.attributedText = attributedText
    }

    private func loadImage(urlString: String) {
        DispatchQueue.global().async {
            if let url = URL(string: urlString),
                let imageData = try? Data(contentsOf: url),
                let image = UIImage(data: imageData) {
                DispatchQueue.main.async {
                    self.collectionImage.image = image
                }
            }
        }
    }
    
}
