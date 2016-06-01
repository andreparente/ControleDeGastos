//
//  User.swift
//  ControleDeGastos
//
//  Created by Andre Machado Parente on 6/1/16.
//  Copyright © 2016 Andre Machado Parente. All rights reserved.
//

import Foundation
import CloudKit


public var userLogged: User!
public var arrayUserRecords: Array<CKRecord> = []
public var users: [User] = []

public class User {
    
    var name: String!
    var email: String!
    var password: String!
    
    init(name: String, email: String, password: String) {
        self.name = name
        self.email = email
        self.password = password
    }
    
    init(email: String, password: String) {
        self.email = email
        self.password = password
    }
}
