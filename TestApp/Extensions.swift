//
//  Extensions.swift
//  TestApp
//
//  Created by Vladyslav Shepitko on 12/18/17.
//  Copyright © 2017 Vladyslav Shepitko. All rights reserved.
//

import UIKit
extension UIView{
    func addConstraintsWithFormat(format:String, views:UIView...) {
        var viewsDict:[String:UIView] = [:]
        
        for (index,view) in views.enumerate() {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDict[key] = view
        }
        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat(format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDict))
    }
}

extension NSDate {
    func toString() -> String{
        let dateFormatter = NSDateFormatter()
        return dateFormatter.stringFromDate(self)
    }
    
}

func dateToString(date:NSDate) -> String {
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateStyle = .LongStyle
    return dateFormatter.stringFromDate(date)
}

func dateFrom(string:String)->NSDate?{
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
    let result  = dateFormatter.dateFromString(string)
    print(result)
    return result
}
