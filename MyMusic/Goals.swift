//
//  Goals.swift
//  MyMusic
//
//  Created by Yerneni, Naresh on 5/8/17.
//  Copyright © 2017 Yerneni, Naresh. All rights reserved.
//

import Foundation

class Goals {
    
    
    var steps : Int?
    var distance : Int?
    var caloriesOut : Int?
    var floors : Int?
    
    var dictionary : NSDictionary!
    
    init(dictionary : NSDictionary) {
        
        self.dictionary = dictionary
//        activityId = dictionary["activityId"] as? Int
//        description = dictionary["description"] as? String
//        mets = dictionary["mets"] as? Int
//        activityName = dictionary["name"] as? String
    }
    
}
