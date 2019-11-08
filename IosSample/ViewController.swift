//
//  ViewController.swift
//  IosSample
//
//  Created by yadhukrishnan E on 29/10/19.
//  Copyright © 2019 AYA. All rights reserved.
//
import AVFoundation
import UIKit

class ViewController: UIViewController {
    
    private static let NOT_A_NUMBER = "Not a number"
    
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var btnMinus: UIButton!
    @IBOutlet weak var btnDivide: UIButton!
    @IBOutlet weak var btnClear: UIButton!
    @IBOutlet weak var btnSign: UIButton!
    @IBOutlet weak var btnMode: UIButton!
    @IBOutlet weak var btnMultiply: UIButton!
    
    var leftHandSide = ""
    var rightHandSide = ""
    var operatorSign = ""
    var prevChar = ""
    
    @IBOutlet weak var btnResult: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func onAllClearClicked(_ sender: Any) {
        var tempResult = getResult()
        if tempResult != "0" || TextUtil.isNumber(text: tempResult) {
           let index = tempResult.index(tempResult.endIndex, offsetBy: -1)
            tempResult.remove(at: index)
            btnResult.setTitle(tempResult, for: .normal)
        }
        
        if tempResult.isEmpty || tempResult == "0" || !TextUtil.isNumber(text: tempResult) {
            prepForNextOpt()
            setToDefault()
            changeClearState(false)
        }
    }
    
    
    @IBAction func onSignChangeClicked(_ sender: Any) {
        var text: String  = getResult()
        if text == "0" || !TextUtil.isNumber(text: text) {
            SoundUtil.error()
            return
        }
        
        if text.contains("-") {
            text.remove(at: text.startIndex)
        } else {
            text.insert("-", at: text.startIndex)
        }
        
        setResult(text: text)
        SoundUtil.keyPressed()
    }
    
    
    @IBAction func onOperatorClicked(_ sender: Any) {
        let btn = sender as! UIButton
        let operation = btn.currentTitle!
        let text = getResult()
        if operation == "%" {
            if text != "0" && TextUtil.isNumber(text: text) {
                SoundUtil.keyPressed()
                handlePercentage()
            } else {
                SoundUtil.error()
            }
        } else {
            if !operatorSign.isEmpty {
                setToNormal()
                if text == "0" || TextUtil.isNumber(text: prevChar) {
                    rightHandSide = getResult()
                }
            } else {
                let result = getResult()
                
                if result == "0" || !TextUtil.isNumber(text: result) {
                    SoundUtil.error()
                    return
                }
                
                leftHandSide = result
            }
            
         
            if isAbleToProduceResult() {
                result()
            }
            
            SoundUtil.keyPressed()
            changeToState(button: btn, state: .highlighted)
            operatorSign = operation
            
            prevChar = operatorSign
            
            print("onOperatorClicked leftHandSide \(leftHandSide) \(operatorSign) \(rightHandSide)")
        }
    }
    
    func isAbleToProduceResult() -> Bool {
        return !(leftHandSide.isEmpty || !TextUtil.isNumber(text: leftHandSide) || rightHandSide.isEmpty || !TextUtil.isNumber(text: rightHandSide)  || operatorSign.isEmpty)
    }
    
    @IBAction func onEqualToClicked(_ sender: Any) {
        
        if !TextUtil.isNumber(text: prevChar) {
            SoundUtil.error()
            return
        }
        
        rightHandSide = getResult()
        
        if !isAbleToProduceResult() {
            SoundUtil.error()
            return
        }
        
        SoundUtil.keyPressed()
        
        result()
        setToNormal()
    }
    
    @IBAction func onPointClicked(_ sender: Any) {
    
        if !TextUtil.isNumber(text: prevChar) {
            setToDefault()
        }
        
        let text = btnResult.currentTitle!
        if  text.contains(".") {
            SoundUtil.error()
            return
        }
        
        loadValue(".")
    }
    
    
    @IBAction func onNumberClicked(_ sender: Any) {
        let btn = sender as! UIButton
        
        if !TextUtil.isNumber(text: prevChar) {
            setToDefault()
        }
        
        SoundUtil.keyPressed()
        prevChar = btn.currentTitle!
        loadValue(prevChar)
    }
    
    func loadValue(_ value: String) {
        var currentValue = getResult()
        if currentValue == "0" || currentValue == ViewController.NOT_A_NUMBER {
            currentValue = ""
        }
        
        currentValue += value
        btnResult.setTitle(currentValue, for: .normal)
        
        print(btnResult.currentTitle!)
        
        changeClearState(true)
    }
    
    
    func result()  {
        
        let leftValue = Float(leftHandSide)!
        let rightValue = Float(rightHandSide)!
        var resultValue: String
        
        print("result leftHandSide = \(leftHandSide) \(leftValue)")
        print("result rightHandSide = \(rightHandSide) \(rightValue)")
        
        switch operatorSign {
        case "+":
            resultValue = "\(leftValue + rightValue)"
        case "-":
            resultValue = "\(leftValue - rightValue)"
        case "*":
            resultValue = "\(leftValue * rightValue)"
        case "/":
            if rightValue == 0 {
                notANumber()
                return
            }
            resultValue = "\(leftValue / rightValue)"
        default:
            resultValue = ""
        }
        
        if !leftHandSide.contains(".") && !rightHandSide.contains(".") {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            resultValue = formatter.string(from: NSNumber(value: Double(resultValue)!)) ?? "0"
            resultValue = resultValue.replacingOccurrences(of: ",", with: "")
        }
        
        btnResult.setTitle(resultValue, for: .normal)
        
        prepForNextOpt()
        
        leftHandSide = getResult()
    }
    
    func handlePercentage() {
        let result = Double(btnResult.currentTitle!)!
        leftHandSide = "\(result/100)"
        btnResult.setTitle(leftHandSide, for: .normal)
        
        operatorSign = ""
        rightHandSide = ""
        setToNormal()
    }
}




extension ViewController {
    
    func setToDefault() {
        btnResult.setTitle("0", for: .normal)
    }
    
    func setResult(text: String) {
        btnResult.setTitle(text, for: .normal)
    }
    func getResult() -> String {
        return btnResult.currentTitle!
    }
    
    func setToNormal() {
        changeToState(button: btnAdd, state: .normal)
        changeToState(button: btnMinus, state: .normal)
        changeToState(button: btnMultiply, state: .normal)
        changeToState(button: btnDivide, state: .normal)
        changeToState(button: btnAdd, state: .normal)
    }
    
    
    func changeToState(button btn: UIButton, state: UIControl.State) {
        if state == .normal {
            btn.backgroundColor = UIColor.systemOrange
            btn.setTitleColor(UIColor.white, for: .normal)
        } else {
            btn.backgroundColor = UIColor.gray
            btn.setTitleColor(UIColor.black, for: .normal)
        }
    }
    
    
    func changeClearState(_ state: Bool) {
        if state {
            btnClear.setTitle("C", for: .normal)
        } else {
            btnClear.setTitle("AC", for: .normal)
            setToNormal()
        }
    }
    
    
    func notANumber() {
        btnResult.setTitle(ViewController.NOT_A_NUMBER, for: .normal)
        prepForNextOpt()
    }
    
    func prepForNextOpt() {
        leftHandSide = ""
        operatorSign = ""
        rightHandSide = ""
    }
    
}
