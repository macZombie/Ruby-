#!/usr/bin/ruby

# top.rb

# Top Level test/demo

require 'yaml'
require 'erb'

require './genericFunctions.rb'
require './extendString.rb'
require './customFile.rb'
require './csvFile.rb'
require './font.rb'
require './diagram.rb'
require './bitmap.rb'
require './bitmapFunctions.rb'
require './registerYamlFile.rb'
require './universalConstructor.rb'
require './binaryFile.rb'
require './svgImage.rb'


# SPECIFIC FOR REGISTER MAP OF PROJECT ( YAML )
require './careAbouts.rb'


BEGIN { print "\nINFO: Start of ",$PROGRAM_NAME }

# File input
if ( false )
        myFile = CustomFile.new("myFile.txt","Sample File")
        myFile.openRead
        myFile.close
        myFile.dumpContents
end

# File output
if ( false )
        outputFile = CustomFile.new("output.txt","Sample output file")
        outputFile.create
        outputFile.append("This is a test")
        outputFile.openAppend
        outputFile.write("Simple test")
        outputFile.close
end


#CSV Files
if ( false )
        
        inputSheet = CsvFile.new("Book1.csv")
      #  inputSheet.dumpContents
        print "\n",inputSheet.getTopLine
        print "\n",inputSheet.columnCount
        print "\n",inputSheet.rowCount
        
        topLine = inputSheet.getTopLine
        
        print "\ncell 0 = ",inputSheet.getCell(topLine,0)
        
        print "\ncell 3 = ",inputSheet.getCell(topLine,3)

        print "\nlast cell = ",inputSheet.getCell(topLine,inputSheet.columnCount)
        
        print "\ncolumn = ",inputSheet.getColumn("delta")
        
       # print "\ncolumn = ",inputSheet.getColumn("zonk")
        
        print "\ncolumnName = ",inputSheet.getColumnName(2)
        
        print "\nsearchResult = ",inputSheet.search("alpha","extra","horse")
        
        
        print "\nDEBUG: ",inputSheet.getName
        
        
        inputSheet.makeBufferFileName
        print "\nDEBUG: ",inputSheet.getBufferFileName
        
     
       
       # inputSheet.modify("extra","alpha","0.6","9999")
       
       # find the contents of the alpha column where the extra column == horse
        print "\nsearchResult = ",inputSheet.search("alpha","extra","horse")
       # inputSheet.dumpContents
        
        
        # replace the contents of the alpha column, where the extra column == horse
        inputSheet.modify("alpha","extra","horse","0.60")
        print "\nsearchResult = ",inputSheet.search("alpha","extra","horse")
 
 
        # replace the contents of the alpha column, where the extra column == horse
        inputSheet.modify("alpha","extra","horse","9999")
        print "\nsearchResult = ",inputSheet.search("alpha","extra","horse")
 
        # replace the contents of the alpha column, where the extra column == horse
        inputSheet.modify("alpha","extra","horse","0.60")
        print "\nsearchResult = ",inputSheet.search("alpha","extra","horse")
 

end


# Diagrams/Plots
if ( false )
        
        
        fillSineCache # build lookup table for trig functions first
        fillFontCache # setup the font for 2D plotting

	myPlot = Diagram.new("zonk",256,256)
	myPlot.drawBoxPaper
	
	myPlot.colour($YELLOW)
	myPlot.box(64,64,64,64)
	
	myPlot.colour($BLACK)
	myPlot.string(10,10,"test")
        
        
        myPlot.colour($RED)
	myPlot.string(10,200,"Red")
        
        myPlot.colour($GREEN)
	myPlot.string(10,180,"Green")
        
        myPlot.colour($BLUE)
	myPlot.string(10,160,"Blue")
        
     
        myPlot.colour($BLACK)
        pitch = 0.02
        
        0.step(6.28,pitch) do 
                |index|
       
                myPlot.drawSegment(200,128,50,index,(index + pitch ) )
        
                myPlot.colourRatio( index / 6.28 )
        
        end         


        myPlot.colour($BLUE)
    
        lastX = 0
        lastY = 200
    
        0.step(200,1) do
                |index|
        
                x = index
                y = 225 + ( 10 * Math.sin(index / 5.0  ) ) 
        
                myPlot.line(lastX,lastY,x,y)
        
                lastX = x
        
                lastY = y
        
        end
	
	myPlot.finish

end





# Simple image processing
if ( false )
        
        inputImageA = Bitmap.new("imageA.bmp")
        inputImageA.setInfo
        #inputImageA.dumpInfo
        
        
        inputImageB = Bitmap.new("imageB.bmp")
        inputImageB.setInfo
        #inputImageB.dumpInfo
        
        
        if ( ! checkCompatiblity( inputImageA, inputImageB) )
                
                print "\nERROR: ", inputImageA.getName, " and ", inputImageB.getName," are not compatible"
                inputImageA.dumpInfo
                inputImageB.dumpInfo
                exit(0)
                
        end
        
          
        outputImageA = Diagram.new("outputImageA",inputImageA.getWidth,inputImageA.getHeight)
        disturbance = compareImages( inputImageA, inputImageB, outputImageA)
        outputImageA.finish  
        print "\nDisturbance = ",disturbance
        
        #       outputImageX = Diagram.new("outputImageX",inputImageA.getWidth,inputImageA.getHeight)
        #       disturbance = compareImages( inputImageA, inputImageA, outputImageX)
        #       outputImageX.finish  
        #       print "\nDisturbance = ",disturbance
        
          
        
end




# YAML to CSV extraction. Custom class for types of YAML/XML
if ( false )
        
        inputFileName = "register_table.yaml"
        outputFileName  = ""
        outputFileName <<  inputFileName.sub(".yaml","") << "A" << ".csv"
        
        inputFile = RegisterYamlFile.new(inputFileName,"YAML file")
        
        
        #print "\nDEBUG ",inputFile.basename

        if ( true )
    
                print "\nExistence = ",inputFile.doesFileExist
                print "\nName = ",inputFile.getName
                print "\nDescription = ",inputFile.getDescription
    
        end
    
   
        if ( ! inputFile.doesFileExist )
        
                print "\nERROR: The input file named ",inputFileName," doesn't exist.\n\n"
                Process.exit(false)
        
        end
      
    
        #############################################################
        #                 YAML TO CSV TRANSLATION                   #     
        #############################################################

        print "\nINFO: Loading YAML into memory"
        registerData = YAML.load_file(inputFile.getName)
        print "\nINFO: YAML loaded"
        
        #############################################################


        print "\nINFO: outputFileName = ",outputFileName
        print "\nINFO: buildMainRegisterMap"
        inputFile.buildMainRegisterMap(registerData,outputFileName)
        print "\nINFO: buildMainRegisterMap done"


        #############################################################
        
        outputFileName  = ""
        outputFileName <<  inputFileName.sub(".yaml","") << "B" << ".csv"
        print "\nINFO: outputFileName = ",outputFileName
        print "\nINFO: buildBitFieldMap"
        inputFile.buildBitFieldMap(registerData,outputFileName)
        print "\nINFO: buildBitFieldMap done"
    
        #############################################################

end




# Example Universal Constructor
if ( false )
        
        print "\n\n\nINFO: *****     UNIVERSAL CONSTRUCTOR     *****"
        
        yamlFileName = "register_table.yaml"
        registerCsvFileName  = ""
        registerCsvFileName <<  yamlFileName.sub(".yaml","") << "A" << ".csv"
        
        
        print "\nINFO: build Register Class"
        classConstructor("Register",registerCsvFileName)
        print "\nINFO: build Register Class done"
        
        print "\nINFO: build Register Objects"
        objectConstructor("Register",registerCsvFileName,"name")
        print "\nINFO: build Register Objects done"
        

        bitFieldCsvFileName  = ""
        bitFieldCsvFileName <<  yamlFileName.sub(".yaml","") << "B" << ".csv"
        
        
        print "\nINFO: build BitField Class"
        classConstructor("BitField",bitFieldCsvFileName )
        print "\nINFO: build BitField Class done"
       
        print "\nINFO: build BitField Objects"
        objectConstructor("BitField", bitFieldCsvFileName,"uniqueid")
        print "\nINFO: build BitField Objects done"
        
        
        print "\n", bitFieldCsvFileName
        

        print "\n\n\nINFO: *****     TEST UNIVERSAL CONSTRUCTOR     *****"
        
         #registerCsvFile = CsvFile.new( registerCsvFileName)
        registerCsvFile = CsvFile.new( "register_tableA.csv" )
        registerCsvFile.populateIndexArray("name")
        #registerCsvFile.dumpIndexArray    
        buildResolver("Register" ,   registerCsvFile.getIndexArray , "name" )
        
        registerCsvFile.getIndexArray.each do
                |item|
                print "\n",item," "
                print "\n",item," ",getRegisterObject(item).getName," ",getRegisterObject(item).getAddress
        end
                
        #bitFieldCsvFile = CsvFile.new( bitFieldCsvFileName)
        bitFieldCsvFile = CsvFile.new( "register_tableB.csv" )
        bitFieldCsvFile.populateIndexArray("uniqueID")
        #bitFieldCsvFile.dumpIndexArray    
        buildResolver("BitField" ,   bitFieldCsvFile.getIndexArray , "uniqueid" )
        
        bitFieldCsvFile.getIndexArray.each do
                |item|
                print "\n",item," "
                print "\n",item," ",getBitFieldObject(item).getUniqueid
        end
                

end








if ( false )
        
        myBinaryFile = BinaryFile.new("zonk.bmp")
        
        myBinaryFile.hexDump
        
end








# Example SVG image
if ( true )
        
        myImage = SVGImage.new("myImage.svg")
        
       # myImage.open
        
        
       # myImage.close
        
        myImage.test 
        
end


END { print "\nINFO: End of ",$PROGRAM_NAME,"\n\n" }











