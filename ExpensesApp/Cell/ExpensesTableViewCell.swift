//
//  ExpensesTableViewCell.swift
//  ExpensesApp
//
//  Created by Mohammed1 Shoeb on 27/11/21.
//

import UIKit

class ExpensesTableViewCell: UITableViewCell {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var bottomCurveView: UIView!
    @IBOutlet weak var leftSepratorView: UIView!
    @IBOutlet weak var rightSepratorView: UIView!
    @IBOutlet weak var bottomSepratorView: UIView!
    @IBOutlet weak var fullrightSepratorView: UIView!
    @IBOutlet weak var fullleftSepratorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.bottomCurveView?.layer.cornerRadius = 10
        self.bottomCurveView?.layer.borderWidth = 1.0
        self.bottomCurveView?.layer.borderColor = UIColor.lightGray.cgColor
    }
    var expenses: Expenses? {
        didSet {
            setupData()
        }
    }
    
    private func setupData() {
        guard let user = expenses else { return }
        self.titleLabel.text = user.title
        if user.transactionType == ExpenseAmountType.income.rawValue {
            self.amountLabel.text =  "$ \(String(format: "%.1f", user.amount))"
        } else {
            self.amountLabel.text =  "-$ \(String(format: "%.1f", user.amount))"
        }
    }
    
    func reloadCellDesign(indexPath: IndexPath, sectionArray: [Expenses]?) {
        if indexPath.row == (sectionArray?.count ?? 0) - 1 {
            self.bottomSepratorView.backgroundColor = UIColor.clear
            self.bottomCurveView.layer.borderColor = UIColor.darkGray.cgColor
            self.fullleftSepratorView.backgroundColor = UIColor.clear
            self.fullrightSepratorView.backgroundColor = UIColor.clear
        } else {
            self.bottomSepratorView.backgroundColor = UIColor.darkGray
            self.bottomCurveView.layer.borderColor = UIColor.clear.cgColor
            self.fullleftSepratorView.backgroundColor = UIColor.darkGray
            self.fullrightSepratorView.backgroundColor = UIColor.darkGray
        }
    }
    
}
