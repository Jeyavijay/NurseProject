//
//  ConvertToString.swift
//  MindIT
//
//  Created by Jeyavijay on 23/06/17.
//  Copyright © 2017 Jeyavijay. All rights reserved.
//

import UIKit

class ConvertToString: NSString {
    
    func anyToStr(convert:Any)-> NSString
    {
        var str:NSString = String(format: "%@", convert as! CVarArg ) as NSString
        str = str.replacingOccurrences(of: "Optional()", with: "") as NSString
        return str
        
    }


}
