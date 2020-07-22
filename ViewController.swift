//
//  ViewController.swift
//  CalculatorApp
//
//  Created by KUGA on 2020/07/22.
//  Copyright © 2020 kuga. All rights reserved.
//

import UIKit
import Expression

class ViewController: UIViewController {
    
    @IBOutlet weak var formulaLabel: UILabel!
    @IBOutlet weak var answerLable: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // ビューがロードされた時点で式と答えのラベルを空にする
        formulaLabel.text = ""
        answerLable.text = ""
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func inputFormula(_ sender: UIButton) {
        // ボタンが押されたら式を表示する（Cと=以外）
        guard let formulaText = formulaLabel.text else {
            return
        }
        // sender.titleLabel?.text：押されたボタンのTitleを取得
        guard let senderedText = sender.titleLabel?.text else {
            return
        }
        // ボタンを押すたびに結合して式用ラベルに表示
        formulaLabel.text = formulaText + senderedText
    }
    
    @IBAction func clearCalculation(_ sender: UIButton) {
           // クリエイトが押されたら式と答えをクリアする
           formulaLabel.text = ""
           answerLable.text = ""
       }

    @IBAction func calculateAnswer(_ sender: UIButton) {
        // イコールが押されたら式計算を行い、答えを表示
        guard let formulaText = formulaLabel.text else {
            return
        }
        let formula :String = formatFormula(formulaText)
        answerLable.text = evalFormula(formula)
    }

    private func formatFormula(_ formula: String) -> String {
        // 入力された整数には`.0`を追加して小数として評価する
        // また`÷`を`/`に、`×`を`*`に置換する
        let formattedFormula: String = formula.replacingOccurrences(
                of: "(?<=^|[÷×\\+\\-\\(])([0-9]+)(?=[÷×\\+\\-\\)]|$)",
                with: "$1.0",
                options: NSString.CompareOptions.regularExpression,
                range: nil
            ).replacingOccurrences(of: "÷", with: "/").replacingOccurrences(of: "×", with: "*")
        return formattedFormula
    }
    
    private func evalFormula(_ formula: String) -> String {
        do {
            // Expressionで文字列の計算式を評価して答えを求める
            let expression = Expression(formula)
            let answer = try expression.evaluate()
            return formatAnswer(String(answer))
        } catch {
            // 計算式が不当だった場合
            return "式を正しく入力してください"
        }
    }
    
    private func formatAnswer(_ answer: String) -> String {
        // 答えの小数点以下が`.0`だった場合は、`.0`を削除して答えを整数で表示する
        let formattedAnswer: String = answer.replacingOccurrences(
                of: "\\.0$",
                with: "",
                options: NSString.CompareOptions.regularExpression,
                range: nil)
        return formattedAnswer
    }
}

