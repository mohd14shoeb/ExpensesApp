//
//  ExpensesViewModel.swift
//  ExpensesApp
//
//  Created by Mohammed1 Shoeb on 27/11/21.
//

import Foundation
import UIKit
import CoreData

enum ExpenseAmountType: String {
    case expenses = "Expenses"
    case income = "Income"
}

class ExpensesViewModel {
    static let databaseHandler = DatabaseHandler.shared
    let viewController: ViewController?
    var expensesList: [[Expenses]]? {
        didSet {
            DispatchQueue.main.async {
                self.viewController?.listTableView.reloadData()
            }
        }
    }
    init(viewController: ViewController) {
        self.viewController = viewController
    }
    
    
    func getAllExpensesList() {
        let expensesList: [Expenses]? = ExpensesViewModel.databaseHandler.fetch(Expenses.self)
        if let expensesListArray = expensesList, expensesListArray.count > 0 {
            self.attemptToAssembleGroupedExpensesRecord(expensesListArray: expensesListArray)
        }
    }
    
     func attemptToAssembleGroupedExpensesRecord(expensesListArray: [Expenses]) {
        var dataListArray = [[Expenses]]()
        let groupedMessages = Dictionary(grouping: expensesListArray) { (element) -> Date in
            return element.reduceToMonthDayYear(fromDate: element.createdAt ?? Date())
        }
        let sortedKeys = groupedMessages.keys.sorted()
        sortedKeys.forEach { (key) in
            let values = groupedMessages[key]
            dataListArray.append(values ?? [])
        }
        self.expensesList = dataListArray.reversed()
    }
    func getTotalBalance(expenseData: [[Expenses]]?) -> (income: String?, expenses: String?, balance: String?) {
        var balance = Double(0)
        var incomeAmount = Double(0)
        var expensesAmount = Double(0)
        if let expensesListArray = expenseData, expensesListArray.count > 0 {
            for expensesArray in expensesListArray {
                for expenses in expensesArray {
                    if expenses.transactionType == ExpenseAmountType.income.rawValue {
                        balance += expenses.amount
                        incomeAmount += expenses.amount
                    }
                    else if expenses.transactionType == ExpenseAmountType.expenses.rawValue {
                        balance -= expenses.amount
                        expensesAmount += expenses.amount
                    }
                }
            }
            return ("\(String(format: "%.1f", incomeAmount))", "\(String(format: "%.1f", expensesAmount))", "\(String(format: "%.1f", balance))")
        }
        return (nil, nil, nil)
    }
    func updateBalanceCard(balanceAmountText: String?, incomeAmountText: String?, expensesAmountText: String?, expenses: Expenses?) -> (income: String?, expenses: String?, balance: String?) {
        var balanceAmount = 0.0
        var incomeAmount = 0.0
        var expensesAmount = 0.0
        guard let amount = expenses?.amount else {return (nil, nil, nil)}
        
        balanceAmount =  self.converStringToDouble(amountString: balanceAmountText)
        incomeAmount = self.converStringToDouble(amountString: incomeAmountText)
        expensesAmount = self.converStringToDouble(amountString: expensesAmountText)
        
        if expenses?.transactionType == ExpenseAmountType.income.rawValue {
            balanceAmount -= amount
            incomeAmount -= amount
        }
        else if expenses?.transactionType == ExpenseAmountType.expenses.rawValue {
            balanceAmount += amount
            expensesAmount -= amount
        }
        return ("\(String(format: "%.1f", incomeAmount))", "\(String(format: "%.1f", expensesAmount))", "\(String(format: "%.1f", balanceAmount))")
    }
    
    func converStringToDouble(amountString: String?) -> Double {
        let amountText = amountString?.replacingOccurrences(of: "$", with: "")
        return Double("\((amountText! as NSString).doubleValue)") ?? 0.0
    }
    func addNewExpenseRecord(expensesAddView: ExpensesAddView?) -> String? {
        guard  let transactionType = ExpenseAmountType(rawValue: expensesAddView?.transactionTypeTextField.text ?? "") else {
            return "Enter transaction Type"
        }
        guard let description = expensesAddView?.descriptionTextField.text, description.isEmpty == false, expensesAddView?.descriptionTextField.isEmpty == false else {
            return "Enter transaction description"
        }
        
        guard let amount =  Double(expensesAddView?.transactionAmount.text ?? ""), amount > 0 else {
            return "Enter transaction amount"
        }
        let expenseDaataDictionary = ["transactionType": transactionType.rawValue, "title": description, "amount": Double(amount)] as [String: Any]
        return self.saveExpenses(expensesDictionary: expenseDaataDictionary)
    }
    
    
    func saveExpenses(expensesDictionary: [String: Any]?) -> String? {
        let expenses = ExpensesViewModel.databaseHandler.add(Expenses.self)
        expenses?.amount = expensesDictionary?["amount"] as? Double ?? 0.00
        expenses?.title = expensesDictionary?["title"] as? String ?? ""
        expenses?.transactionType = expensesDictionary?["transactionType"] as? String ?? ""
        expenses?.createdAt = Date()
        expenses?.updatedOn = Date()
        ExpensesViewModel.databaseHandler.save()
        return ""
    }
    
    func getDateFormatter(date: Date?, format: String = "yyyy-MM-dd") -> String {
        guard let date = date else { return "" }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
    func daySuffix(createdAt: Date) -> String {
        let calendar = Calendar.current
        let components = (calendar as NSCalendar).components(.day, from: createdAt)
        let dayOfMonth = components.day
        switch dayOfMonth {
        case 1, 21, 31:
            return "st"
        case 2, 22:
            return "nd"
        case 3, 23:
            return "rd"
        default:
            return "th"
        }
    }
}
