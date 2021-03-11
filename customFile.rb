#!/usr/bin/ruby

# customFile.rb

# Imporant: Custom File uses File Class but does not extend it. Avoids stream problems

class CustomFile 

        @file = nil
        @name = nil 
        @description = nil

        def initialize(fileName,description)
                setName(fileName)
                setDescription(description)
                return
        end
        
        
        def setName(fileName)
                @name = fileName
                return
        end


        def getName
                fileName = @name
                return fileName
        end


        def setDescription(description)
                @description = description
                return
        end
    
    
        def getDescription
                description = @description
                return description
        end
    
    
        def doesFileExist
                result = false
                result = File.exist?(getName)
                return result
        end
        
        
        def openRead

                thisFile = @name
                @file = File.open thisFile,"r"
                        
		return
	end

        def openReadBinary

                thisFile = @name
                @file = File.open thisFile,"rb"
                        
		return
	end

        
            
        def close
                @file.close();
                #system("sync")
                return
        end
        
        

        def dumpContents
                
                openRead()
                
                puts "\nDump of " + @name + " (" + @description + ")"
		
		begin
			
			thisLine = @file.gets
			
			if ( thisLine != nil )
				
				thisLine = thisLine.chomp.strip
				puts(">"+ thisLine + "<" )

			end
			
			
			
		end while ( thisLine != nil )
                
                puts "End of Dump of " + @name + " (" + @description + ")\n\n"
		
		close()
                
		return
	end
	




        def openWrite
                thisFile = @name
                @file = File.open thisFile,"w"
                return
        end
        
        
        def create
                openWrite
                close()
                return
        end
        
        
        def openAppend
                thisFile = @name
                @file = File.open thisFile,"a"
                return
        end

       
        def append(thisString)
                openAppend()
                @file.puts(thisString)
                close
	return
       end


        def write(thisString)
                @file.puts(thisString)
                return
        end
	




end # of class file


