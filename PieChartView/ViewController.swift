//
//  ViewController.swift
//  PieChartView
//
//  Created by Shanju Ebanesh K on 07/06/22.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let pieData = PieChartData(sectionData: [
            PieSectionData(identity: "ClassWork", totalValue: 12, completedValue: 2),
            PieSectionData(identity: "Internals", totalValue: 4, completedValue: 1),
            PieSectionData(identity: "Tests", totalValue: 1, completedValue: 1),
            PieSectionData(identity: "HomeWork", totalValue: 2, completedValue: 1)
        ])

        //top pie
        let pie = PieChartView(
            frame: CGRect(
                x: view.center.x,
                y: 150,
                width: 50,
                height: 50),
            data: pieData
        )
        view.addSubview(pie)
        pie.selectCategoryWith(name: "ClassWork")
    
        //bottom pie
        let pie2 = PieChartView(
            frame: CGRect(
                x: view.center.x,
                y: view.center.y,
                width: 300,
                height: 300),
            sectionData: [
                PieSectionData(identity: "ClassWork", totalValue: 12, completedValue: 2),
                PieSectionData(identity: "Internals", totalValue: 4, completedValue: 1),
                PieSectionData(identity: "Tests", totalValue: 1, completedValue: 1),
                PieSectionData(identity: "HomeWork", totalValue: 2, completedValue: 1)
            ]
        )
        view.addSubview(pie2)
        pie2.selectCategoryWith(name: "ClassWork")
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5){
            
            pie2.replaceData(data: PieChartData(sectionData: [
                PieSectionData(identity: "ClassWork", totalValue: 12, completedValue: 2),
                PieSectionData(identity: "Internals", totalValue: 4, completedValue: 1)
            ]))
            pie2.selectCategoryWith(index: 1)
        }
    }
}

