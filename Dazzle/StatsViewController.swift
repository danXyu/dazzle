//
//  StatsViewController.swift
//  Dazzle
//
//  Created by Dan Xiaoyu Yu on 12/2/15.
//  Copyright © 2015 Corner Innovations LLC. All rights reserved.
//


import Foundation
import UIKit

class LineChartController : UITableViewController, ANDLineChartViewDataSource, ANDLineChartViewDelegate {
  
  @IBOutlet var tabSegmentControl : ADVTabSegmentControl!
  
  @IBOutlet var chartContainer : UIView!
  var lineChartView : ANDLineChartView!
  
  var chartData : DataPointCollection!
  
  var weeklyData : DataPointCollection!
  var yearlyData : DataPointCollection!
  var monthlyData : DataPointCollection!
  
  var gridIntervals : [CGFloat]!
  
  @IBOutlet var webLabel: UILabel!
  @IBOutlet var webValue: UILabel!
  
  @IBOutlet var bankLabel: UILabel!
  @IBOutlet var bankValue: UILabel!
  
  @IBOutlet var rentLabel: UILabel!
  @IBOutlet var rentValue: UILabel!
  
  @IBOutlet var revenueLabel: UILabel!
  @IBOutlet var revenueValue: UILabel!
  
  @IBOutlet var refreshButton: ADVAnimatedButton!
  
  var timer : NSTimer!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.separatorStyle = .None
    
    tabSegmentControl.items = ["WEEKLY", "MONTHLY", "YEARLY"]
    tabSegmentControl.font = UIFont(name: "Avenir-Light", size: 12)
    tabSegmentControl.selectedIndex = 0
    tabSegmentControl.addTarget(self, action: "tabSelectionChanged:", forControlEvents: .ValueChanged)
    
    lineChartView = ANDLineChartView(frame: CGRectZero)
    lineChartView.translatesAutoresizingMaskIntoConstraints = false
    lineChartView.chartBackgroundColor = UIColor.whiteColor()
    lineChartView.gridIntervalLinesColor = UIColor(white: 0.83, alpha: 1.0)
    lineChartView.lineColor = UIColor(red: 0.14, green: 0.71, blue: 0.69, alpha: 1.0)
    lineChartView.elementStrokeColor = UIColor(red: 0.14, green: 0.71, blue: 0.69, alpha: 1.0)
    lineChartView.gradientStartColor = UIColor(red: 0.14, green: 0.71, blue: 0.69, alpha: 0.7)
    lineChartView.gradientEndColor = UIColor(red: 0.14, green: 0.71, blue: 0.69, alpha: 0.1)
    lineChartView.elementFillColor = UIColor.whiteColor()
    lineChartView.gridIntervalFont = UIFont(name: "Avenir-Light", size: 13)
    lineChartView.gridIntervalFontColor = UIColor(white: 0.47, alpha: 1.0)
    lineChartView.delegate = self
    lineChartView.dataSource = self
    
    chartContainer.addSubview(lineChartView)
    addConstraintsToFill(lineChartView, mainView: chartContainer)
    
    //chartData = [23, 24, 92, 91, 38, 94, 23, 24, 92, 23, 24, 92, 91, 38, 94, 91, 38, 94]
    weeklyData = DataPointCollection()
    weeklyData.values = [11, 15, 14, 26, 18, 24, 24]
    weeklyData.labels = ["MON", "TUE", "WED", "THU", "FRI", "SAT", "SUN"]
    
    monthlyData = DataPointCollection()
    monthlyData.values = [11, 15, 14, 26, 18, 24, 24, 15, 14, 26, 26, 7]
    monthlyData.labels = ["JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL", "AUG", "SEP", "OCT", "NOV", "DEC"]
    
    yearlyData = DataPointCollection()
    yearlyData.values = [9, 12, 22, 18, 18]
    yearlyData.labels = ["2011", "2012", "2013", "2014", "2015"]
    
    chartData = weeklyData
    gridIntervals = [0, 5, 10, 15, 20, 25, 30, 35]
    
    refreshButton.setTitle("REFRESH", forState: .Normal)
    refreshButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
    refreshButton.backgroundColor = UIColor(red: 0.52, green: 0.39, blue: 0.76, alpha: 1.0)
    refreshButton.titleLabel?.font = UIFont(name: "Avenir-Light", size: 25)!
    refreshButton.addTarget(self, action: "refreshButtonTapped:", forControlEvents: .TouchUpInside)
    
  }
  
  override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    
    if indexPath.row == 1 {
      return 300
    }else if (indexPath.row == 2 || indexPath.row == 3){
      return 100
    }else if indexPath.row == 4 {
      return 60
    }
    return 44
  }
  
  func tabSelectionChanged(sender: AnyObject?){
    if tabSegmentControl.selectedIndex == 0{
      chartData = weeklyData
    }else if tabSegmentControl.selectedIndex == 1{
      chartData = monthlyData
    }else{
      chartData = yearlyData
    }
    
    lineChartView.reloadData()
  }
  
  // Line Chart Datasource
  
  func numberOfElementsInChartView(chartView: ANDLineChartView!) -> UInt {
    
    return UInt(chartData.labels.count)
  }
  
  func chartView(chartView: ANDLineChartView!, valueForElementAtRow row: UInt) -> CGFloat {
    return chartData.values[Int(row)]
  }
  
  func chartView(chartView: ANDLineChartView!, labelForElementAtRow row: UInt) -> String! {
    return chartData.labels[Int(row)]
  }
  
  func maxValueForGridIntervalInChartView(chartView: ANDLineChartView!) -> CGFloat {
    return gridIntervals[gridIntervals.count - 1]
  }
  
  func minValueForGridIntervalInChartView(chartView: ANDLineChartView!) -> CGFloat {
    return gridIntervals[0]
  }
  
  func numberOfGridIntervalsInChartView(chartView: ANDLineChartView!) -> UInt {
    return UInt(gridIntervals.count)
  }
  
  func chartView(chartView: ANDLineChartView!, descriptionForGridIntervalValue interval: CGFloat) -> String! {
    
    return String(format: "%.0f", Double(interval))
  }
  
  // Line Chart Delegate
  func chartView(chartView: ANDLineChartView!, spacingForElementAtRow row: UInt) -> CGFloat {
    return 30.0
  }
  
  func addConstraintsToFill(subView: UIView, mainView: UIView){
    
    let topConstraint = NSLayoutConstraint(item: subView, attribute: .Top, relatedBy: .Equal, toItem: mainView, attribute: .Top, multiplier: 1.0, constant: 20.0)
    
    let bottomConstraint = NSLayoutConstraint(item: subView, attribute: .Bottom, relatedBy: .Equal, toItem: mainView, attribute: .Bottom, multiplier: 1.0, constant: -20.0)
    
    let leftConstraint = NSLayoutConstraint(item: subView, attribute: .Left, relatedBy: .Equal, toItem: mainView, attribute: .Left, multiplier: 1.0, constant: 0.0)
    
    let rightConstraint = NSLayoutConstraint(item: subView, attribute: .Right, relatedBy: .Equal, toItem: mainView, attribute: .Right, multiplier: 1.0, constant: 0.0)
    
    mainView.addConstraints([topConstraint, rightConstraint, leftConstraint, bottomConstraint])
  }
  
  func refreshButtonTapped(sender : AnyObject?){
    
    refreshButton.startAnimating()
    
    timer = NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: Selector("stopAnimation:"), userInfo: nil, repeats: false)
  }
  
  @objc func stopAnimation(sender : AnyObject?){
    refreshButton.stopAnimating()
  }
  
}

class DataPointCollection {
  var values: [CGFloat]!
  var labels: [String]!
}
