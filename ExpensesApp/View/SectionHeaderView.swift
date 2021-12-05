//
//  SectionHeaderView.swift
//  ExpensesApp
//
//  Created by Mohammed1 Shoeb on 27/11/21.
//

import UIKit

class SectionHeaderView: UIView {
    @IBOutlet weak var sctionHeaderContainerView: UIView!
    @IBOutlet weak var sectionTitleLabel: UILabel!
    
    func setDefaultDesign() {
        self.clipsToBounds = true
        self.sctionHeaderContainerView.layer.borderColor = UIColor.darkGray.cgColor
        self.sctionHeaderContainerView.layer.borderWidth = 1
        self.sctionHeaderContainerView.layer.cornerRadius = 10
        self.sctionHeaderContainerView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    }
    func setupData(transactionDate: Date?, expensesViewModel: ExpensesViewModel?) {
        guard let createdAt = transactionDate else { return }
        self.sectionTitleLabel.text = expensesViewModel?.getDateFormatter(date: createdAt, format: "dd'\(expensesViewModel?.daySuffix(createdAt: createdAt) ?? "")' MMMM, yyyy")
        
    }
    
}
