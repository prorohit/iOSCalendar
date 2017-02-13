//
//  ViewController.swift
//  Calender-Integration
//
//  Created by Rohit.Singh on 10/02/17.
//  Copyright © 2017 Rohit.Singh. All rights reserved.
//

import UIKit
import JTAppleCalendar
class ViewController: UIViewController,JTAppleCalendarViewDelegate, JTAppleCalendarViewDataSource {

    @IBOutlet weak var lblMonth: UILabel!
    @IBOutlet weak var calenderView: JTAppleCalendarView!
    
    
    // Pre-Required varialbles
    var dateFormatter = DateFormatter()
    var numberOfRows = 6
    var  testCalender = Calendar.current
    
    
    var generateInDates: InDateCellGeneration = .forAllMonths
    var generateOutDates: OutDateCellGeneration = .tillEndOfGrid
    var hasStrictBoundaries = true
    let firstDayOfWeek: DaysOfWeek = .sunday
    let disabledColor = UIColor.lightGray
    let enabledColor = UIColor.blue
    let dateCellSize: CGFloat? = nil
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dateFormatter.dateFormat = "yyyy-MM-dd"
        self.calenderView.delegate = self
        self.calenderView.dataSource = self
        self.calenderView.registerCellViewXib(file: "CellView")
        self.calenderView.cellInset = CGPoint(x: 0, y: 0)
        self.calenderView.visibleDates { (visibleDates: DateSegmentInfo) in
            self.setupViewsOfCalendar(from: visibleDates)
        }
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    func setupViewsOfCalendar(from visibleDates: DateSegmentInfo) {
        guard let startDate = visibleDates.monthDates.first else {
            return
        }
        let month = self.testCalender.dateComponents([.month], from: startDate).month!
        let monthName = DateFormatter().monthSymbols[(month-1) % 12]
        // 0 indexed array
        let year = self.testCalender.component(.year, from: startDate)
        self.lblMonth.text = monthName + " " + String(year)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        let startDate = self.dateFormatter.date(from: "2017-01-01")!
        let endDate = self.dateFormatter.date(from: "2018-01-01")!
        
        let parameters = ConfigurationParameters(startDate: startDate,
                                                 endDate: endDate,
                                                 numberOfRows: self.numberOfRows,
                                                 calendar: self.testCalender,
                                                 generateInDates: generateInDates,
                                                 generateOutDates: generateOutDates,
                                                 firstDayOfWeek: firstDayOfWeek,
                                                 hasStrictBoundaries: hasStrictBoundaries)
        
        return parameters

    }
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplayCell cell: JTAppleDayCellView, date: Date, cellState: CellState) {
        
        let myCustomCell = cell as! CellView
        myCustomCell.lblDate.text = cellState.text
        
        if self.testCalender.isDateInToday(date) {
            myCustomCell.backgroundColor = UIColor.red
        } else {
            myCustomCell.backgroundColor = UIColor.white
        }
        
        handleCellSelection(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
    }
    
    
    
    // Function to handle the text color of the calendar
    func handleCellTextColor(view: JTAppleDayCellView?, cellState: CellState) {
        
        guard let myCustomCell = view as? CellView  else {
            return
        }
        
        if cellState.isSelected {
            myCustomCell.lblDate.textColor = UIColor.white
        } else {
            if cellState.dateBelongsTo == .thisMonth {
                myCustomCell.lblDate.textColor = UIColor.black
            } else {
                myCustomCell.lblDate.textColor = UIColor.gray
            }
        }
    }
    
    // Function to handle the calendar selection
    func handleCellSelection(view: JTAppleDayCellView?, cellState: CellState) {
        guard let myCustomCell = view as? CellView  else {return }
        if cellState.isSelected {
            myCustomCell.viewAnimated.translatesAutoresizingMaskIntoConstraints = true;
            myCustomCell.viewAnimated.layer.cornerRadius =  (myCustomCell.viewAnimated.frame.size.width - 4 ) / 2
            myCustomCell.viewAnimated.isHidden = false
        } else {
            myCustomCell.viewAnimated.isHidden = true
        }
    }

 
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleDayCellView?, cellState: CellState) {
        handleCellSelection(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)

    
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        self.setupViewsOfCalendar(from: visibleDates)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleDayCellView?, cellState: CellState) {
        handleCellSelection(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
    }
    


}

