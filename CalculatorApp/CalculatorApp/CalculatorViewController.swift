//
//  ViewController.swift
//  CalculatorApp
//
//  Created by Bruno Augusto Mendes Barreto Alves on 11/07/2017.
//  Copyright © 2017 Bruno Augusto Mendes Barreto Alves. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {
    
    let mathAPI = MathHelper()
    
    @IBOutlet weak var expressionView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //setting offset of TextView
        expressionView.setContentOffset(CGPoint(x: expressionView.contentSize.width, y: expressionView.contentSize.height), animated: false)
        
    }
    
    @IBAction func percentage(_ sender: UIButton) {
        
        do{
            self.expressionView.text = try self.mathAPI.getPercentage(value: self.expressionView.text)
        }catch{
            self.presentAlert(error: "Your Number Format is wrong, please redo it!")
        }
    }
    
    @IBAction func getNumbers(_ sender: UIButton) {
        self.expressionView.text = self.expressionView.text! + String(sender.tag)
    }

    @IBAction func minusOne(_ sender: UIButton) {
        do{
            self.expressionView.text = try self.mathAPI.multiplyByMinusOne(value: self.expressionView.text)
        }catch{
            self.presentAlert(error: "Your Number Format is wrong, please redo it!")
        }    }
    
    @IBAction func cleanScreen(_ sender: Any) {
        self.expressionView.text = ""
    }
    
    @IBAction func getOperators(_ sender: UIButton) {
        switch sender.tag {
        case 12:
            self.expressionView.text = self.expressionView.text! + "+"
        case 13:
            self.expressionView.text = self.expressionView.text! + "-"
        case 14:
            self.expressionView.text = self.expressionView.text! + "*"
        case 15:
            self.expressionView.text = self.expressionView.text! + "/"
        default:
            print("Something wrong")
        }
    }
    
    @IBAction func getDot(_ sender: Any) {
        self.expressionView.text = self.expressionView.text! + "."
    }
    
    @IBAction func calculate(_ sender: Any) {
        
        do{
             self.expressionView.text = try String(self.mathAPI.calculateExpression(expression: self.expressionView.text!))
        }catch let error as ApiErrors{
            switch error {
            case .DivisionByZero:
                self.presentAlert(error: "You can not divide by zero!")
            case .WrongExpressionFormat:
                self.presentAlert(error: "Your format expression is wrong, please redo it!")
            case .WrongNumberFormat:
                self.presentAlert(error: "Your Number Format is wrong, please redo it!")    
            }
            
        }catch {
            self.presentAlert(error: "Something are wrong!")
        }
        
    }

    func presentAlert(error:String){
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

