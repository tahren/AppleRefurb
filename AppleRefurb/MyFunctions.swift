//
//  MyFunctions.swift
//  AppleRefurb
//
//  Created by Tahren Ponnusamy on 1/3/2025.
//

import Foundation

let appleProductURLs = ["https://www.apple.com/au/shop/refurbished/mac", "https://www.apple.com/au/shop/refurbished/ipad", "https://www.apple.com/au/shop/refurbished/watch", "https://www.apple.com/au/shop/refurbished/airpods", "https://www.apple.com/au/shop/refurbished/homepod", "https://www.apple.com/au/shop/refurbished/appletv"]

struct AppleProduct: Identifiable {
    var id = UUID()
    var type: AppleProductType
    var name: String
    var url: String
    var price: Double
    var imageURL: String
    var description: String
    var colour: String?
    var screenSize: String?
    var processor: String?
    var cpu: String?
    var gpu: String?
    var memory: String?
    var storage: String?
    var material: String?
    var macType: String?
    var series: String?
}

enum AppleProductType: Int, CaseIterable {
    case Mac = 0
    case iPad
    case Watch
    case Airpods
    case Homepod
    case AppleTV
    var index: Int {
        return rawValue
    }
    var value: String {
        return String(describing: self)
    }
}
