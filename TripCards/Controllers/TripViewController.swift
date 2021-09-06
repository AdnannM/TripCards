//
//  ViewController.swift
//  TripCards
//
//  Created by Adnann Muratovic on 06.09.21.
//

import UIKit

class TripViewController: UIViewController {
    
    // MARK: - Properties
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    // MARK: - ViewLifeCycel
    override func viewDidLoad() {
        super.viewDidLoad()
        addBlurImage()
    }

    // MARK: - Blur backgorundImage

    private func addBlurImage() {
        backgroundImageView.image = UIImage(named: "cloud")
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        backgroundImageView.addSubview(blurEffectView)
    }
    
}

