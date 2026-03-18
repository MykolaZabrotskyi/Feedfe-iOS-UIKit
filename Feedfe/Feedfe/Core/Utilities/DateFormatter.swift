//
//  DateFormatter.swift
//  Feedfe
//
//  Created by Mykola Zabrotskyi on 11.03.2026.
//

import Foundation

protocol DateFormatterProtocol {
    func formatRelativeDate(from timestamp: Int) -> String
}

final class DateFormatter {
    
    // MARK: - Properties
    
    private lazy var relativeFormatter: RelativeDateTimeFormatter = {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter
    }()
}

// MARK: - DateFormatteProtocol

extension DateFormatter: DateFormatterProtocol {
    func formatRelativeDate(from timestamp: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        return relativeFormatter.localizedString(for: date, relativeTo: Date())
    }
}
