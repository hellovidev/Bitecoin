//
//  ViewController.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    fileprivate var coinManager = CoinManager()
    
    @IBOutlet weak var bitecoinLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initDelegates()
        prepareUI()
    }
    
    private func prepareUI() {
        if let selectedCurrency = coinManager.currencyArray.first {
            coinManager.getCoinPrice(for: selectedCurrency)
        }
    }
    
    private func initDelegates() {
        coinManager.delegate = self
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
    }

}

extension ViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinManager.currencyArray.count
    }
    
}

extension ViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        coinManager.currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedCurrency = coinManager.currencyArray[row]
        coinManager.getCoinPrice(for: selectedCurrency)
    }
    
}

extension ViewController: CoinManagerDelegate {
    func didUpdateRate(currency: CurrencyModel) {
        DispatchQueue.main.async { [weak self] in
            self?.bitecoinLabel.text = String(format: "%.3f", currency.rate)
            self?.currencyLabel.text = currency.asset_id_quote
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }

}
