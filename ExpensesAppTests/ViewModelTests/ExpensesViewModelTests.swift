//
//  ExpensesViewModelTests.swift
//  ExpensesAppTests
//
//  Created by Mohammed1 Shoeb on 02/12/21.
//

import XCTest
@testable import ExpensesApp

class ExpensesViewModelTests: XCTestCase {
    var expensesViewModel: ExpensesViewModel?
    
    override func setUpWithError() throws {
        self.expensesViewModel = ExpensesViewModel(viewController: ViewController())
    }

    override func tearDownWithError() throws {
        self.expensesViewModel = nil
    }

    func testGetTotalBalance() throws {
        if let listArray = self.mockSectionData(), listArray.isEmpty == false {
            let cardData = self.expensesViewModel?.getTotalBalance(expenseData: listArray)
            XCTAssertNotNil(cardData?.expenses)
            XCTAssertNotNil(cardData?.balance)
            XCTAssertNotNil(cardData?.income)
        }
    }
    
    func testUpdateBalanceCard() {
        if let listArray = self.mockSectionData(), listArray.isEmpty == false {
            let cardData = self.expensesViewModel?.updateBalanceCard(balanceAmountText: "$123.0", incomeAmountText: "$900.0", expensesAmountText: "-$200.0", expenses: listArray.first?.first)
            XCTAssertNotNil(cardData?.expenses)
            XCTAssertNotNil(cardData?.balance)
            XCTAssertNotNil(cardData?.income)
        }
    }
    
    func testGetDateFormatter() {
       let transactionDate = self.expensesViewModel?.getDateFormatter(date: Date(), format: "dd'\(expensesViewModel?.daySuffix(createdAt: Date()) ?? "")' MMMM, yyyy")
        XCTAssertNotNil(transactionDate)
    }
    func testconverStringToDouble() {
        let response = self.expensesViewModel?.converStringToDouble(amountString: "$10.0")
        XCTAssertEqual(response, Double("10.0"))
        
    }
    func mockSectionData() -> [[Expenses]]? {
        let ad = UIApplication.shared.delegate as! AppDelegate
        let contextAbove = ad.persistentContainer.viewContext
        var sectionArray = [[Expenses]]()
        var dataArray: [Expenses]? = []
        for i in 1...8 {
            let expenses = Expenses(context: contextAbove)
            expenses.amount =  30.00 + Double(i)
            expenses.title =  "salary"
            expenses.transactionType =  i == 1 ? ExpenseAmountType.income.rawValue : ExpenseAmountType.expenses.rawValue
            expenses.createdAt = Date()
            expenses.updatedOn = Date()
            dataArray?.append(expenses)
        }
        sectionArray.append(dataArray ?? [])
        return sectionArray
    }

}
