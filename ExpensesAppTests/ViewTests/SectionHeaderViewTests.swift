//
//  SectionHeaderViewTests.swift
//  ExpensesAppTests
//
//  Created by Mohammed1 Shoeb on 04/12/21.
//

import XCTest
@testable import ExpensesApp

class SectionHeaderViewTests: XCTestCase {
    private var sectionHeaderView: SectionHeaderView?
    
    override func setUpWithError() throws {
        let bundle = Bundle(for: SectionHeaderView.self)
        guard let view = bundle.loadNibNamed("SectionHeaderView", owner: nil)?.first as? UIView else {
            return XCTFail("SectionHeaderView nib did not contain a View")
        }
        sectionHeaderView = view as? SectionHeaderView
      
    }

    override func tearDownWithError() throws {
        self.sectionHeaderView = nil
    }
    func testXib() {
        XCTAssertNotNil(self.sectionHeaderView?.awakeFromNib())
    }
    func testSectionHeaderViewIBOutlet() {
        do {
            _ = try XCTUnwrap(self.sectionHeaderView?.sctionHeaderContainerView, "IBOutlet of sctionHeaderContainerView is attached ")
            _ = try XCTUnwrap(self.sectionHeaderView?.sectionTitleLabel, "IBOutlet of sectionTitleLabel is attached ")
        } catch {}
    }
    func testSetDefaultDesign() {
        self.sectionHeaderView?.setDefaultDesign()
        XCTAssertEqual(self.sectionHeaderView?.sctionHeaderContainerView.layer.borderWidth, 1)
        XCTAssertEqual(self.sectionHeaderView?.sctionHeaderContainerView.layer.borderColor, UIColor.darkGray.cgColor)
        XCTAssertEqual(self.sectionHeaderView?.sctionHeaderContainerView.layer.cornerRadius, 10)
    }
    func testSetupData() throws {
        self.sectionHeaderView?.setupData(transactionDate: Date(), expensesViewModel: ExpensesViewModel(viewController: ViewController()))
        XCTAssertNotNil(self.sectionHeaderView?.sectionTitleLabel.text)
    }

}
