//
//  CardView.swift
//  ExpensesApp
//
//  Created by Mohammed1 Shoeb on 26/11/21.
//

import UIKit

class CardView: UIView {
    @IBOutlet weak var cardContainerView: UIView!
    @IBOutlet weak var linearProgressBar: LinearProgressBar!
    @IBOutlet weak var expensesTextLabel: UILabel!
    @IBOutlet weak var expensesAmountLabel: UILabel!
    @IBOutlet weak var incomeTextLabel: UILabel!
    @IBOutlet weak var incomeAmountLabel: UILabel!
    @IBOutlet weak var balanceTextLabel: UILabel!
    @IBOutlet weak var balanceAmountLabel: UILabel!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func defaultDesign() {
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.darkGray.cgColor
        self.linearProgressBar.capType = 1
    }
    func updateCardContent(balance: String?, income: String?, expenses: String?) {
        self.balanceAmountLabel.text = "$ \(balance ?? "")"
        self.expensesAmountLabel.text = "$ \(expenses ?? "")"
        self.incomeAmountLabel.text = "$ \(income ?? "")"
        self.calculateProgressBar(balance: balance, income: income, expenses: expenses)
    }
    func calculateProgressBar(balance: String?, income: String?, expenses: String?) {
        let expenses = Double(expenses ?? "0") ?? 0.0
        let income = Double(income ?? "0") ?? 0.0
        let balance = Double(balance ?? "0") ?? 0.0
        let perCentCGFloat =  CGFloat(100*expenses/(balance + income))
        linearProgressBar.progressValue = perCentCGFloat
    }
    
    
}
