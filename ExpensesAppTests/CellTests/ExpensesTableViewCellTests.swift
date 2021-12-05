//
//  ExpensesTableViewCellTests.swift
//  ExpensesAppTests
//
//  Created by Mohammed1 Shoeb on 02/12/21.
//

import XCTest
@testable import ExpensesApp

class ExpensesTableViewCellTests: XCTestCase {
    var expensesTableViewCell: ExpensesTableViewCell?
    
    override func setUpWithError() throws {
        let bundle = Bundle(for: ExpensesTableViewCell.self)
        guard let view = bundle.loadNibNamed("ExpensesTableViewCell", owner: nil)?.first as? UIView else {
            return XCTFail("ExpensesTableViewCell nib did not contain a UIView")
        }
        self.expensesTableViewCell = view as? ExpensesTableViewCell
    }
    
    override func tearDownWithError() throws {
        self.expensesTableViewCell?.expenses = nil
        self.expensesTableViewCell = nil
    }
    func testableViewCellIBOutlet() {
        do {
            _ = try XCTUnwrap(self.expensesTableViewCell?.containerView, "IBOutlet of containerView is attached ")
            _ = try XCTUnwrap(self.expensesTableViewCell?.titleLabel, "IBOutlet of titleLabel is attached ")
            _ = try XCTUnwrap(self.expensesTableViewCell?.amountLabel, "IBOutlet of amountLabel is attached ")
            _ = try XCTUnwrap(self.expensesTableViewCell?.bottomCurveView, "IBOutlet of bottomCurveView is attached ")
            _ = try XCTUnwrap(self.expensesTableViewCell?.leftSepratorView, "IBOutlet of leftSepratorView is attached ")
            _ = try XCTUnwrap(self.expensesTableViewCell?.rightSepratorView, "IBOutlet of rightSepratorView is attached ")
            _ = try XCTUnwrap(self.expensesTableViewCell?.bottomSepratorView, "IBOutlet of bottomSepratorView is attached ")
            _ = try XCTUnwrap(self.expensesTableViewCell?.fullrightSepratorView, "IBOutlet of fullrightSepratorView is attached ")
            _ = try XCTUnwrap(self.expensesTableViewCell?.fullleftSepratorView, "IBOutlet of fullleftSepratorView is attached ")
        } catch {}
        
    }
    func testXib() {
        XCTAssertNotNil(self.expensesTableViewCell?.awakeFromNib())
    }
    func testDefaultDesign() {
        XCTAssertEqual(self.expensesTableViewCell?.bottomCurveView?.layer.cornerRadius, 10)
        XCTAssertEqual(self.expensesTableViewCell?.bottomCurveView?.layer.borderWidth, 1)
        XCTAssertEqual(self.expensesTableViewCell?.bottomCurveView?.layer.borderColor, UIColor.lightGray.cgColor)
    }
    func testReloadTableCellDesign() throws {
        let indexPath = IndexPath(row: 0, section: 1)
        self.expensesTableViewCell?.reloadCellDesign(indexPath: indexPath, sectionArray: self.mockData())
        XCTAssertEqual(self.expensesTableViewCell?.bottomSepratorView.backgroundColor, UIColor.darkGray)
        XCTAssertEqual(self.expensesTableViewCell?.bottomCurveView.layer.borderColor, UIColor.clear.cgColor)
    }
    
    func testReloadTableCellForLastIndex() throws {
        let indexPath = IndexPath(row: 2, section: 1)
        self.expensesTableViewCell?.reloadCellDesign(indexPath: indexPath, sectionArray: self.mockData())
        XCTAssertEqual(self.expensesTableViewCell?.bottomSepratorView.backgroundColor, UIColor.clear)
        XCTAssertEqual(self.expensesTableViewCell?.bottomCurveView.layer.borderColor, UIColor.darkGray.cgColor)
    }
    func testSetDataIncomeTableCell() throws {
        self.expensesTableViewCell?.expenses = self.mockData()?.first
        XCTAssertNotNil(self.expensesTableViewCell?.amountLabel.text)
    }
    func testSetDataExpensesTableCell() throws {
        self.expensesTableViewCell?.expenses = self.mockData()?.last
        XCTAssertNotNil(self.expensesTableViewCell?.amountLabel.text)
    }
    func mockData() -> [Expenses]? {
        let ad = UIApplication.shared.delegate as! AppDelegate
        let contextAbove = ad.persistentContainer.viewContext
        var dataArray: [Expenses]? = []
        for i in 1...3 {
            let expenses = Expenses(context: contextAbove)
            expenses.amount =  30.00 + Double(i)
            expenses.title =  "salary"
            expenses.transactionType =  i == 1 ? ExpenseAmountType.income.rawValue : ExpenseAmountType.expenses.rawValue
            expenses.createdAt = Date()
            expenses.updatedOn = Date()
            dataArray?.append(expenses)
        }
        return dataArray
    }
    
}
