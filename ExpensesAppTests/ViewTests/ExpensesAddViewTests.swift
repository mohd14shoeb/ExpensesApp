//
//  ExpensesAddViewTests.swift
//  ExpensesAppTests
//
//  Created by Mohammed1 Shoeb on 04/12/21.
//

import XCTest
@testable import ExpensesApp

class ExpensesAddViewTests: XCTestCase {
    private var expensesAddView: ExpensesAddView?
    var tableViewTest: UITableView?
    
    override func setUpWithError() throws {
        let bundle = Bundle(for: ExpensesAddView.self)
        guard let view = bundle.loadNibNamed("ExpensesAddView", owner: nil)?.first as? UIView else {
            return XCTFail("ExpensesAddView nib did not contain a View")
        }
        expensesAddView = view as? ExpensesAddView
        tableViewTest = self.expensesAddView?.tableView
    }

    override func tearDownWithError() throws {
        self.expensesAddView?.dataSource.removeAll()
        self.expensesAddView?.transparentView.removeFromSuperview()
        self.expensesAddView = nil
    }
    func testXib() {
        XCTAssertNotNil(self.expensesAddView?.awakeFromNib())
    }
    func testExpensesAddViewIBOutlet() {
        do {
            _ = try XCTUnwrap(self.expensesAddView?.containerView, "IBOutlet of containerView is attached ")
            _ = try XCTUnwrap(self.expensesAddView?.transactionTypeTextField, "IBOutlet of transactionTypeTextField is attached ")
            _ = try XCTUnwrap(self.expensesAddView?.descriptionTextField, "IBOutlet of descriptionTextField is attached ")
            _ = try XCTUnwrap(self.expensesAddView?.transactionAmount, "IBOutlet of transactionAmount is attached ")
           _ = try XCTUnwrap(self.expensesAddView?.addButton, "IBOutlet of addButton is attached ")
    
        } catch {}
    }
    func testDefaultDesign() {
        self.expensesAddView?.defaultDesign()
        XCTAssertEqual(self.expensesAddView?.containerView?.layer.cornerRadius, 10)
        XCTAssertEqual(self.expensesAddView?.transactionTypeTextField.layer.borderWidth, 1)
        XCTAssertEqual(self.expensesAddView?.transactionTypeTextField.layer.borderColor, UIColor.darkGray.cgColor)
        XCTAssertEqual(self.expensesAddView?.transactionTypeTextField.layer.cornerRadius, 6)
        XCTAssertEqual(self.expensesAddView?.transactionTypeTextField.borderStyle, UITextField.BorderStyle.roundedRect)
        
        XCTAssertEqual(self.expensesAddView?.descriptionTextField.layer.borderWidth, 1)
        XCTAssertEqual(self.expensesAddView?.descriptionTextField.layer.borderColor, UIColor.darkGray.cgColor)
        XCTAssertEqual(self.expensesAddView?.descriptionTextField.layer.cornerRadius, 6)
        XCTAssertEqual(self.expensesAddView?.descriptionTextField.borderStyle, UITextField.BorderStyle.roundedRect)
        
        XCTAssertEqual(self.expensesAddView?.transactionAmount.layer.borderWidth, 1)
        XCTAssertEqual(self.expensesAddView?.transactionAmount.layer.borderColor, UIColor.darkGray.cgColor)
        XCTAssertEqual(self.expensesAddView?.transactionAmount.layer.cornerRadius, 6)
        XCTAssertEqual(self.expensesAddView?.transactionAmount.borderStyle, UITextField.BorderStyle.roundedRect)
        
        XCTAssertEqual(self.expensesAddView?.addButton.layer.borderWidth, 1)
        XCTAssertEqual(self.expensesAddView?.addButton.layer.borderColor, UIColor.darkGray.cgColor)
        XCTAssertEqual(self.expensesAddView?.addButton.layer.cornerRadius, 6)
        
    }
    func testAddTransactionButton() {
        XCTAssertNotNil(self.expensesAddView?.addTransactionButton(UIButton()))
    }
    func testOptionActionButton() {
        XCTAssertNotNil(self.expensesAddView?.optionAction())
    }
    func testaddAmountAction() {
        self.expensesAddView?.transactionAmount.text = "10.0"
        self.expensesAddView?.addAmountAction()
        XCTAssertEqual(self.expensesAddView?.transactionAmount.text, "11.0")
        
    }
    func testDeducteAmountAction() throws {
        self.expensesAddView?.transactionAmount.text = "10.0"
        self.expensesAddView?.deducteAmountAction()
        XCTAssertEqual(self.expensesAddView?.transactionAmount.text, "9.0")
    }
    func testZeroDeducteAmountAction() throws {
        self.expensesAddView?.transactionAmount.text = "0.0"
        self.expensesAddView?.deducteAmountAction()
        XCTAssertEqual(self.expensesAddView?.transactionAmount.text, "")
    }
    func testSetDropDownIcon() {
        self.expensesAddView?.setDropDownIcon(UIImage(named: "arrow-down.png"))
        XCTAssertNotNil(self.expensesAddView?.transactionTypeTextField.rightView)
        XCTAssertNotNil(self.expensesAddView?.transactionTypeTextField.rightViewMode)
        
    }
    func testRemoveTransparentView() {
        self.expensesAddView?.removeTransparentView()
        XCTAssertEqual(self.expensesAddView?.transparentView.alpha, 0)
    }
    func testTableViewNumberOfRowsNotNil() {
        if let expeseArray = self.mockData(), expeseArray.isEmpty == false {
            self.expensesAddView?.dataSource = expeseArray
            let rows = expensesAddView?.tableView(tableViewTest ?? UITableView(), numberOfRowsInSection: 0)
        XCTAssertEqual(rows, 2)
        }
    }
    func testHeightForRowAt() {
        if let expeseArray = self.mockData(), expeseArray.isEmpty == false {
            self.expensesAddView?.dataSource = expeseArray
            let rows = expensesAddView?.tableView(tableViewTest ?? UITableView(), heightForRowAt: IndexPath(row: 0, section: 0))
        XCTAssertEqual(rows, 50)
        }
    }
    func testCellForRowAtIndexPathWithSection() {
        XCTAssertTrue(((self.expensesAddView?.responds(to: #selector(self.expensesAddView?.tableView(_:cellForRowAt:)))) != nil))
    }
    func testDidSelectRow() {
        if let expeseArray = self.mockData(), expeseArray.isEmpty == false {
            self.expensesAddView?.dataSource = expeseArray
        XCTAssertNotNil(expensesAddView?.tableView(tableViewTest ?? UITableView(), didSelectRowAt: IndexPath(row: 0, section: 0)))
        }
    }
    func testTextFieldShouldBeginEditing() {
        XCTAssertTrue(((self.expensesAddView?.responds(to: #selector(self.expensesAddView?.transactionAmount.delegate?.textFieldShouldBeginEditing(_:)))) != nil))
    }
    
    func mockData() -> [String]? {
        let dataSource = ["Expenses", "Income"]
        return dataSource
    }

}
