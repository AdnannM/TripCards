//
//  Trip.swift
//  TripCards
//
//  Created by Adnann Muratovic on 07.09.21.
//

import Foundation
import UIKit
import Parse

struct Trip: Hashable {
    var tripID: String = ""
    var city: String = ""
    var country: String = ""
    var featuredImage: PFFileObject?
    var price: Int = 0
    var numberOfDays: Int = 0
    var isLiked: Bool = false
    
    init(tripID: String, city: String, country: String, featuredImage: PFFileObject!, price: Int, numberOfDays: Int, isLiked: Bool) {
        self.tripID = tripID
        self.city = city
        self.country = country
        self.featuredImage = featuredImage
        self.price = price
        self.numberOfDays = numberOfDays
        self.isLiked = isLiked
    }
    
    init(pfObject: PFObject) {
        self.tripID = pfObject.objectId!
        self.city = pfObject["city"] as! String
        self.country = pfObject["country"] as! String
        self.featuredImage = pfObject["featuredImage"] as? PFFileObject
        self.price = pfObject["price"] as! Int
        self.numberOfDays = pfObject["numberOfDays"] as! Int
        self.isLiked = pfObject["isLiked"] as! Bool
    }
    
    func toPFObject() -> PFObject {
        let tripObject = PFObject(className: "Trip")
        tripObject.objectId = tripID
        tripObject["city"] = city
        tripObject["country"] = country
        tripObject["featuredImage"] = featuredImage
        tripObject["price"] = price
        tripObject["numberOfDays"] = numberOfDays
        tripObject["isLiked"] = isLiked
        
        return tripObject
    }
}
