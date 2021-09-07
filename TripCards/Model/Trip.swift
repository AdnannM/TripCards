//
//  Trip.swift
//  TripCards
//
//  Created by Adnann Muratovic on 07.09.21.
//

import Foundation
import UIKit


struct Trip: Hashable {
    var tripID: String = ""
    var city: String = ""
    var country: String = ""
    var featureImage: UIImage?
    var price: Int = 0
    var totalDays: Int = 0
    var isLiked: Bool = false
}
