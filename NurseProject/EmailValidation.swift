//
//  EmailValidation.swift
//  NurseProject
//
//  Created by Jeyavijay on 15/09/17.
//  Copyright © 2017 Jeyavijay N. All rights reserved.
//

import UIKit

class EmailValidation: NSObject {

    func validateMail(textEmail: String) -> Bool
    {
        let REGEX: String
        REGEX = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", REGEX).evaluate(with: textEmail)
    }

}
