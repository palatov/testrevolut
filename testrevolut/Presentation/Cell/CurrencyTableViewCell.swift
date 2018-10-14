//
//  CurrencyTableViewCell.swift
//  testrevolut
//
//  Created by Nikita Timonin on 13/10/2018.
//  Copyright © 2018 Nikita Timonin. All rights reserved.
//

import UIKit


final class CurrencyTableViewCell: UITableViewCell {
    
    static let reusableIdentifier = "CurrencyTableViewCell"
    
    @IBOutlet weak var currencyName: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    var currency: CurrencyViewModel? {
        didSet {
            currencyName.text = currency?.name
            updateTextField()
            setupBindings()
        }
    }
    
    var inputHandler: ((Double) -> Void)?
    
    private var rateObservation: NSKeyValueObservation?
    private var ammountObsevation: NSKeyValueObservation?
    private var isBaseObservation: NSKeyValueObservation?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        textField.addTarget(self, action: #selector(didChanageValue(_:)), for: .editingChanged)
        textField.isUserInteractionEnabled = false
    }
    
    override func prepareForReuse() {
        currency = nil
        inputHandler = nil
        rateObservation = nil
        ammountObsevation = nil
        isBaseObservation = nil 
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        textField.isUserInteractionEnabled = selected
    }
    
    // MARK: - Private methods
    
    @objc private func didChanageValue(_ textField: UITextField) {
        let text = textField.text ?? "0.0"
        inputHandler?(Double(text) ?? 0)
    }
    
    private func setupBindings() {
        rateObservation = currency?.observe(\.rate) { [weak self] (viewModel, change) in
            guard let self = self, !self.isSelected else { return }
            self.updateTextFieldWithAnimation()
        }
        
        ammountObsevation = currency?.observe(\.ammount) { [weak self] (viewModel, change) in
            guard let self = self, !self.isSelected else { return }
            self.updateTextFieldWithAnimation()
        }
    }
    
    private func updateTextFieldWithAnimation() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            UIView.transition(
                with: self.textField,
                duration: 0.2,
                options: .transitionCrossDissolve,
                animations: { self.updateTextField() },
                completion: nil)
        }
    }
    
    private func updateTextField() {
        guard let currency = currency else { return }
        let rate = currency.rate
        let ammount = Double(currency.ammount)
        let total = rate * ammount
        textField.text = String(format: "%.2f", total)
    }
    
}
