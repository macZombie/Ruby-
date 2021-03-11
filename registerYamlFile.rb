#!/usr/bin/ruby

# File: registerYamlFile.rb
 


class RegisterYamlFile  < CustomFile
        
        @name
        @description
               
        def initialize(name,description)
                
                @name = name
                @description = description
                
                return
        end
        
        
        def getName ; return(@name) ; end
        def getDescription ; return(@description) ; end
        def getHeaderString
        
                headerList = $registerCareAbouts

                headerString = headerList.join(",")
    
                headerString = headerString + ","
    
                return(headerString)
        end

        
        
        
   
        def buildMainRegisterMap(registerData,outputFileName)


                outputFile = CustomFile.new(outputFileName,"Chip's register map in CSV format")
    
                outputFile.create
    
                if ( ! outputFile.doesFileExist )
        
                        print "\nERROR: The output file named ",outputFileName," wasn't created.\n\n"
                        Process.exit(false)
        
                end
    

                headerString = getHeaderString
    
                columnCount = headerString.count(",")
    
                outputFile.append(headerString) ; # These are the care-about columns only. Keep it simple.
   
                outputFile.openAppend

                outputList = Array.new(columnCount)


                registerData.each do
                        |keyA,valueA|
        
                        valueA.each do
                                |keyB,valueB|

            
                                outputString = ""; # Start a new line
            
                                columnCount.times { |i| outputList[i] = ""  }

                                keyB.each do
                                        |keyC,valueC|
               
                                        if ( $registerCareAbouts.include?(keyC) )
                       
                                                ix = $registerCareAbouts.index(keyC)
                        
                                                cell = valueC.to_s
                                                cell = cleanUp(cell)
                        
                        
                                                outputList[ix.to_i] = cell
                       
                       
                                        end
               
        
                                end

                                outputString = outputList.join(",")    
                                outputFile.write(outputString)
            

                        end
      
                end
    
                outputFile.close
    
    
    

     
    
                return
    
        end



       
        
        


        def buildBitFieldMap(registerData,outputFileName)
    
        
                outputFile = CustomFile.new(outputFileName,"Chip's bitField map in CSV format")
        
                outputFile.create
        
        
                if ( ! outputFile.doesFileExist )
        
                        print "\nERROR: The output file named ",outputFileName," wasn't created.\n\n"
                        Process.exit(false)
        
                end
        

                listOfHeaders = ["uniqueID" ] + $registerCareAbouts
        
        
                $bitFieldCareAbouts.each do |field|
                
                        column = ""
                        column << "bits"
                        column << field
                
                        listOfHeaders.push(column)
                
                end
        
        
                outputFile.append(listOfHeaders.join(","))
        
                columnCount = listOfHeaders.count(",")
        
                parentCount = $registerCareAbouts.size
        
                outputFile.openAppend

                outputList = Array.new(columnCount)
        
                parentList = Array.new(parentCount)


                registerData.each do
                        |keyA,valueA|
        
                        valueA.each do
                                |keyB,valueB|

            
                                # outputString = ""; # Start a new line
            
                                parentCount.times { |i| parentList[i] = ""  }

                                keyB.each do
                                        |keyC,valueC|
               
                                        if ( $registerCareAbouts.include?(keyC) )
                       
                                                ix = ( $registerCareAbouts.index(keyC) ) + 1
                        
                                                cell = valueC.to_s
                                                cell = cleanUp(cell)
        
                                                parentList[ix.to_i] = cell
                       
                                        end
               
               
               
                                        if ( keyC.eql?("bits" ) )
                                        
                                                if ( valueC != nil )
                                        
                                                        valueC.each do
                                                                |keyD,valueD|
                                                         
                                                                #print "\n\n",keyD
                                                         
                                                         
                                                                keyD.each do
                                                                        |keyE,valueE|
                                                                
                                                                        #  print "\n\n\n\n",keyE,"   ",valueE
                                                                
                                                                        if ( keyE != nil )
                                                                
                                                                                if ( $bitFieldCareAbouts.include?(keyE) )
                                                                                
                                                                                
                                                                                        if ( keyE.eql?("name") )
                                                                        
                                                                                                # print "\n",keyE,"   ",valueE
                                                                                
                                                                                                columnCount.times { |i| outputList[i] = ""  }
                                                                                        
                                                                                                iy = ( $bitFieldCareAbouts.index(keyE) ) + $registerCareAbouts.size + 1
                                                                                                cell = valueE.to_s
                                                                                                cell = cleanUp(cell)
                                                                                                outputList[iy.to_i] = cell
               
                                                                                        end
       
       
                                                                                        iy = ( $bitFieldCareAbouts.index(keyE) ) + $registerCareAbouts.size + 1
                                                                                        cell = valueE.to_s
                                                                                        cell = cleanUp(cell)
                                                                                        outputList[iy.to_i] = cell
                                                                                
       
                                                                        
                                                                                end
                                                                
                                                                        end
                                                        
                                                                end
                                                         
                                                         
                                                                offset = 0
                                                        
                                                                parentList.each do
                                                                        |item|
                                                                
                                                                        outputList[offset] = item
                                                                
                                                                        offset = offset + 1
                                                        
                                                                end
                
                                                                uniqueId = ""
                                                                uniqueId << outputList[1] << "__" << outputList[3]
                                                                outputList[0] = uniqueId
                                                
                                                                outputString = outputList.join(",")    
                                                                outputFile.write(outputString)
                                                         
                                                        end
                                        
                                                end
   
                                        end

                                end

                        end
      
                end
    
                outputFile.close
    
                return
    
        end






end ; #of class RegisterYamlFile

