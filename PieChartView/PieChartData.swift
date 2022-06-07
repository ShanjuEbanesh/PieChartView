//
//  PieChartData.swift
//  PieChartView
//
//  Created by Shanju Ebanesh K on 07/06/22.
//

import Foundation
//MARK: Classes to store data

//Class used for storing the data of individual categories
class PieSectionData{
    var identity: String      //name of the pie section
    var totalValue : Int      //total value represented by the pie section
    var completedValue: Int   //completed value represented in the pie section
    
    
    //Initializer that gets the name of the category and the count of total and completed values
    init(identity: String, totalValue: Int, completedValue: Int){
        
        //Properties of the class Initialization
        self.identity = identity
        self.totalValue = totalValue
        self.completedValue = completedValue
        
        //If the completed value is greater than the assigned value, defaulting the completed tasks as 0
        if self.completedValue > self.totalValue{
            self.completedValue = 0
            print("Completed tasks is greater than total tasks defaulting to zero")
        }
    }
    
}


//Class used for storing the data of the group of pieSectionData as PieChartData
class PieChartData{
    
    var totalValueInPieChart : Int = 0               //total value in all the pieSections together
    var sectionData : [PieSectionData]                  //array to store the pieSections in the pieChart
    var indexForCategoryNames : [String: Int] = [:]
    
    //Initializer that takes in an array of Section Datas to be placed in the pieChart
    init(sectionData: [PieSectionData]){
        
        //Properties of the class initialization
        self.sectionData = sectionData
        
        var currIndex = 0
        
        //Calculating the total value in the pieChartData
        for sectionDatum in sectionData {
            self.totalValueInPieChart += sectionDatum.totalValue
            self.indexForCategoryNames[sectionDatum.identity] = currIndex
            currIndex += 1
        }
    }
    
    //Function to update the value of a specific section with the input identifier
    func updateValueOfSection(withIdentity identity: String, completedValue: Int? = nil, totalValue: Int? = nil){
        
        //if there are no values to be changed
        if completedValue == nil && totalValue == nil{
            print("No values given to update..")
            return
        }
        
        //flag to find if the identity is present or not
        var identityFound : Bool = false
        
        //stores the index of the identity if it is found
        var identityIndex : Int = -1
        
        //searching for the identity in the sections data
        for i in 0...sectionData.count - 1 {
            if sectionData[i].identity == identity{
                identityFound = true
                identityIndex = i
            }
        }
        
        //if the identity if found process the data and modify the total value in the pie as well
        if identityFound{
            let modifyingSection = sectionData[identityIndex]
            
            if let newTotalValue = totalValue, let newCompletedValue = completedValue{
                
                self.totalValueInPieChart -= modifyingSection.totalValue
                
                modifyingSection.totalValue = newTotalValue
                modifyingSection.completedValue = newCompletedValue
                
                self.totalValueInPieChart += newTotalValue
                
            }else if let newTotalValue = totalValue, newTotalValue > modifyingSection.completedValue{
                
                self.totalValueInPieChart -= modifyingSection.totalValue
                
                modifyingSection.totalValue = newTotalValue
            
                self.totalValueInPieChart += newTotalValue
                
            }else if let newCompletedValue = completedValue, newCompletedValue < modifyingSection.totalValue{
               
                modifyingSection.completedValue = newCompletedValue
            
            }else{
                
                print("Invalid total and completed values")
                
            }
        }
        //If the identity is not found, printing the available identities for the programmer to debug
        else{
            
            print("The entered identity is not found.\nThe identities that are present are:")
            
            for sectionDatum in sectionData {
                
                print(sectionDatum.identity)
            
            }
            
        }
    
    }
}
