//
//  Item.swift
//  RebuildLoFo
//
//  Created by Nicholas  on 17/04/25.
//

import Foundation
import SwiftData

var items: [Item] = []


@Model
final class Item {
    
//    var id: UUID
    var dateFound : Date = Date()
    var dateClaimed: Date = Date()
    var itemName : String = ""
    var itemDescription : String = ""
    var itemCategory : String = ""
    var locationFound : String = ""
    var locationClaimed : String = ""
    var itemStatus : String = ""
    var claimerName : String = ""
    var claimerContact : String = ""
    var imageData: Data?
    
//    var isClaimed : Bool
    
    
    
    init(dateFound : Date, dateClaimed: Date, itemName : String, itemDescription : String, itemCategory : String, locationFound : String, itemStatus : String, claimerName : String, claimerContact : String, imageData: Data?) {

//        self.id = UUID()
        self.dateFound = dateFound
        self.dateClaimed = dateClaimed
        self.itemName = itemName
        self.itemDescription = itemDescription
        self.itemCategory = itemCategory
        self.locationFound = locationFound
        self.locationClaimed = "Front Desk"
        self.itemStatus = itemStatus
        self.claimerName = claimerName
        self.claimerContact = claimerContact
        self.imageData = imageData
//        self.isClaimed = isClaimed
        
    }
}

extension Item {
    static var dummy: Item {
        return Item(
//            id: UUID(),
            dateFound: Date(),
            dateClaimed: Date(),
            itemName: "Airpods",
            itemDescription: "White wireless earphonesearphonesearphonesearphonesearphonesearphonesearphonesearphonesearphones",
            itemCategory: "Electronics",
            locationFound: "Library",
            itemStatus: "Claimed",
            claimerName: "John Doe",
            claimerContact: "081234567990",
            imageData: Data()
//            isClaimed: true
            
        )
    }
    
    static var dummy2: Item {
        return Item(
//            id: UUID(),
            dateFound: Date(),
            dateClaimed: Date(),
            itemName: "Water Bottle",
            itemDescription: "Blue plastic bottle with sticker",
            itemCategory: "Miscellaneous",
            locationFound: "Cafeteria",
            itemStatus: "Unclaimed",
            claimerName: "Alice Smith",
            claimerContact: "+0898765432",
            imageData: Data()
//            isClaimed: false
        )
    }
    
    static var dummy3: Item {
        return Item(
//            id: UUID(),
            dateFound: Date(),
            dateClaimed: Date(),
            itemName: "Helmet",
            itemDescription: "Blue plastic bottle with sticker",
            itemCategory: "Accessories",
            locationFound: "Cafeteria",
            itemStatus: "Unclaimed",
            claimerName: "Alice Smith",
            claimerContact: "+0898765432",
            imageData: Data()
//            isClaimed: false
        )
    }
}
