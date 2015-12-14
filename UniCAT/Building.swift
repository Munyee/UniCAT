//
//  Building.swift
//  UniCAT
//
//  Created by Lye Guang Xing on 5/31/15.
//  Copyright (c) 2015 Sweatshop Solutions. All rights reserved.
//

import Foundation

struct Building {
    
    func buildingName(room room: String) -> String {
        
        // Get the Building initial from Room number
        let initial = buildingInitial(room)
        
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
            return "Administration Block"
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
        case "O":
            return "Sports Complex"
        case "P":
            return "FAS & ICS"
        case "U":
            return "UTAR Perak"
        default:
            return room
        }
        
    }
    
    func buildingInitial(room: String) -> String {
        let initial = String(room[room.startIndex])
        let length = room.characters.count
        
        if length >= 10 {
            return room
        }
        
        return initial
    }
    
    func buildingDetail(room room: String) -> String {
        
        // Get the Building initial from Room number
        let initial = buildingInitial(room)
        
        
        // Return UTAR Building Name
        switch initial {
        case "A":
            return "The Heritage Hall houses several divisions and departments, which includes the Centre for Foundation Studies, located on the second floor. Before the opening of the Grand Hall, many major events are organised here. Today, this burden is shared among both halls."
        case "B":
            return "The Department of General Services is on the Ground Floor, as are Tutorial/Lecture Rooms B001- B004 and B006 - B011. On the First Floor are the Tutorial/Lecture Rooms B101 - B113. On the Second Floor is the ITISC Counter and Tutorial/Lecture Rooms B201 - B214"
        case "C":
            return "A lakeview cafetaria is situated at the ground floor of the building, whilst the bookstore, gym, clinic, Department of Student Afairs etc. are on the first floor."
        case "D":
            return "The Faculty General Office, laboratories for Faculty of Science is located here. It also houses lecture theatre DDK 1 to DDK 5."
        case "E":
            return "The Faculty General Office and laboratories for Faculty of Engineering and Green Technology is located here. There is a cafeteria serving vegetarian economic rice. "
        case "F":
            return "The University Administration Block contains the Division of Finance for payment of student bills and other payments. The Division of Examinations, Awards and Scholarships is also situated here. Administration Offices are at the first floor."
        case "G":
            return "This is the university's library building. There is a cafetaria behind."
        case "H":
            return "The Faculty General Office for Faculty of Business and Finance is located here. There is a cafetaria here."
        case "I":
            return "Lecture Halls IDK 1 to IDK 8 is located here."
        case "J":
            return "This Engineering Workshop is for Faculty of Engineering and Green Technology students. IT contains Contruction Management Workshop, Petrochemical Workshop, Environmental Engineering Workshop and Industrial Engineering Workshop."
        case "K":
            return "This cafetaria is for degree students and staff studying and working around this area. It has a variety of food selections such as western food, noodles, economic rice, vegetarian food etc."
        case "L":
            return "Lecture halls LDK 1 to LDK 5 is located here."
        case "M":
            return "Universiti Tunku Abdul Rahman's (UTAR) decennial celebration was celebrated by staff, students and invited distinguished guests with much joy, anticipation and pride at the newly constructed Dewan Tun Dr Ling Liong Sik on 19 October 2012."
        case "N":
            return "The Faculty General Office and computer laboratories for Faculty of Information & Communication Technology is located here. The Institute of Postgraduate Studies and Research laboratories is located at the ground floor."
        case "O":
            return "UTAR's Sports Complex is open for students and staff as well as external parties/individuals.  Booking of the sports facilities is to be made in advance at the office of DSA-Sports & Recreation Unit in Gymnasium (at Student Pavilion I) during opening hours. There are fields and courts for football, basketball, futsal, netball, tennis, volleyball and badminton here."
        case "P":
            return "In line with UTAR's aspiration of providing holistic education to the nation, Faculty of Art & Social Science (FAS) emphasizes on character building besides academic performance. Students are encouraged to reach out to the community and make useful contributions, with hope that such exposure would mould them in becoming better persons. 中文系(Institute of Chinese Studies)成立于2002年8月，是创校初期的八个科系之一，其设置目标是人文教育与学术研究并重，培育德智兼备人才，并逐步发展成为本区域的重点中文教学与研究中心。目前，中文系分为两个校区：八打灵校区负责硕、博士课程及在职班学士课程；而金宝校区，则负责学士课程及新增的硕士课程。"
        case "U":
            return "Universiti Tunku Abdul Rahman (Tunku Abdul Rahman University) is a private university in Malaysia. The university is also known by the acronym UTAR, which is part of the university's emblem. It was established under a foundation called UTAR Education Foundation, a not-for-profit organisation. The university is located in the Kampar town of the state of Perak, which once was renowned for its tin-mining activities"
        default:
            return room
        }
        
    }
    
}