//
//  ViewController.swift
//  ExpensesApp
//
//  Created by Mohammed1 Shoeb on 26/11/21.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var cardContainerView: UIView!
    @IBOutlet weak var listTableView: UITableView!
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var errorTitleLabel: UILabel!
    @IBOutlet weak var errorDescriptionLabel: UILabel!
    var addRoundButton = UIButton()
    var expensesAddView: ExpensesAddView?
    var cardView: CardView?
    var windowContainerView: UIView?
    var expensesViewModel: ExpensesViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addCardView()
        self.setupTableView()
        self.addExpensesButtonDesign()
        self.expensesViewModel = ExpensesViewModel(viewController: self)
        self.balanceCalculate()
        
    }
    func balanceCalculate() {
        expensesViewModel?.getAllExpensesList()
        let expensesDetails = expensesViewModel?.getTotalBalance(expenseData: self.expensesViewModel?.expensesList)
        self.cardView?.updateCardContent(balance: expensesDetails?.balance, income: expensesDetails?.income, expenses: expensesDetails?.expenses)
        self.displayNoTransationMessage()
    }
    func displayNoTransationMessage() {
        var isRecordNotFound = true
        let filteredArray = expensesViewModel?.expensesList.map { $0.filter { !$0.isEmpty }}
        if filteredArray?.isEmpty == false || filteredArray?.count ?? 0 > 0 {
            isRecordNotFound = false
        }
        expensesViewModel?.expensesList = filteredArray
        self.errorLabelDisplay(errorTitle: "No Transaction Yet!", message: "Add a transaction and it will show up here", isErrorDisplay: isRecordNotFound)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.cardView?.frame = CGRect(x:16, y: 1, width: view.frame.width - 32, height: 130)
        self.addFloatingButton()
    }
    func addFloatingButton() {
        addRoundButton.layer.cornerRadius = addRoundButton.layer.frame.size.width/2
        addRoundButton.layer.borderWidth = 2
        addRoundButton.layer.borderColor = UIColor.lightGray.cgColor
        addRoundButton.backgroundColor = UIColor.blue.withAlphaComponent(0.7)
        addRoundButton.clipsToBounds = true
        addRoundButton.setImage(UIImage(named:"Frame.png"), for: .normal)
        addRoundButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addRoundButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
            addRoundButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -53),
            addRoundButton.widthAnchor.constraint(equalToConstant: 50),
            addRoundButton.heightAnchor.constraint(equalToConstant: 50)])
    }
    func addCardView() {
        if self.cardView != nil {
            self.cardView?.removeFromSuperview()
            self.cardView = nil
        }
            self.cardView = Bundle.main.loadNibNamed("CardView", owner:
                                                        self, options: nil)?.first as? CardView
            self.cardContainerView.addSubview(self.cardView ?? UIView())
            self.cardView?.defaultDesign()
            self.cardView?.frame = CGRect(x:16, y: 1, width: self.view.frame.width - 32, height: 130)
      
    }
    func setupTableView() {
        self.listTableView.tableFooterView = UIView()
        self.listTableView.separatorColor = UIColor.clear
        self.listTableView.rowHeight = UITableView.automaticDimension
        self.listTableView.estimatedRowHeight = 44
        self.listTableView.register(UINib(nibName: "ExpensesTableViewCell", bundle: nil), forCellReuseIdentifier: "ExpensesTableViewCell")
    }
    func addExpensesButtonDesign() {
        self.addRoundButton = UIButton(type: .custom)
        self.addRoundButton.setTitleColor(UIColor.orange, for: .normal)
        self.addRoundButton.addTarget(self, action: #selector(addExpensesButtonClick(_:)), for: UIControl.Event.touchUpInside)
        self.view.addSubview(addRoundButton)
    }
    func errorLabelDisplay(errorTitle: String?, message: String?, isErrorDisplay: Bool) {
        if isErrorDisplay {
            self.errorTitleLabel.text = errorTitle
            self.errorDescriptionLabel.text = message
            self.listTableView.isHidden = true
            self.cardContainerView.isHidden = true
            self.errorView.isHidden = false
        } else {
            self.errorView.isHidden = true
            self.listTableView.isHidden = false
            self.cardContainerView.isHidden = false
        }
    }
    func addExpensesPopUpView() {
        self.removeExpensesPopUpView()
      //  DispatchQueue.main.async { [weak self] in
        self.windowContainerView = UIView(frame:  UIScreen.main.bounds)
            self.windowContainerView?.backgroundColor = .lightGray.withAlphaComponent(0.6)
            self.expensesAddView = Bundle.main.loadNibNamed("ExpensesAddView", owner:
                                                                self, options: nil)?.first as? ExpensesAddView
        self.expensesAddView?.delegate = self
            self.expensesAddView?.defaultDesign()
            self.expensesAddView?.frame = CGRect(x:8, y: (UIScreen.main.bounds.height - 280)/2, width: UIScreen.main.bounds.width - 16, height: 280)
            self.windowContainerView?.addSubview(self.expensesAddView ?? UIView())
            if let window = UIApplication.shared.currentWindow {
                window.addSubview(self.windowContainerView ?? UIView())
            }
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.executeTap))
            tap.delegate = self
            tap.numberOfTapsRequired = 1
            self.windowContainerView?.isUserInteractionEnabled = true
            self.windowContainerView?.addGestureRecognizer(tap)
            tap.cancelsTouchesInView = false
     //   }
    }
    func removeExpensesPopUpView() {
        if self.expensesAddView != nil {
            self.expensesAddView?.removeFromSuperview()
            self.expensesAddView = nil
            self.windowContainerView?.removeFromSuperview()
            self.windowContainerView = nil
        }
    }
    @IBAction func addExpensesButtonClick(_ sender: UIButton){
        self.addExpensesPopUpView()
    }
}
extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        var headerHeight = CGFloat.leastNormalMagnitude
        if (self.getSectionHeaderViewContent(with: section)) == true {
            headerHeight = 44.0
        }
        return headerHeight
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return expensesViewModel?.expensesList?.count ?? 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return expensesViewModel?.expensesList?[section].count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExpensesTableViewCell", for: indexPath) as! ExpensesTableViewCell
        cell.selectionStyle = .none
        let sectionArray = expensesViewModel?.expensesList?[indexPath.section]
        cell.reloadCellDesign(indexPath: indexPath, sectionArray: sectionArray)
        cell.expenses = expensesViewModel?.expensesList?[indexPath.section][indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let expensesSectionArray = expensesViewModel?.expensesList?[indexPath.section] else { return }
            let expenses = expensesSectionArray[indexPath.row] as Expenses
            listTableView.beginUpdates()
            self.updateBalanceCardAfterDelete(expenses: expenses)
            ExpensesViewModel.databaseHandler.delete(object: expenses)
            expensesViewModel?.expensesList?[indexPath.section].remove(at: indexPath.row)
            let indexPath = IndexPath(row: indexPath.row, section: indexPath.section)
            if expensesViewModel?.expensesList?[indexPath.section].count == 0 {
                expensesViewModel?.expensesList?.remove(at: indexPath.section)
                let indexSet = IndexSet(arrayLiteral: indexPath.section)
                listTableView.deleteSections(indexSet, with: .fade)
            } else {
                listTableView.deleteRows(at: [indexPath], with: .fade)
            }
            listTableView.endUpdates()
            self.displayNoTransationMessage()
        }
    }
    func updateBalanceCardAfterDelete(expenses: Expenses?) {
        let expensesDetails = self.expensesViewModel?.updateBalanceCard(balanceAmountText: self.cardView?.balanceAmountLabel.text, incomeAmountText: self.cardView?.incomeAmountLabel.text, expensesAmountText: self.cardView?.expensesAmountLabel.text, expenses: expenses)
        self.cardView?.updateCardContent(balance: expensesDetails?.balance, income: expensesDetails?.income, expenses: expensesDetails?.expenses)
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if (self.getSectionHeaderViewContent(with: section)) == true {
            return self.getSectionHeaderView(with: section)
        }
        return nil
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("viewcontroller didSelectRowAt \(String(describing: expensesViewModel?.expensesList?[indexPath.section][indexPath.row]))")
    }
    func getSectionHeaderView(with section: Int) -> UIView? {
        let headerView = Bundle.main.loadNibNamed("SectionHeaderView", owner: self, options: nil)?[0] as? SectionHeaderView
        headerView?.setDefaultDesign()
        headerView?.setupData(transactionDate: expensesViewModel?.expensesList?[section].first?.createdAt, expensesViewModel: self.expensesViewModel)
        return headerView
    }
    func getSectionHeaderViewContent(with section: Int) -> Bool {
        if let expensesArray = expensesViewModel?.expensesList?[section], expensesArray.isEmpty == false {
            return true
        }
        return false
    }
}
extension ViewController: ExpensesAddViewdDelegate, UIGestureRecognizerDelegate {
    
    func addTransactionDetails() {
        if let message = expensesViewModel?.addNewExpenseRecord(expensesAddView: self.expensesAddView), message.isEmpty == false  {
            self.showSimpleAlert(message: message)
            return
            
        }
        removeExpensesPopUpView()
        self.balanceCalculate()
        
    }
    @objc func executeTap(tap: UITapGestureRecognizer) {
        let point = tap.location(in: windowContainerView)
        if !((expensesAddView?.frame.contains(point))!) {
            removeExpensesPopUpView()
        }
    }
}
extension ViewController {
    func showSimpleAlert(message: String?) {
        let alert = UIAlertController(title: "Error", message: message,         preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { _ in
            }))
            self.present(alert, animated: true, completion: nil)
        }
}
