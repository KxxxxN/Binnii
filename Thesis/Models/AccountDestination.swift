//
//  AccountDestination.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 21/4/2569 BE.
//


enum AccountDestination: Hashable {
    case profile
    case translate
    case helpCenter
    case contactUs
    case confirmPassword
    case confirmEmail(String)
}