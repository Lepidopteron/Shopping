//
//  ViewController.swift
//  Shopping
//
//  Created by Tobias Baube on 11.06.17.
//  Copyright © 2017 Tobias Baube. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var currencyButton: UIBarButtonItem!
    let currencyPickerView = UIPickerView(frame:CGRect(x: 0, y: 73, width: 260, height: 94))
    var currencyData: CurrencyData?
    
    private var _currentCurrency: Currency = .USD
    var currentCurrency: Currency {
        get {
            return _currentCurrency
        }
        set {
            if (_currentCurrency != newValue) {
                _currentCurrency = newValue
                self.currencyButton.title = self.currentCurrency.rawValue
                self.tableView.reloadData()
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0)
        self.currencyButton.title = self.currentCurrency.rawValue
        self.currencyPickerView.delegate = self
        self.currencyPickerView.dataSource = self
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupCurrencyData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupCurrencyData() {
        let currencyModelSerializer = CurrencyModelSerializer()
        let urlString = CurrencyData.apiUrlForCurrency(.USD)
        currencyModelSerializer.loadCurrencyFromURL(fromUrl: urlString, { (currencyData) in
            self.currencyData = currencyData
        }) { (currencyData, error) in
            let alertView = UIAlertController(
                title: "Error occured",
                message: "An error occured when loading current currency information. Please make sure you got a working internet connection.",
                preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "Ok", style: .default, handler:nil)
            alertView.addAction(okAction)
            self.present(alertView, animated: true, completion:nil)
            
            self.currencyButton.isEnabled = false
        }
    }
    
    @IBAction func clickedCurrencyButton(_ sender: Any) {
        let alertView = UIAlertController(
            title: "Change your currency",
            message: "\n\n\n\n\n\n\n",
            preferredStyle: .alert)
        self.currencyPickerView.selectRow(Currency.CURRENCIES.index(of: .USD)!, inComponent: 0, animated: false)
        
        alertView.view.addSubview(self.currencyPickerView)
        
        let okAction = UIAlertAction(title: "Ok", style: .default, handler:nil)
        alertView.addAction(okAction)
        present(alertView, animated: true, completion: {
            self.currencyPickerView.frame.size.width = alertView.view.frame.size.width
        })
    }
}

extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return goods.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShoppingTVC", for: indexPath) as! ShoppingTVC
        
        //let object = objects[indexPath.section][indexPath.row]
        let good = goods[indexPath.row]
        var currencyExchangeRate = 1.0
        if let _currencyData = self.currencyData {
            if let _ = _currencyData.quotes {
                currencyExchangeRate = _currencyData.exchangeRate(from: .USD, to: self.currentCurrency)
            }
        }
        let price = good.price * currencyExchangeRate
        cell.nameLabel.text = "\(good.name) - \(String(format: "%.2f", price)) per \(good.unit)"
        cell.amountChanged(cell.amountStepper)
        return cell
    }
}


extension ViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Currency.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Currency.CURRENCIES[row].rawValue
    }
}

extension ViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.currentCurrency = Currency.CURRENCIES[row]
    }
}
