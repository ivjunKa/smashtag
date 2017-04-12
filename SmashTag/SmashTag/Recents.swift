//
//  Recents.swift
//  SmashTag
//
//  Created by Home on 11/04/17.
//  Copyright (c) 2017 nl.han.ica.mad. All rights reserved.
//

import Foundation
class Recents {
    var searches: [String] {
        get{return NSUserDefaults.standardUserDefaults().objectForKey("RecentSearches.Values") as? [String] ?? [] }
        set{NSUserDefaults.standardUserDefaults().setObject(newValue, forKey: "RecentSearches.Values")}
    }
    func add(search: String){
        if let index = find(searches, search){
            searches.removeAtIndex(index)
        }
        searches.insert(search, atIndex: 0)
        while searches.count > 100 {
            searches.removeLast()
        }
    }
}