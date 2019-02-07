//
//  DataStorage.swift
//  DevHelper
//
//  Created by pavel.grechikhin on 07.02.2019.
//  Copyright © 2019 pavel.grechikhin. All rights reserved.
//

import Cocoa

protocol DataStorageProxy {
    func lastClear() -> String
    func updateLastDate(completion: (String)->())
}

class DataStorage: NSObject, DataStorageProxy {
    
    let userDefaults = UserDefaults.standard
    
    func lastClear() -> String {
        if let date = userDefaults.string(forKey: "clear") {
            return date
        } else {
            return "unknown"
        }
    }
    
    func updateLastDate(completion: (String) -> ()) {
        let date = "\(Date())"
        let prettyDate = prettyDateFormat(date: date)
        userDefaults.set(prettyDate, forKey: "clear")
        completion(prettyDate)
    }
    
    private func getDateFromString(date: String) -> Date {
        let formater = DateFormatter()
        formater.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formater.locale = Locale(identifier: "ru_RU")
        return formater.date(from: date) ?? Date()
    }
    
    private func prettyDateFormat(date: String) -> String {
        let date = getDateFromString(date: date)
        let formater = DateFormatter()
        formater.dateFormat = "dd.MM.yy HH:mm"
        formater.locale = Locale(identifier: "ru_RU")
        return formater.string(from: date)
    }

}
