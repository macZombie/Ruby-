#!/usr/bin/ruby
#File: csvFile.rb
#

# csvFile.rb


class CsvFile < CustomFile 
        
        @bufferFile = ""
	@bufferFileName = ""
        @indexArray = Array.[]
        
        def initialize(fileName)
		
		super(fileName,"Comma Separated Variables / Sheet")
                
                @indexArray = [""]
		
	end
	
        
        def getString
                
                myString = @file.gets
        
                return(myString)
        end
        
        
	def getTopLine
		
                openRead()
		
                topLine = @file.gets
		
		if (topLine != nil )
			
			topLine = topLine.chomp
			
		end
		
		
		if (topLine != nil )
			
			topLine = topLine.strip
			
		end
		
		close
		
                
                return topLine
	end




        def populateIndexArray(idString)
                
                column = getColumn(idString)
                
                openRead
                
                dummyString =  @file.gets
                
                thisLine = ""
                
                @indexArray.pop ; # remove dummy string first
                
                begin
			
                        thisLine = @file.gets
                        
                        if ( thisLine != nil )
                                
                                thisBitFieldList = thisLine.split(",")
                                
                                thisBitField = thisBitFieldList[column]
                                
                                # Special Hack Here.....
                                thisBitField = thisBitField.sub("[","_")
                                thisBitField = thisBitField.sub("]","_")
                                thisBitField = thisBitField.sub(":","_")
                                thisBitField = thisBitField.sub("<","_")
                                thisBitField = thisBitField.sub(">","_")
                                
                                thisBitField = thisBitField.downcase
                                
                                @indexArray.push(thisBitField)
                                
                        end
                        
			
                
		end while ( thisLine != nil )
                
                
                close
                               
               return 
        end
        
        
        def dumpIndexArray
                
                print "\n\nINFO: ",getName,"'s indexArray"
                
                
                @indexArray.each do
                        |item|
                        print "\n",item
                        
                end
                
                
                return
        end
        
        def getIndexArray
                
                return ( @indexArray )
                
        end
        
        
        
        def columnCount
		topLine = getTopLine()
		count = topLine.count(",")
		return count
	end
	
	
	def rowCount
		openRead()
		count = 0
		
		begin
			thisString = @file.gets
			count = count + 1
		end while ( thisString != nil )
		
		close()
		
		return count
		
		
	end


        def getCell(thisString,n)
	
		returnedString = "NOT_FOUND"
		
		if ( thisString != nil )
                        
                        thisList = thisString.split(",")
                        
                        thisElement = thisList[n]
                        
                        if ( thisElement != nil )
                        
                                returnedString = thisElement
                                
                        end
			
		end	
	
		return(returnedString);
	
	end


        def getColumn(search)
				
		column = -1
		topLine = getTopLine
		position = topLine.index(search)
		index = 0
                
                topLineList = topLine.split(",")
                
                column = topLineList.index(search) 
                
                if ( column == nil )
                
                        column = -1
                        print "\n***** ERROR: getColumn - Can't find a column named ",search," in >",topLine,"<"
                        exit
                        
                end

		return column
					
	end			
					            
                










	def getColumnName(number)
		topLine = getTopLine()
		columnName = getCell(topLine,number)
		return columnName
	end
	
        
        def search(reply, reference ,referenceItem )
		# search for the 1st argument where the second argument == third argument
		
		foundString = "NOT_FOUND"
		
		referenceColumn = getColumn(reference)
		replyColumn = getColumn(reply)
		
		openRead()
		
		# skip the top-most line
		headerLine = @file.gets


		begin
			thisLine = @file.gets
			
			thisTry = getCell(thisLine,referenceColumn)
			thisTry = thisTry.strip
			
			
			if ( thisTry.eql?(referenceItem) )
			
				foundString = getCell(thisLine,replyColumn)
				
			end
			
			
			
		end while ( thisLine != nil )
		
		
		foundString = foundString.chomp.strip
		
		
		return foundString
		
	end
	
        
	def makeBufferFileName
		
		#@bufferFileName = fullName + "_buff"
                @bufferFileName = getName + "_buff"
		
	end
	
	def getBufferFileName
		
		return(@bufferFileName)
		
	end
	
	

	def openBufferRead
		
		makeBufferFileName
		
		@bufferFile = File.open @bufferFileName,"r"
		
		if @bufferFile == nil
			print "\nERROR: Can't open buffer file for reading."
			exit
		end
		
		return
	end
	
	
	def openBufferWrite
		
		makeBufferFileName

		@bufferFile = File.open @bufferFileName,"w"
		
		if @bufferFile == nil
			print "\nERROR: Can't open buffer file for writing."
			exit
		end
		
		return
	end
	

	def closeBuffer
		@bufferFile.close
		return
	end
        
        
        
        
	def modify( destination, reference, referenceItem, newValue )

		destinationColumn = getColumn(destination)
		referenceColumn = getColumn(reference)
		
		maxColumns = columnCount - 1 
		
		found = 0
		first = 0
		openBufferWrite
		openRead
		
		# skip the top-most line
		headerLine = @file.gets
		@bufferFile.puts(headerLine)
		
		
		thisLine = "DUMMY_VALUE"

		
		begin
		
			thisLine = @file.gets

		
			if ( thisLine != nil )

                                thisList = thisLine.strip.split(",")
			
                                thisTry = thisList[referenceColumn]

		
				if ( thisTry.eql?(referenceItem) )
				
                                        
                                      
			
					oldValue = getCell(thisLine,destinationColumn);
					found = 1
                                        
                                        #print "\n\nfound ",thisTry, " in the ",reference," column"
                                        #print "\nreplacing ",oldValue," with ",newValue," in the ",destination," column"
                                        
                                        newList = thisList
                                        
                                        newList[destinationColumn] = newValue
                                        
                                        newString = newList.join(",")

					@bufferFile.puts(newString)
					
					found = 2
					first = 1
			
					
				end # of "FOUND" section
				
				
				if ( found == 0 )
				
					@bufferFile.puts(thisLine)
					
				end # of NOT FOUND SECTION
				
				
				if ( found == 2 )
				
				
					if ( first != 1 )
				
						if ( thisLine != nil )
				
							@bufferFile.puts(thisLine)
							
						end
						
						
						
					end
						
					first = 0
					
				end # of FOUND == 2 section
				
				
			end # of thisLine != nil decision delimiter
			
			
		end while ( thisLine != nil )
		
		close
		closeBuffer
		
		# Disable here to avoid overwriting the file during debug
		doTheBufferring
		
		
		return
	end

	def doTheBufferring
		
		openWrite
		openBufferRead
		
		begin
		
			thisLine = @bufferFile.gets
			
			if ( thisLine != nil )
				@file.puts(thisLine)
			end
			
			
			
		end while ( thisLine != nil )
		
		
		close
		closeBuffer
		
		
	end
	



        
        
        
        
        
        
        
        
        
        
        
        
        
	



end # of class CsvFile


