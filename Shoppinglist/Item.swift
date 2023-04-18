//
//  Item.swift
//  Shoppinglist
//
//  Created by Julia Petersson  on 2023-04-17.
//

import Foundation
import FirebaseFirestoreSwift

struct Item : Codable, Identifiable {
    @DocumentID var id : String?
    var name : String
    var category : String = ""
    var done : Bool = false
    
    
    
    
}
