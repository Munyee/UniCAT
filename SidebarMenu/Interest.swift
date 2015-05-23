//
//  Interest.swift
//  SidebarMenu
//
//  Created by Lye Guang Xing on 4/10/15.
//  Copyright (c) 2015 AppCoda. All rights reserved.
//

import Foundation


struct InterestList {
    let interestArray = [
        "Healthcare": "10",
        "Medicine": "11",
        "Exercise": "12",
        "Nutrition": "13",
        "Mental Health": "14",
        "History": "20",
        "Religion": "21",
        "Philosophy": "22",
        "Humanity": "23",
        "Literature": "30",
        "Language": "31",
        "Book": "32",
        "Writing": "33",
        "Reading": "34",
        "Fiction": "34",
        "Technology": "40",
        "Engineering": "41",
        "Science": "42",
        "Physics": "43",
        "Biology": "44",
        "Chemistry": "45",
        "Mathematics": "46",
        "Programming": "47",
        "Statistics": "48",
        "Business": "50",
        "Entrepreneurship": "51",
        "Finance": "52",
        "Marketing": "53",
        "Investing": "54",
        "Money": "55",
        "Art": "60",
        "Design": "61",
        "Style": "62",
        "Photography": "63",
        "Fine Art": "64",
        "Web Design": "65",
        "User Interface": "66",
        "Fashion": "67",
        "Sports": "70",
        "Travel": "71",
        "Football": "72",
        "Education": "80",
        "Research": "81",
        "News": "82",
        "Social Media": "83",
        "Movies": "84",
        "Music": "85",
        "Television": "86",
        "Relationship": "90",
        "Love": "91",
        "Humor": "92",
        "Self-improvement": "93",
        "Friendship": "94",
        "Marriage": "95",
        "Politics": "100",
        "Law": "101",
        "Government": "102",
        "Food": "110",
        "Cuisine": "111",
        "Cooking": "112"
    ]
    
    let imageArray = [
        "Healthcare",
        "Medicine",
        "Exercise",
        "Nutrition",
        "Mental-Health",
        "History",
        "Religion",
        "Philosophy",
        "Humanity",
        "Literature",
        "Language",
        "Book",
        "Writing",
        "Reading",
        "Fiction",
        "Technology",
        "Engineering",
        "Science",
        "Physics",
        "Biology",
        "Chemistry",
        "Mathematics",
        "Programming",
        "Statistics",
        "Business",
        "Entrepreneurship",
        "Finance",
        "Marketing",
        "Investing",
        "Money",
        "Art",
        "Design",
        "Style",
        "Photography",
        "Fine-Art",
        "Web-Design",
        "User-Interface",
        "Fashion",
        "Sports",
        "Travel",
        "Football",
        "Education",
        "Research",
        "News",
        "Social-Media",
        "Movies",
        "Music",
        "Television",
        "Relationship",
        "Love",
        "Humor",
        "Self-improvement",
        "Friendship",
        "Marriage",
        "Politics",
        "Law",
        "Government",
        "Food",
        "Cuisine",
        "Cooking"
    ]
    
    let valueArray = [
        10, 11, 12, 13, 14, //Healthcare
        20, 21, 22, 23, //History
        30, 31, 32, 33, 34, 35, //Literature
        40, 41, 42, 43, 44, 45, 46, 47, 48, //Science
        50, 51, 52, 53, 54, 55, //Business
        60, 61, 62, 63, 64, 65, 66, 67, //Art
        70, 71, 72, //Sports
        80, 81, 82, 83, 84, 85, 86, //Education
        90, 91, 92, 93, 94, 95, //Relationship
        100, 101, 102, //Law
        110, 111, 112 //Food
    ]
    
    func totalInterest () -> Int {
        return interestArray.count
    }
}