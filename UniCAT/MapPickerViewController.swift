//
//  PickerViewController.swift
//  Deive
//
//  Created by Lye Guang Xing on 8/16/15.
//  Copyright (c) 2015 Sweatshop. All rights reserved.
//

import UIKit

protocol MapRefreshViewDelegate {
    func updateClass(classType: Int)
}

class MapPickerViewController: UIViewController, UIPickerViewDelegate {
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    var refreshDelegate: MapRefreshViewDelegate?
    var type: Int = 0
    var typeName = ["UniCAT", "Convocation"]
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        
        
        pickerView.delegate = self
        pickerView.selectRow(type, inComponent: 0, animated: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.typeName.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return self.typeName[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        refreshDelegate?.updateClass(row)
    }
    
    @IBAction func dismissView(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    /*func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
    let attributedString = NSAttributedString(string: typeName[row], attributes: [NSForegroundColorAttributeName : UIColor(red: 255/255.0, green: 204/255.0, blue: 102/255.0, alpha: 1.0)])
    return attributedString
    }*/
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
