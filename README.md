# PieChartView
A UIView Class to draw a pie chart based on the inputs given by the user.

The PieChartView class accepts inputs as an object of class PieChartData.
The PieChartData class contains the total value that the pie represents and a group of objects of the class PieSectionData which provide the data for the individual sections.
This class has functions to change the PieChartData that needs to be changed, so that the same PieChartView can be reused when used inside Collection View Cells or Table View Cells.
The PieChartView can also highlight a section based on the users needs.

# PieSectionData

The PieSectionData class consists of the data that a section of the pie chart represents.
It has an unique identifier which is used to identify the Section, a total value represented by the section and the portion of the value that is highlighted in the section.

# PieChartData

The PieChartData class consists of the group of all the PieSectionData objects that are represented by the PieChartView.
The PieChartData also maintains a dictionary that maps the identity of the section to the index of the section, to easily modify the data.
The class also provides features to modify the data in its sections.

# Functions

The PieChartView can be initialized using 2 different initializers, one accepting a PieChartData object and another accepting a group of PieSectionData objects. The inputs like the stroke color, section colors, stroke width, frame of the view are also obtained as inputs.

The function createLayers() in the PieChartView is used to create the initial layers for the individual sections, calculating the angles covered by the sections based on the value represented by the section and the total  value represented by the PieChartView.

The function replaceData() in the PieChartView accepts a PieChartData object and changes the data represented by the PieChart into the input data.

The functions SelectCategoryWith(name: ) and SelectCategoryWith(index: ) are used to highlight a certain section of the PieChartView.

Note: In the highlighted section, the portion of the section that is highlighted is represented in a different color than the actual section itself.
