//
//  Building.swift
//  UniCAT
//
//  Created by Lye Guang Xing on 5/31/15.
//  Copyright (c) 2015 Sweatshop Solutions. All rights reserved.
//

import Foundation

struct Building {
    
    func buildingName(#room: String) -> String {
        
        // Get the Building initial from Room number
        var initial = room.substringToIndex(advance(room.startIndex, 1))
        var length = count(room)
        
        if length >= 7 {
            return room
        }
        
        // Return UTAR Building Name
        switch initial {
        case "A":
            return "Heritage Hall"
        case "B":
            return "Learning Complex I"
        case "C":
            return "Student Pavilion I"
        case "D":
            return "Faculty of Science"
        case "E":
            return "FEGT"
        case "F":
            return "Administration"
        case "G":
            return "Library"
        case "H":
            return "FBF"
        case "I":
            return "Lecture Complex I"
        case "J":
            return "Engineering Workshop"
        case "K":
            return "Student Pavilion II"
        case "L":
            return "Lecture Complex II"
        case "M":
            return "Grand Hall"
        case "N":
            return "FICT & IPSR Lab"
        case "P":
            return "FAS & ICS"
        default:
            return room
        }
        
    }
    
}