//
//  Expenses.swift
//  ExpensesApp
//
//  Created by Mohammed1 Shoeb on 28/11/21.
//

import Foundation
import CoreData

public class Expenses: NSManagedObject, Identifiable {
    @NSManaged var title: String
    @NSManaged var amount: Double
    @NSManaged var transactionType: String
    @NSManaged var createdAt: Date?
    @NSManaged var updatedOn: Date?
}

extension Expenses {
    func reduceToMonthDayYear(fromDate: Date) -> Date {
        let calendar = Calendar.current
        let month = calendar.component(.month, from: fromDate)
        let day = calendar.component(.day, from: fromDate)
        let year = calendar.component(.year, from: fromDate)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        return dateFormatter.date(from: "\(month)/\(day)/\(year)") ?? Date()
    }
}
