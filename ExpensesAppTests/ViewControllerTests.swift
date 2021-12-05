//
//  ViewControllerTests.swift
//  ExpensesAppTests
//
//  Created by Mohammed1 Shoeb on 02/12/21.
//

import XCTest
@testable import ExpensesApp

class ViewControllerTests: XCTestCase {
    var mainViewController: ViewController?
    var tableViewTest: UITableView?
    override func setUpWithError() throws {
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        guard let viewController = storyBoard.instantiateViewController(withIdentifier: "ViewController") as? ViewController
        else {
            return
        }
        mainViewController = viewController
        mainViewController?.loadViewIfNeeded()
        self.tableViewTest = self.mainViewController?.listTableView
    }

    override func tearDownWithError() throws {
        self.mainViewController?.expensesViewModel?.expensesList?.removeAll()
        mainViewController?.expensesAddView?.removeFromSuperview()
        mainViewController?.windowContainerView?.removeFromSuperview()
        mainViewController?.addRoundButton.removeFromSuperview()
        self.tableViewTest = nil
        self.mainViewController = nil
        
        
    }
   
    func testIBOutletConnections() throws {
        _ = try XCTUnwrap(mainViewController?.cardContainerView, "The cardContainerView is not connected")
        _ = try XCTUnwrap(mainViewController?.listTableView, "The listTableView is not connected")
        _ = try XCTUnwrap(mainViewController?.errorView, "The errorView outlet is not connected")
        _ = try XCTUnwrap(mainViewController?.errorTitleLabel, "The errorTitleLabel outlet is not connected")
        _ = try XCTUnwrap(mainViewController?.errorDescriptionLabel, "The errorDescriptionLabel outlet is not connected")
    }
    func testViewDidLoadNotNil() {
        XCTAssertNotNil(mainViewController?.viewDidLoad())
    }
    func testViewDidLayoutSubviews() {
        XCTAssertNotNil(mainViewController?.viewDidLayoutSubviews())
    }
    
    func testAddFloatingButton() throws {
        self.mainViewController?.addFloatingButton()
        XCTAssertNotNil(mainViewController?.addRoundButton.layer.cornerRadius)
        XCTAssertEqual(mainViewController?.addRoundButton.layer.borderWidth, 2)
        XCTAssertEqual(mainViewController?.addRoundButton.layer.borderColor, UIColor.lightGray.cgColor)
        XCTAssertEqual(mainViewController?.addRoundButton.clipsToBounds, true)
        XCTAssertEqual(mainViewController?.addRoundButton.backgroundColor, UIColor.blue.withAlphaComponent(0.7))
    }
    func testAddCardView() {
        self.mainViewController?.addCardView()
        XCTAssertNotNil(mainViewController?.cardView)
        XCTAssertNotNil(mainViewController?.cardView?.frame)
    }
    func testSetupTableView() {
        self.mainViewController?.setupTableView()
        XCTAssertNotNil(mainViewController?.listTableView.tableFooterView)
        XCTAssertEqual(mainViewController?.listTableView.rowHeight, UITableView.automaticDimension)
        XCTAssertEqual(mainViewController?.listTableView.separatorColor, UIColor.clear)
        XCTAssertEqual(mainViewController?.listTableView.estimatedRowHeight, 44)
        
    }
    func testErrorLabelDisplayTrue() {
        self.mainViewController?.errorLabelDisplay(errorTitle: "Error title", message: "error message", isErrorDisplay: true)
        XCTAssertNotNil( mainViewController?.errorTitleLabel.text)
        XCTAssertNotNil( mainViewController?.errorDescriptionLabel.text)
        XCTAssertEqual(mainViewController?.listTableView.isHidden, true)
        XCTAssertEqual(mainViewController?.cardContainerView.isHidden, true)
        XCTAssertEqual(mainViewController?.errorView.isHidden, false)
    }
    func testErrorLabelDisplayFalse() {
        self.mainViewController?.errorLabelDisplay(errorTitle: "", message: "", isErrorDisplay: false)
        XCTAssertEqual(mainViewController?.listTableView.isHidden, false)
        XCTAssertEqual(mainViewController?.cardContainerView.isHidden, false)
        XCTAssertEqual(mainViewController?.errorView.isHidden, true)
    }
    func testAddExpensesPopUpView() {
        self.mainViewController?.addExpensesPopUpView()
        XCTAssertNotNil( mainViewController?.expensesAddView?.delegate)
        XCTAssertNotNil( mainViewController?.expensesAddView?.frame)

    }
    func testRemoveExpensesPopUpView() {
        mainViewController?.addExpensesPopUpView()
        mainViewController?.removeExpensesPopUpView()
        XCTAssertNil(mainViewController?.expensesAddView)
        XCTAssertNil(mainViewController?.windowContainerView)
    }
    
    func testButtonAction() {
        XCTAssertNotNil(mainViewController?.addExpensesButtonClick(UIButton()))
    }
    
    func testTableViewNumberOfSectionsNotNil() {
        if let expeseArray = self.mockSectionData(), expeseArray.isEmpty == false {
        self.mainViewController?.expensesViewModel?.expensesList = expeseArray
        let sections = mainViewController?.numberOfSections(in: tableViewTest ?? UITableView())
        XCTAssertTrue(sections == 1)
        }
    }
    
    func testTableViewNumberOfRowsNotNil() {
        if let expeseArray = self.mockSectionData(), expeseArray.isEmpty == false {
            self.mainViewController?.expensesViewModel?.expensesList = expeseArray
            let rows = mainViewController?.tableView(tableViewTest ?? UITableView(), numberOfRowsInSection: 0)
        XCTAssertEqual(rows, 8)
        }
    }
    func testCellForRowAtIndexPathWithSection() {
        if let expeseArray = self.mockSectionData(), expeseArray.isEmpty == false {
            self.mainViewController?.expensesViewModel?.expensesList = expeseArray
        let cell = mainViewController?.tableView(tableViewTest ?? UITableView(), cellForRowAt: IndexPath(row: 0, section: 0))
        XCTAssertNotNil(cell as? ExpensesTableViewCell)
        }
    }
    func testDidSelectRow() {
        if let expeseArray = self.mockSectionData(), expeseArray.isEmpty == false {
            self.mainViewController?.expensesViewModel?.expensesList = expeseArray
        XCTAssertNotNil(mainViewController?.tableView(tableViewTest ?? UITableView(), didSelectRowAt: IndexPath(row: 0, section: 0)))
        }
    }
    func testHeightForHeaderInSection() {
        if let expeseArray = self.mockSectionData(), expeseArray.isEmpty == false {
            self.mainViewController?.expensesViewModel?.expensesList = expeseArray
        let headerHeight = mainViewController?.tableView(tableViewTest ?? UITableView(), heightForHeaderInSection: 0)
        XCTAssertTrue(headerHeight == 44.0)
        }
    }
    func testViewHeaderInSection() {
        if let expeseArray = self.mockSectionData(), expeseArray.isEmpty == false {
            self.mainViewController?.expensesViewModel?.expensesList = expeseArray
        let headerView = mainViewController?.tableView(tableViewTest ?? UITableView(), viewForHeaderInSection: 0)
        XCTAssertNotNil(headerView)
        }
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
