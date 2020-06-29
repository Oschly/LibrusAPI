//
//  LKTimetable.swift
//  LibrusKit
//
//  Created by Oskar on 29/06/2020.
//

import Foundation

public struct LKTimetable: Decodable {
	enum CodingKeys: String, CodingKey {
		case entries = "Timetable"
		case pages = "Pages"
	}
	
	public let entries: [String: [[LKTimetableSingleEntry]]]
	public let nextPage: URL
	public let previousPage: URL
	
	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		
		self.entries = try container.decode([String: [[LKTimetableSingleEntry]]].self, forKey: .entries)
		
		let pages = try container.decode([String: String].self, forKey: .pages)
		
		guard let nextPageString = pages["Next"],
			let previousPageString = pages["Prev"]
			else { preconditionFailure() }
		
		self.nextPage = URL(string: nextPageString)!
		self.previousPage = URL(string: previousPageString)!
	}
}
