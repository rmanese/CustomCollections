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
    @IBOutlet var detailsStackView: UIStackView!

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
        loadImage(urlString: collection.image.src)
        
        self.collectionTitleLabel.text = collection.title.capitalized
        self.productTitleLabel.text = product.title.capitalized
        self.totalQuantityLabel.text = "\(product.countQuantity(variants: product.variants)) units left"
    }

    private func loadImage(urlString: String) {
        DispatchQueue.global().async {
            if let url = URL(string: urlString) {
                if let imageData = try? Data(contentsOf: url) {
                    if let image = UIImage(data: imageData) {
                        DispatchQueue.main.async {
                            self.collectionImage.image = image
                        }
                    }
                }
            }
        }
    }
    
}
