//
//  TripCollectionViewCell.swift
//  TripCards
//
//  Created by Adnann Muratovic on 07.09.21.
//



import UIKit

protocol TripCollectionViewCellDelegate {
    func didTapLikeButton(cell: TripCollectionViewCell)
}

class TripCollectionViewCell: UICollectionViewCell {
    
    var delegate: TripCollectionViewCellDelegate?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var daysLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var isLikedButton: UIButton!
    
    var isLiked: Bool = false {
        didSet {
            if isLiked {
                isLikedButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            } else {
                isLikedButton.setImage(UIImage(systemName: "heart"), for: .normal)
            }
        }
    }
    @IBAction func likeButtonPressed(_ sender: Any) {
        delegate?.didTapLikeButton(cell: self)
    }
}
