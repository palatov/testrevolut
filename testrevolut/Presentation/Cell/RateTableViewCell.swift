//
//  RateTableViewCell.swift
//  testrevolut
//
//  Created by Nikita Timonin on 13/10/2018.
//  Copyright © 2018 Nikita Timonin. All rights reserved.
//

import UIKit


final class RateTableViewCell: UITableViewCell {
    
    static let reusableIdentifier = "RateTableViewCell"
    
    @IBOutlet weak var currencyName: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    var currency: RateViewModel? {
        didSet {
            currencyName.text = currency?.name
            updateTextField()
            setupBindings()
        }
    }
    
    var inputHandler: ((Double) -> Void)?
    
    private var rateObservation: NSKeyValueObservation?
    private var baseAmmountObservation: NSKeyValueObservation?
    
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
        baseAmmountObservation = nil
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
        rateObservation = currency?.observe((\.rate), changeHandler: { [weak self] (_, _) in
            guard let self = self, !self.isSelected else { return }
            self.updateTextFieldWithAnimation()
        })
        
        baseAmmountObservation = currency?.observe((\.baseAmmount), changeHandler: { [weak self] (_, _) in
            guard let self = self, !self.isSelected else { return }
            self.updateTextFieldWithAnimation()
        })
    }
    
    private func updateTextFieldWithAnimation() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            UIView.transition(
                with: self.textField,
                duration: 0.2,
                options: .curveEaseIn,
                animations: { self.updateTextField() },
                completion: nil)
        }
    }
    
    private func updateTextField() {
        guard let currency = currency else { return }
        textField.text = String(format: "%.2f", currency.totalAmmount)
    }
    
}
