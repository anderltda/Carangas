//
//  AddEditViewController.swift
//  Carangas
//
//  Copyright © 2018 Eric Brito. All rights reserved.
//

import UIKit

class AddEditViewController: UIViewController {

    @IBOutlet weak var tfBrand: UITextField!
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfPrice: UITextField!
    @IBOutlet weak var scGasType: UISegmentedControl!
    @IBOutlet weak var btAddEdit: UIButton!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    var car: Car!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if car != nil {
            tfName.text = car.name
            tfBrand.text = car.brand
            scGasType.selectedSegmentIndex = car.gasType
            tfPrice.text = "\(car.price)"
        }
    }
    
    @IBAction func addEdit(_ sender: UIButton) {
        
        if car == nil {
            car = Car();
        }
        
        car.brand = tfBrand.text!
        car.name = tfName.text!
        car.gasType = scGasType.selectedSegmentIndex
        
        let formatter = NumberFormatter()
        car.price = formatter.number(from: tfPrice.text!)?.intValue ?? 0
        
        var operation = RESTOperation.update
        
        if car._id == nil {
            operation = .save
        }
        
        REST.applyOperation(operation, car: car) { (success) in
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
        }
        
    }
}
