//
//  Country.swift
//  RestCountriesApp
//
//  Created by jazeps.ivulis on 16/05/2023.
//

import Foundation

struct Country: Codable {
    let name: Name
    let flags: Flags
}

struct Name: Codable {
    let common, official: String?
}

struct Flags: Codable {
    let png: String
}
