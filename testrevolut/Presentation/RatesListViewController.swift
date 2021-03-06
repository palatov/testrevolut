//
//  RatesListViewController.swift
//  testrevolut
//
//  Created by Nikita Timonin on 13/10/2018.
//  Copyright © 2018 Nikita Timonin. All rights reserved.
//

import UIKit


final class RatesListViewController: UIViewController {
    
    // MARK: - Types
    
    enum Constants {
        static let cellHeight: CGFloat = 90
    }
    
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var tableView: UITableView!
    
    
    // MARK: - Private properties
    
    private var ratesListViewModel: RatesListViewModel!
    private var timer: Timer!
    
    
    // MARK: - Lifecyle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Rates"
        setupUI()
        ratesListViewModel = RatesListViewModel()
        startUpdatingRates()
    }
    
    
    // MARK: - UIScrollViewDelegate
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        view.endEditing(false)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y == 0 {
            let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! RateTableViewCell
            cell.textField.becomeFirstResponder()
        }
    }
    
    
    // MARK: - Private methods
    
    private func startUpdatingRates() {
        timer = Timer.scheduledTimer(
            timeInterval: 1.0,
            target: self,
            selector: #selector(updateRates),
            userInfo: nil,
            repeats: true)
        RunLoop.current.add(timer, forMode: .common)
        timer.fire()
    }
    
    @objc private func updateRates() {
        let tableViewNeedsReload = ratesListViewModel.rates.isEmpty
        ratesListViewModel.obtainRates { [weak self] in
            guard tableViewNeedsReload else { return }
            self?.tableView.reloadData()
        }
    }
    
    private func setupUI() {
        tableView.register(
            UINib(nibName: RateTableViewCell.reusableIdentifier, bundle: nil),
            forCellReuseIdentifier: RateTableViewCell.reusableIdentifier)
        tableView.separatorStyle = .none
        tableView.keyboardDismissMode = .onDrag
        tableView.dataSource = self
        tableView.delegate = self
    }
    
   
    // MARK: - Deinit
    
    deinit {
        timer.invalidate()
        timer = nil
    }
}


extension RatesListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.cellHeight
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (ratesListViewModel?.rates ?? []).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: RateTableViewCell.reusableIdentifier,
            for: indexPath) as! RateTableViewCell
        cell.rate = ratesListViewModel?.rates[indexPath.row]
        cell.inputHandler = { [weak self] (input) in
            self?.ratesListViewModel.updateBaseAmmount(newAmmount: input)
        }
        return cell
    }
    
}


extension RatesListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! RateTableViewCell
      
        guard let currency = cell.rate else { return }
        ratesListViewModel.baseRate = currency
        
        let zeroIndexPath = IndexPath(row: 0, section: 0)
        tableView.moveRow(at: indexPath, to: zeroIndexPath)
        
        if let topIsVisible = tableView.indexPathsForVisibleRows?.contains(zeroIndexPath), topIsVisible {
            cell.textField.becomeFirstResponder()
        } else {
            tableView.scrollToRow(at: zeroIndexPath, at: .top, animated: true)
        }
    }
    
}

