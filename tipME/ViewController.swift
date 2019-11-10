//
//  ViewController.swift
//  tipME
//
//  Created by Derek Chang on 12/17/18.
//  Copyright © 2018 Derek Chang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var tipControl: UISegmentedControl!
    
    @IBOutlet weak var tipSlider: UISlider!
    @IBOutlet weak var sliderTipLabel: UILabel!
    @IBOutlet weak var multPersonTotalLabel: UILabel!
    
    @IBOutlet weak var personCount: UITextField!
    
    @IBOutlet weak var remiander: UILabel!
    
    var totalBill: Float = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        
        //Set the min and max for the slider
        tipSlider.maximumValue = 100
        tipSlider.minimumValue = 0
        
        //Restore previous tip from defaults
        let savedTip = Float(defaults.integer(forKey: "tip"))
        tipSlider.setValue(savedTip, animated: true)
        tipSlider.value = tipSlider.value.rounded()
        sliderTipLabel.text = String(format: "%.0f", tipSlider.value) + "%"
        
        
        //Displays the keyboard on start up
        self.billField.becomeFirstResponder()
        
        
        
    }
    
    //Dismiss keyboard after tapping anywhere not on the keyboard
    @IBAction func onTap(_ sender: Any) {
        view.endEditing(true)
        
    }
    
    @IBAction func swipeLeft(_ sender: Any) {
        performSegue(withIdentifier: "showDetails", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetails"{
            if let destinationVC = segue.destination as? DetailsViewController{
                destinationVC.tip = (Int)(tipSlider.value)
                destinationVC.total = totalBill
            }
        }
    }
    
    
    //Erases the text in the field before they input new value
    @IBAction func touchDownPersonCount(_ sender: Any) {
        personCount.text = ""
    }
    
    //Updates the value of the total when there are multiple people
    func changeNewTotal(){
        let defaults = UserDefaults.standard
        let numPeople =  Float(personCount.text!) ?? 0
        
        let regularTotal = defaults.float(forKey: "total")
        
        
        var dividedTotal = regularTotal / numPeople
        
        dividedTotal = Float(String(format: "%.2f" ,dividedTotal))!
        multPersonTotalLabel.text = String(format: "%.2f", dividedTotal)
        
        
        //If the dividedTotal * numPeople is less than the bill, add 0.01 to the dividel Total to bring it above the bill
        if  dividedTotal * numPeople < regularTotal {
            dividedTotal = dividedTotal + 0.01
            multPersonTotalLabel.text = String(format: "%.2f" , dividedTotal)
        }
        
        //Calculates the extraneous payment
        if dividedTotal * numPeople > regularTotal{
            //Add .0005 to avoid a rounding issue
            let remainderFloat = Float( dividedTotal * numPeople - regularTotal + 0.005) * 100
            let newRemiander = Float(Int(remainderFloat))
            let remainder = String(format: "%.2f" , newRemiander / 100)
            remiander.text =  remainder + "  Extra"
        }
        //If the payment and bill match, then there is no extraneous payment
        else{
            remiander.text = ""
        }
    }
    
    //Triggered when user adds more than one person to bill
    @IBAction func personCountChanged(_ sender: Any) {
        changeNewTotal()
    }
    
    //Adjusts the appropriate values when the tip slider changes
    @IBAction func tipSliderValueChanged(_ sender: Any) {
       
        tipSlider.value = tipSlider.value.rounded()
        
        //update the label next to the slider when the slider changes value
        sliderTipLabel.text = String(format: "%.0f", tipSlider.value) + "%"
        
        createTip()
        changeNewTotal()
        
        //Update the new tip as a default value - i.e. save it
        let defaults = UserDefaults.standard
        defaults.set(tipSlider.value.rounded(), forKey: "tip")
        
    }
    
    /*Takes the default tips, the selected tip, the input value and
    outputs a tip and total*/
    func createTip(){
        let defaults = UserDefaults.standard
        
        let bill = Float(billField.text!) ?? 0
        var tip = Float(0)
        
        //tip slider value used as tip percentage
        tip = bill * tipSlider.value / 100
        
        let total = tip + bill
        
        //Need to truncate extra decimal numbers to fit format 00.00
        let truncatedTotal = Float(String(format: "%.2f", total))
        
        //update defaults - Truncated Total
        defaults.set(truncatedTotal, forKey: "total")
        
        //update labels
        tipLabel.text = String(format: "$%.2f", tip)
        totalLabel.text = String(format: "$%.2f", total)
        
        //update variable storing float
        totalBill = truncatedTotal!
    }
    
    
    //When the value of the bill is changed, the tip and total values are changed and displayed
    @IBAction func calculateTip(_ sender: Any) {
        createTip()
        changeNewTotal()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.navigationBar.isHidden = true
        
        //setup fonts
        billField.font = UIFont(name: "SFProRounded-Thin", size: 70)
        sliderTipLabel.font = UIFont(name: "SFProRounded-Thin", size: 23)
        tipLabel.font = UIFont(name: "SFProRounded-Thin", size: 25)
        totalLabel.font = UIFont(name: "SFProRounded-Thin", size: 50)
        multPersonTotalLabel.font = UIFont(name: "SFProRounded-Thin", size: 25)
        personCount.font = UIFont(name: "SFProRounded-Thin", size: 30)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        print("view did appear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        print("view will disappear")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        print("view did disappear")
    }
}

