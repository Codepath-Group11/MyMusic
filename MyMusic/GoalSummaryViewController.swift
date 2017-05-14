    //
//  GoalSummaryViewController.swift
//  MyMusic
//
//  Created by Arthur Burgin on 5/13/17.
//  Copyright © 2017 Yerneni, Naresh. All rights reserved.
//

import UIKit
import Charts

class GoalSummaryViewController: UIViewController {

    @IBOutlet var activityTitleLabel: UILabel!
    @IBOutlet var motivationSuggestionTitleLabel: UILabel!
    @IBOutlet var motivationSuggestionSummaryLabel: UILabel!
    
    @IBOutlet var barChartView: BarChartView!
    
    weak var axisFormatDelegate: IAxisValueFormatter?

    var caloriePerDay:[calorieChart]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        axisFormatDelegate = self

        // Do any additional setup after loading the view.
        updateChartWithData()

    }
    
    func updateChartWithData() {
        
        var dataEntries: [BarChartDataEntry] = []
        
        
        var i = 0
        for calorie in caloriePerDay! {
            let dataEntry = BarChartDataEntry(x: Double(i), y: Double(calorie.calorieOut))
            dataEntries.append(dataEntry)
            i += 1
        }
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "Calories")
        let chartData = BarChartData(dataSet: chartDataSet)
        barChartView.descriptionText = ""
        barChartView.rightAxis.enabled = false
        barChartView.xAxis.drawGridLinesEnabled = false
        
        chartDataSet.colors = [.red, .yellow, .green]
        
        // Or this way. There are also available .liberty,
        // .pastel, .colorful and .vordiplom color sets.
        chartDataSet.colors = ChartColorTemplates.joyful()
        
        barChartView.animate(yAxisDuration: 1.5, easingOption: .easeInOutQuart)
        barChartView.data = chartData
        
        let xaxis = barChartView.xAxis
        xaxis.valueFormatter = axisFormatDelegate
    }
    
    @IBAction func didTapDone(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK: axisFormatDelegate
extension GoalSummaryViewController: IAxisValueFormatter {
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        
        return "05-08-17"
    }
}
