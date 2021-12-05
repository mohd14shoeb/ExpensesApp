//
//  ExpensesAddView.swift
//  ExpensesApp
//
//  Created by Mohammed1 Shoeb on 27/11/21.
//

import UIKit

class CellClass: UITableViewCell {}
protocol ExpensesAddViewdDelegate: AnyObject {
    func addTransactionDetails()
}
class ExpensesAddView: UIView {
    @IBOutlet weak var containerView: UIView!
    weak var delegate: ExpensesAddViewdDelegate?
    @IBOutlet weak var transactionTypeTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var transactionAmount: UITextField!
    @IBOutlet weak var addButton: UIButton!
    let transparentView = UIView()
    let tableView = UITableView()
    var dataSource = [String]()
    var amountAdded: Double = 0.0
    
    func defaultDesign() {
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.darkGray.cgColor
        self.containerView.layer.cornerRadius = 10
        self.dataSource = ["Expenses", "Income"]
        tableView.register(CellClass.self, forCellReuseIdentifier: "Cell")
        self.setDropDownIcon(UIImage(named: "arrow-down.png"))
        self.setAddDeducteAmountIcon(UIImage(named: "arrow-down.png"), UIImage(named: "arrow-up.png"))
        transactionTypeTextField.layer.borderWidth = 1
        transactionTypeTextField.layer.cornerRadius = 6
        transactionTypeTextField.layer.borderColor = UIColor.darkGray.cgColor
        transactionTypeTextField.borderStyle = UITextField.BorderStyle.roundedRect
        
        descriptionTextField.layer.borderWidth = 1
        descriptionTextField.layer.cornerRadius = 6
        descriptionTextField.layer.borderColor = UIColor.darkGray.cgColor
        descriptionTextField.borderStyle = UITextField.BorderStyle.roundedRect
        
        transactionAmount.layer.borderWidth = 1
        transactionAmount.layer.cornerRadius = 6
        transactionAmount.layer.borderColor = UIColor.darkGray.cgColor
        transactionAmount.borderStyle = UITextField.BorderStyle.roundedRect
        transactionAmount.text = ""
        
        addButton.layer.borderWidth = 1
        addButton.layer.cornerRadius = 6
        addButton.layer.borderColor = UIColor.darkGray.cgColor
    }
    @IBAction func addTransactionButton(_ sender: Any) {
        self.delegate?.addTransactionDetails()
    }
}

extension ExpensesAddView {
    func setDropDownIcon(_ image: UIImage?) {
        let dropDownView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 34))
        dropDownView.layer.cornerRadius = 6
        let sepratorView = UIView(frame:
                                    CGRect(x: 0, y: 0, width: 1, height: 34))
        sepratorView.backgroundColor = .darkGray
        dropDownView.addSubview(sepratorView)
        let iconButton = UIButton(frame:
                                    CGRect(x: 13, y: 10, width: 15, height: 15))
        iconButton.setImage(image, for: .normal)
        iconButton.addTarget(self, action: #selector(optionAction), for: .touchUpInside)
        dropDownView.addSubview(iconButton)
        dropDownView.backgroundColor = .lightGray.withAlphaComponent(0.7)
        self.transactionTypeTextField.rightView = dropDownView
        self.transactionTypeTextField.rightViewMode = .always
    }
    @objc func optionAction() {
        addTransparentView(frames: transactionTypeTextField.frame)
    }
    func setAddDeducteAmountIcon(_ downImage: UIImage?, _ upImage: UIImage?) {
        let plusMinusView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 34))
        plusMinusView.layer.cornerRadius = 6
        let sepratorView = UIView(frame:
                                    CGRect(x: 0, y: 0, width: 1, height: 34))
        sepratorView.backgroundColor = .darkGray
        plusMinusView.addSubview(sepratorView)
        
        let upIconButton = UIButton(frame:
                                        CGRect(x: 13, y: 1, width: 15, height: 15))
        upIconButton.setImage(upImage, for: .normal)
        upIconButton.addTarget(self, action: #selector(addAmountAction), for: .touchUpInside)
        plusMinusView.addSubview(upIconButton)
        
        let downIconButton = UIButton(frame:
                                        CGRect(x: 13, y: 18, width: 15, height: 15))
        downIconButton.setImage(downImage, for: .normal)
        downIconButton.addTarget(self, action: #selector(deducteAmountAction), for: .touchUpInside)
        plusMinusView.addSubview(downIconButton)
        plusMinusView.backgroundColor = .lightGray.withAlphaComponent(0.7)
        self.transactionAmount.rightView = plusMinusView
        self.transactionAmount.rightViewMode = .always
        
        let currencyView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 34))
        plusMinusView.layer.cornerRadius = 6
        let currencyLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 20, height: 34))
        currencyLabel.layer.cornerRadius = 6
        currencyLabel.textAlignment = .center
        currencyLabel.text = "$"
        currencyView.addSubview(currencyLabel)
        self.transactionAmount.leftView = currencyView
        self.transactionAmount.leftViewMode = .always
    }
    @objc func addAmountAction() {
        amountAdded = Double(transactionAmount.text ?? "0.0") ?? 0.00
        amountAdded = amountAdded + 1
        transactionAmount.text = String(amountAdded)
    }
    @objc func deducteAmountAction() {
        amountAdded = Double(transactionAmount.text ?? "0") ?? 0.00
        if amountAdded > 0 {
            amountAdded = amountAdded - 1
            transactionAmount.text = String(amountAdded)
        } else {
            transactionAmount.text = ""
        }
    }
}
extension ExpensesAddView {
    func addTransparentView(frames: CGRect) {
        transparentView.frame =  containerView?.frame ?? self.frame
        transparentView.layer.cornerRadius = 10
        self.addSubview(transparentView)
        tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: 0)
        tableView.dataSource = self
        tableView.delegate = self
        self.addSubview(tableView)
        tableView.layer.cornerRadius = 5
        
        transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        tableView.reloadData()
        let tapgesture = UITapGestureRecognizer(target: self, action: #selector(removeTransparentView))
        transparentView.addGestureRecognizer(tapgesture)
        tapgesture.numberOfTapsRequired = 1
        transparentView.alpha = 0
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.transparentView.alpha = 0.5
            self.tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height + 1, width: frames.width, height: CGFloat(self.dataSource.count * 50))
        }, completion: nil)
    }
    @objc func removeTransparentView() {
        let frames = transactionTypeTextField.frame
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.transparentView.alpha = 0
            self.tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: 0)
        }, completion: nil)
    }
}
extension ExpensesAddView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = dataSource[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        transactionTypeTextField.text = dataSource[indexPath.row]
        removeTransparentView()
    }
    
}
extension ExpensesAddView: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == self.transactionTypeTextField {
            addTransparentView(frames: transactionTypeTextField.frame)
            return false
        }
        return true
    }
    func textFieldShouldReturn(_ scoreText: UITextField) -> Bool {
        self.endEditing(true)
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == self.transactionAmount {
            guard CharacterSet(charactersIn: ".0123456789").isSuperset(of: CharacterSet(charactersIn: string)) else {
                 return false
             }
             return true
        }
        return true
    }
    
}
extension UIApplication {
    var currentWindow: UIWindow? {
        connectedScenes
        .filter({$0.activationState == .foregroundActive})
        .map({$0 as? UIWindowScene})
        .compactMap({$0})
        .first?.windows
        .filter({$0.isKeyWindow}).first
    }
}
extension UITextField {
    var isEmpty: Bool {
        return text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
    }
}
