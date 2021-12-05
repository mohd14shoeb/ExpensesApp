//
//  CardViewTests.swift
//  ExpensesAppTests
//
//  Created by Mohammed1 Shoeb on 03/12/21.
//

import XCTest
@testable import ExpensesApp

class CardViewTests: XCTestCase {
    private var cardView: CardView?
    
    override func setUpWithError() throws {
        let bundle = Bundle(for: CardView.self)
        guard let view = bundle.loadNibNamed("CardView", owner: nil)?.first as? UIView else {
            return XCTFail("CardView nib did not contain a View")
        }
        cardView = view as? CardView
    }
    
    override func tearDownWithError() throws {
        self.cardView = nil
    }
    func testXib() {
        XCTAssertNotNil(self.cardView?.awakeFromNib())
    }
    func testCardViewIBOutlet() {
        do {
            _ = try XCTUnwrap(self.cardView?.balanceAmountLabel, "IBOutlet of balanceAmountLabel is attached ")
            _ = try XCTUnwrap(self.cardView?.balanceTextLabel, "IBOutlet of balanceTextLabel is attached ")
            _ = try XCTUnwrap(self.cardView?.incomeAmountLabel, "IBOutlet of incomeAmountLabel is attached ")
            _ = try XCTUnwrap(self.cardView?.incomeTextLabel, "IBOutlet of incomeTextLabel is attached ")
            _ = try XCTUnwrap(self.cardView?.expensesAmountLabel, "IBOutlet of expensesAmountLabel is attached ")
            _ = try XCTUnwrap(self.cardView?.expensesTextLabel, "IBOutlet of expensesTextLabel is attached ")
            _ = try XCTUnwrap(self.cardView?.linearProgressBar, "IBOutlet of linearProgressBar is attached ")
    
        } catch {}
        
    }
    func testDefaultDesign() {
        self.cardView?.defaultDesign()
        XCTAssertNotNil(self.cardView?.layer.cornerRadius)
        XCTAssertNotNil(self.cardView?.layer.borderWidth)
        XCTAssertNotNil(self.cardView?.layer.borderColor)
    }
    
    func testUpdateCardContent() throws {
        self.cardView?.updateCardContent(balance: "230.0", income: "450.0", expenses: "340.0")
        XCTAssertNotNil(self.cardView?.incomeAmountLabel.text)
        XCTAssertNotNil(self.cardView?.expensesAmountLabel.text)
        XCTAssertNotNil(self.cardView?.balanceAmountLabel.text)
    }
    func testCalculateProgressBar() {
        self.cardView?.calculateProgressBar(balance: "230.0", income: "4450.0", expenses: "340.0")
        XCTAssertNotNil(self.cardView?.linearProgressBar.progressValue)
    }
    
}
