#!/usr/bin/ruby

# binaryFile.rb

class BinaryFile < CustomFile
        

        def initialize(fileName)
                
                super(fileName,"binary file for analysis")
        
                return
        end
                

        def asciiFilter(value)   
                
                if (  (  value < 32 ) || ( value > 126 )  )
                        
                        value = 95
                        
                end
                
                return value
        end
        

        def hexDump
                
                fileName = getName
                
                outputFileName = fileName.suball(".","_") << ".txt"
                
                print "\nfileName = ",fileName
                print "\noutputFileName = ",outputFileName
                
                outputFile = CustomFile.new(outputFileName,"hex dump")
                
                outputFile.create
                
                outputFile.openWrite()
                
                openReadBinary()
                
                contents = IO.binread(getName)
                
                contentList = contents.split("")
                
                size = contents.size
                
                
                outputFile.write(fileName)
                
                outputFile.write("size = " << contents.size.to_s  << " (dec) " << sprintf(" %04X (hex) ",contents.size  ) << "\n\n"  )
                
                address = 0
                
                lineCounter = 0
                
                lineString = ""
                
                textString = ""
                
                contentList.each do
                        |byte|
                        

                        address = address + 1
                        lineCounter = lineCounter + 1
                        
                        value = byte.ord
                        valueString = ""
                        valueString << sprintf("%02X",value)
                       
                        lineString << valueString << " "
                        value = asciiFilter(value)        
                        textString << value
                        
                        remaining = size - address
                        
                        
                        if ( ( lineCounter == 16 ) || ( remaining == 0 ) )
                                
                                outputLine = ""
                                outputLine << sprintf("%08X    ",address) << lineString.ljust(50) << "    " << textString ; # << "    " << remaining.to_s
                                
                                outputFile.write(outputLine)
                                
                                lineCounter = 0
                                lineString = ""
                                textString = ""
                        end
                        
                
                end
                
                
                
                
                close()
                
                outputFile.close()
                
                return
        end
        


end
