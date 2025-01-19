//
//  DateUtils.swift
//  TvMazeApp
//
//  Created by Rafael Plinio on 19/01/25.
//

import Foundation

struct DateUtils {

    static func formatDate(_ dateString: String) -> String? {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd" // Original date format

        // Convert the string to a Date object
        guard let date = inputFormatter.date(from: dateString) else {
            return nil // Return nil if the string can't be converted to a Date
        }

        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "MM/dd/yyyy" // Desired date format
        return outputFormatter.string(from: date)
    }
}
