//
//  PieChartView.swift
//  PieChartView
//
//  Created by Shanju Ebanesh K on 07/06/22.
//

import UIKit

//PieChart class: the class which generates the pie View
class PieChartView: UIView {
    
    private var pieData: PieChartData                   //stores the data displayed that the pie is handling
    private var layers : [Int : CAShapeLayer] = [:]     //stores the individual layers for each category index
    private var numberOfSections : Int = 0              //stores the number of Sections the pie is handling
    private var startAngle : [Int : CGFloat] = [:]      //stores the start angle of every category
    private var currentSelectedLayer: CAShapeLayer?     //stores the layer for the current category that is being highlighted
    private var completedPortionColor: UIColor?         //stores the color for the completed portion in the highlighted category
    private var remainingPortionColor: UIColor?         //stores the color for the uncompleted portion in the highlighted category
    private var unselectedPortionColor: UIColor?        //stores the color for the unhighlighted categories
    private var strokeWidth: CGFloat = 2                //stores the width of the stroke between the segments
    private var strokeColor: UIColor?                   //stores the color of the stroke between the segments
    private var ratioOfStrokeToSize: CGFloat = 60       //stores the ratio to which the stroke width is reduced by the
    
    //MARK: Initializers
    //Initializer to class where a whole set of section Data as passed an pieData
    //Please enter the center point of the pie for the x and y in the frame
    init(frame: CGRect, data: PieChartData, completedPortionColor: UIColor = .systemBlue, uncompletedPortionColor: UIColor = .darkGray, unselectedPortionColor: UIColor = .lightGray, strokeWidth : CGFloat? = nil, strokeColor: UIColor = .white){
        
        //estimating the frame of the pie view from the input frame considering the x and y given in the input frame is the center of the pie
        let estimatedFrame = CGRect(
            x: frame.minX - frame.width / 2,
            y: frame.minY - frame.height / 2,
            width: frame.width,
            height: frame.height)
        
        
        //initializing the value to the variables
        self.pieData = data
        self.completedPortionColor = completedPortionColor
        self.remainingPortionColor = uncompletedPortionColor
        self.unselectedPortionColor = unselectedPortionColor
        self.strokeColor = strokeColor
        if let strokeWidth = strokeWidth {
            self.strokeWidth = strokeWidth
        }else{
            let calculatedStroke = (frame.height < frame.width) ? frame.height / ratioOfStrokeToSize : frame.width / ratioOfStrokeToSize
            self.strokeWidth = calculatedStroke
            if calculatedStroke > 2{
                self.strokeWidth = 2
            }
        }
        
        //assigning the count of the categories in the assignment to the number of categories
        self.numberOfSections = pieData.sectionData.count
        
        super.init(frame: estimatedFrame)
        
        //calling the function to create the layers for all the categories
        createLayers()
    }
    
    
    //Initializer to class where the categories are passed as an array of Section Data
    //Please enter the center point of the pie for the x and y in the frame
    init(frame: CGRect, sectionData: [PieSectionData], completedPortionColor: UIColor = .systemBlue, uncompletedPortionColor: UIColor = .darkGray, unselectedPortionColor: UIColor = .lightGray, strokeWidth : CGFloat? = nil, strokeColor: UIColor = .white){
        
        //estimating the frame of the pie view from the input frame considering the x and y given in the input frame is the center of the pie
        let estimatedFrame = CGRect(
            x: frame.minX - frame.width / 2,
            y: frame.minY - frame.height / 2,
            width: frame.width,
            height: frame.height)
        
        //initializing the value to the variables
        self.pieData = PieChartData(sectionData: sectionData)
        self.completedPortionColor = completedPortionColor
        self.remainingPortionColor = uncompletedPortionColor
        self.unselectedPortionColor = unselectedPortionColor
        self.strokeColor = strokeColor
        if let strokeWidth = strokeWidth {
            self.strokeWidth = strokeWidth
        }else{
            let calculatedStroke = (frame.height < frame.width) ? frame.height / ratioOfStrokeToSize : frame.width / ratioOfStrokeToSize
            self.strokeWidth = calculatedStroke
            if calculatedStroke > 2{
                self.strokeWidth = 2
            }
        }
        
        super.init(frame: estimatedFrame)
        
        //assigning the count of the categories in the assignment to the number of categories
        self.numberOfSections = pieData.sectionData.count
        
        //calling the function to create the layers for all the categories
        createLayers()
    
        
    }
    
    
    required init?(coder: NSCoder) {
        pieData = PieChartData(sectionData: [])
        super.init(coder: coder)
    }
    
    //MARK: Private Functions
    
    //function to initially create the layers for the individual categories in the assignmens
    private func createLayers(){
        
        //making a copy of the ending angle of the last layer, which will act as the start angle of the next layer
        var lastEndAngle: CGFloat = -(.pi / 2)
        
        //variable to keep track of the current index
        var currentIndex = 0
        
        //For every individual category, create the arc based on the portion it occupies.
        for sectionData in pieData.sectionData{
            
            //Storing the start angles of the layers, so that it can be reused when highlighting a particular category
            startAngle[currentIndex] = lastEndAngle
            
            //Creating a new layer for the category
            let newLayer = CAShapeLayer()
            
            //calculating the portion occupied by the category as: (total tasks in the category/ total tasks in the assignment)
            let portionOccupied = (CGFloat(sectionData.totalValue) / CGFloat(pieData.totalValueInPieChart))
            //creating the bezier path for the arc
            var path: UIBezierPath
            
            //storing the path and the angle at which the the path ends(to use as the start angle of next category)
            (path, lastEndAngle) = createPathForLayer(
                center: CGPoint(                //estimating the center point of the circle
                    x: frame.width / 2,
                    y: frame.height / 2),
                //estimating the radius of the pie by taking the small value among height and width
                radius: (frame.width > frame.height) ? frame.height / 2 : frame.width / 2,
                startAngle: lastEndAngle,
                portionOccupied: portionOccupied)
            //assigning the path to the layer
            newLayer.path = path.cgPath
            
            //creating a layer to define the masking area
            let maskLayer = CAShapeLayer()
            maskLayer.path = path.cgPath
            
            //creating a new layer to add the stroke line for the pie
            let strokeLayer = CAShapeLayer()
            
            strokeLayer.path = path.cgPath
            strokeLayer.mask = maskLayer
            
            //setting the color for the layer based on the value obtained while initialization or defaulting it to gray
            if let fillColor = self.unselectedPortionColor{
                newLayer.fillColor = fillColor.cgColor
            }else{
                newLayer.fillColor = UIColor.lightGray.cgColor
            }
            //assigning the stroke color based on the obtained value or defaulting it to white
            if let strokeColor = strokeColor{
                strokeLayer.strokeColor = strokeColor.cgColor
            }else{
                strokeLayer.strokeColor = UIColor.white.cgColor
            }
            //assigning the stroke width to the mentioned strokewidth
            strokeLayer.lineWidth = self.strokeWidth
            strokeLayer.fillColor = UIColor.clear.cgColor
            //storing the layer to reuse it when highlighting a category
            layers[currentIndex] = newLayer
            
            newLayer.addSublayer(strokeLayer)
            //adding the layer to the layer of the view
            layer.addSublayer(newLayer)
            currentIndex += 1
        }
        
    }
    
    
    //Function that creates the path for the layer based on the center, radius, start angle and the portion occupied by the category
    private func createPathForLayer(center: CGPoint, radius: CGFloat ,startAngle: CGFloat, portionOccupied: CGFloat, isSelectedPath: Bool = false, isClockwise: Bool = true) -> (UIBezierPath, CGFloat){
        
        //creating the path
        let path = UIBezierPath()
        //estimating the end angle based on the start angle and portion occupied
        let endAngle: CGFloat = (.pi * 2 * portionOccupied) + startAngle
    
        //drawing the path
        
        // If it is not the selected path, adding stroke on both the sides as well as the arc
        if !isSelectedPath{
            path.move(to: center)
            path.addArc(
                withCenter: center,
                radius: radius,
                startAngle: startAngle,
                endAngle: endAngle,
                clockwise: true)
            path.addLine(to: center)
            path.close()
        }else{
            //if it is a selected path and lies on the left side, adding stroke on the left side and the arc(Used for completed region as it occurs on the left )
            if isClockwise{
                path.move(to: center)
                path.addArc(
                    withCenter: center,
                    radius: radius,
                    startAngle: startAngle,
                    endAngle: endAngle,
                    clockwise: true)
                path.close()
            }else{
                //if it is a selected path and lies on the right side, adding stroke on the right side and the arc(Used for uncompleted region as it occurs on the right)
                path.move(to: center)
                path.addArc(
                    withCenter: center,
                    radius: radius,
                    startAngle: startAngle,
                    endAngle: endAngle,
                    clockwise: true)
                path.close()
                
            }
        }
        
        //returning the path and the endAngle (endAngle is returned for calculating the startAngle of the next layer)
        return (path, endAngle)
        
    }
    
    
    //MARK: Public Functions
    //function to highlight the layer of a category at a particular index
    //To make the layer highlighted, add two new layers one for completed part and another for uncompleted part with the specified colors and add it as the sublayer of the layer corresponding to the index
    func selectCategoryWith(index: Int){

        //If there is already a highlighted layer, remove it
        if let currentSelectedLayer = currentSelectedLayer{
            currentSelectedLayer.sublayers = []
            
            let strokeLayer = CAShapeLayer()
            
            strokeLayer.path = currentSelectedLayer.path
            
            strokeLayer.lineWidth = strokeWidth
            if let strokeColor = strokeColor{
                strokeLayer.strokeColor = strokeColor.cgColor
            }else{
                strokeLayer.strokeColor = UIColor.white.cgColor
            }
            strokeLayer.fillColor = UIColor.clear.cgColor
            
            currentSelectedLayer.addSublayer(strokeLayer)
            
            self.currentSelectedLayer = nil
        }
        
        //Checking if the index is out of range
        if index > numberOfSections || index < 0{
            print("Unable to process for: ", index)
            return
        }else{
            //checking if there is already a layer, current angle for the newly selected index
            if let selectedLayer = layers[index] , let currentAngle = startAngle[index]{
                
                //creating a stroke layer for the unselected layer
                let strokeLayer = CAShapeLayer()
                
                strokeLayer.path = selectedLayer.path
                
                let maskLayer = CAShapeLayer()
                maskLayer.path = selectedLayer.path
                
                //creating a layer for the created part
                let completedLayer = CAShapeLayer()
                //variable to store the paths
                var path: UIBezierPath
                //variable to store the end point of the completed portion (which is the start angle of the remaining portion)
                var endPointOfCompletedPortion : CGFloat
                
                print("Processing for: ", index)
                
                //calculating the number of tasks that are completed
                var shadedArea = pieData.sectionData[index].completedValue
                //calculating the total number of tasks in the assignment
                let totalArea = pieData.totalValueInPieChart
                //calculating the portion occupied by the completed region by : (Completed tasks / total number of tasks)
                var portionOccupied = CGFloat(shadedArea) / CGFloat(totalArea)
            
                //calling the function to calculate the path and the start of the next layer (uncompleted portion)
                (path, endPointOfCompletedPortion) = createPathForLayer(
                    center: CGPoint(            //center of the arc estimation
                        x: frame.width / 2,
                        y: frame.height / 2),
                    //estimating the radius of the pie by taking the small value among height and width
                    radius: ((frame.width > frame.height) ? frame.height / 2 : frame.width / 2) /* - (strokeWidth / 2)*/,
                    startAngle: currentAngle,
                    portionOccupied: portionOccupied,
                    isSelectedPath: true,
                    isClockwise: true)
                
                //assigning the path to the layer
                completedLayer.path = path.cgPath
                //filling the color in the layer if there is any specifics mentioned or defaulting it to blue
                if let fillColor = self.completedPortionColor{
                    completedLayer.fillColor = fillColor.cgColor
                }else{
                    completedLayer.fillColor = UIColor.systemBlue.cgColor
                }
                
                //adding the completed layer to the layer of the selected category
                selectedLayer.addSublayer(completedLayer)
                
                //creating a layer for uncompleted portion
                let remainingLayer = CAShapeLayer()
                //calculating the uncompleted tasks
                shadedArea = pieData.sectionData[index].totalValue - pieData.sectionData[index].completedValue
                //calculating the portion occupied by : (uncompleted tasks / total taks)
                portionOccupied = CGFloat(shadedArea) / CGFloat(totalArea)
                
                //calling the function to calculate the path
                (path, _) = createPathForLayer(
                    center: CGPoint(
                        x: frame.width / 2,
                        y: frame.height / 2),
                    radius: ((frame.width > frame.height) ? frame.height / 2 : frame.width / 2) /*- (strokeWidth / 2)*/,
                    startAngle: endPointOfCompletedPortion,
                    portionOccupied: portionOccupied,
                    isSelectedPath: true,
                    isClockwise: false)
                //assigning the path to the uncompleted layer
                remainingLayer.path = path.cgPath
                
                //filling the color in for the uncompleted layer if there are any specifics mentioned or defaukting it to darkGray
                if let fillColor = self.remainingPortionColor{
                    remainingLayer.fillColor = fillColor.cgColor
                }else{
                    remainingLayer.fillColor = UIColor.darkGray.cgColor
                }
                //adding the uncompleted layer to the layer of the selected category
                selectedLayer.addSublayer(remainingLayer)
                //storing the layer of the selected category, to remove the same if there is a new category selected
                currentSelectedLayer = selectedLayer
                
                //stroke layer properties
                if let strokeColor = strokeColor{
                    strokeLayer.strokeColor = strokeColor.cgColor
                }else{
                    strokeLayer.strokeColor = UIColor.white.cgColor
                }
                
                strokeLayer.lineWidth = strokeWidth
                strokeLayer.fillColor = UIColor.clear.cgColor
                strokeLayer.mask = maskLayer
                
                selectedLayer.addSublayer(strokeLayer)
                
            }else{  //if there is no layer for the category mentioned. Printing the debug info
                print("Cant find the category")
                print("Category:", index)
                print("Layers: ", String(describing: self.layers[index]))
                print("StartAngle:", String(describing: startAngle[index]))
                return
            }
        }
    }
    
    
    //function to select a particulat category based on its name
    func selectCategoryWith(name: String){
        
        //If there is already a layer that is highlighted, remove that from highlighting
        if let currentSelectedLayer = currentSelectedLayer{
            currentSelectedLayer.sublayers = []
            self.currentSelectedLayer = nil
        }
        
        //if the name if found in the dictionary, highlight the layer at the index
        if let index = pieData.indexForCategoryNames[name]{
            selectCategoryWith(index: index)
        }else{
            print("No index found for the name: ", name)
        }
    }
    
    //function to replace all the data in the pie chart. Can be used while using with collection or table views
    func replaceData(data: PieChartData){
        
        //copying the input data
        self.pieData = data
        
        //removing all the data that are already in the pie chart
        for i in 0...self.layers.count{
            layers[i]?.removeFromSuperlayer()
        }
        
        //nulling the selected key so that it is unselected once the value is update
        self.currentSelectedLayer = nil
        
        self.numberOfSections = data.sectionData.count
        
        //creating new layers for the pies
        createLayers()
        
    }
    
}


