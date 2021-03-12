#!/usr/bin/ruby

# universalConstructor.rb

def errorTrap(topLineList)
        
        topLineList.each do
                |item|
        
                count = topLineList.count(item)
        
                if ( count != 1 )
                
                        print "\nERROR: duplicate heading of ",item," in ",tableFileName,"\n"
                        Process.exit(false)
                
                end
        
                length = item.size
        
                if ( length == 0 )
                
                        print "\nERROR: bad heading in ",tableFileName,"\n"
                        Process.exit(false)
                
                end
        
                
        end
        
        
        return
end


def classConstructor(className,tableFileName)
        
        createMetaDebugFile(className)
        #metaDebug("classConstructor " + className)
        
        inputFile = CsvFile.new(tableFileName)
   
        topLine = inputFile.getTopLine
        topLine = topLine.downcase
        topLineList = topLine.split(",")
        errorTrap(topLineList)
       
        executableString = ""     
 
    
        templateStart = ERB.new %q{
    
class <%=className%> 
  
}

        executableString << templateStart.result(binding)

        #print "\n",topLineList

        topLineList.each do
                |item|
                #print "\n>",item,"<"
                
                executableString << "        @" << item << " = nil ;\n"
                
        end   
        
        #print "\n",executableString
        
        executableString << "\n\n        def initialize("
        executableString << topLineList.join(",")
        executableString << ");\n" 
        
      
        
        
       topLineList.each do
                |item|
                
                executableString << "\n                @" << item << " = " << item << " ;"
                
        end   
        
        
        topLineList.each do
                |item|
                
                executableString << "\n                def set" << item.capitalize << "(value);  @" << item << " = value ; return ; end "
                
        end   
        
        
        topLineList.each do
                |item|
                
                executableString << "\n                def get" << item.capitalize << "; value = @" << item << ";  return(value) ; end "
                
        end 
        
        
        
        
        executableString << "\n\n        end; \n\n"
        
        
        #executableString << "\n\n        def getObject ; return(self); end \n\n"
        
        
        templateEnd = ERB.new %q{
end ; # of class <%=className%> 
  
}

        executableString << templateEnd.result(binding)


        #print "\n",executableString
    
        metaDebug(executableString)
    
        eval(executableString)
                
    
        return
end


def metaDebug(debugString)
        
        $debugMetaFile.append(debugString)
        
        return
end




  

def createMetaDebugFile(className)
        
        metaDebugFileName = ""
        metaDebugFileName << className
        metaDebugFileName << "MetaDebug.txt"
        
        $debugMetaFile = CustomFile.new(metaDebugFileName,"metaDebugInfo")
        
        $debugMetaFile.create
                
        return
end


def modifyName(name,count)
        
        alpha = *('a'..'z')
  
        result = name
        
     
        
        if ( count > 1 )
                
                result << "_" << alpha[ count - 2   ] 
                
        end
        


        return(result)
end


def wrapWithQuotes(string)

       result = ""
       result << "\""
       result << string
       result << "\""
       
       return result
       
end
       







def objectConstructor(className,tableFileName,objectName)
              
        nameHash = Hash.new
        
        inputFile = CsvFile.new(tableFileName)
   
        topLine = inputFile.getTopLine

        topLine = topLine.downcase

        topLineList = topLine.split(",")

        errorTrap(topLineList)

        nameColumn = topLineList.index(objectName)

        name = topLineList[nameColumn]
        
        

        if ( name == nil )
                
                print "\nERROR: A column named ",objectName," can't be found.\n"
                Process.exit(false)
                
        end


        
         
        $debugMetaFile.openAppend
         
             
        
       
        inputFile = File.new(tableFileName,"r")
        
                thisLine = inputFile.gets ; # skip over the top line, its the header
        
      

       begin 
    
                thisLine = inputFile.gets
        
                if ( thisLine != nil )
        
            
                        thisLine = thisLine.strip
                        
                
                        thisLineList = thisLine.split(",")
                        

                        
                        
                       # print "\n>",thisLine,"<"
                       
                       # in case the last cell is empty, it won't be included in the list
                       
                       if ( thisLine[(thisLine.size) - 1 ] == "," )
                               
                              # print "<- here"
                               thisLineList.push("")
                               
                       end
                       
                       
                       
                      # print "\n",thisLineList
                        
                        name = thisLineList[nameColumn]
                        
                        if (  ( name != nil ) && ( name.size != 0 )  )
                                
                                #print "\n",name
                                
                                # Special Hack Here.....
                                name = name.sub("[","_")
                                name = name.sub("]","_")
                                name = name.sub(":","_")
                                name = name.sub("<","_")
                                name = name.sub(">","_")
                                
                                name = name.downcase
                                thisLineList[nameColumn] = name
                                
                                tempLineList = []
                        
                                thisLineList.each do
                                        |item|
                                
                                        tempLineList.push(wrapWithQuotes(item) )
                                end
                                
                                

                                
                                if ( ! nameHash.has_key?(name) )
                                        
                                        nameHash[name] = 1
                                        
                                else 

                                        temp =  nameHash[name]
                                        
                                        temp = temp + 1
                                        
                                        nameHash[name] = temp
                                       
                                end
                                
                                
                                name = modifyName(name,nameHash[name])
                                
                                tempLineList[nameColumn] = wrapWithQuotes(name)
                                
                                
                                
                                executableString = ""
                                executableString << "$"
                                executableString << name << " = " << className << ".new("
                                executableString << tempLineList.join(",")
                                executableString << ");"
                                
                                #metaDebug(thisLine)
                               # metaDebug(executableString)
                               
                                $debugMetaFile.append(executableString)
                                
                                eval(executableString)
                                
                                
                        end        
                                
                        
                end
                
        
        end while thisLine != nil

        inputFile.close
        
        $debugMetaFile.close
                
        
        return
end





def buildLUTBeginning

        return

end


def buildLUTEnd

        return

end




def universalConstructor(className,tableFileName,objectName)
        
        print "\nclassConstructor ",className,"  ",tableFileName
        classConstructor(className,tableFileName)
        
        print "\nobjectConstructor ",className,"  ",tableFileName," ",objectName
        objectConstructor(className,tableFileName,objectName)
        
        return
end

