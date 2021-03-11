#!/usr/bin/ruby

# genericFunctions.rb

def parseArguments
    
    variableName = ""
  
    case(ARGV.size)
  
        when ( 0 )
            print "\nEnter input file name:- "
            variableName = gets.chomp.strip
    
        when ( 1 )
            variableName = ARGV[0]
            
        else
            print "\nERROR: Wrong number of arguments"
            print "\nUSAGE: ruby regi.rb filename."
            Process.exit
     
    end  # case
    
    
    return(variableName)

end # parseArguments



def cleanUp(thisString)
    
    if ( thisString != nil )
    
        thisString = thisString.gsub("\n","_")
        thisString = thisString.gsub(",","_")
        thisString = thisString.gsub("\"","_")
        thisString.strip!
    
    end

    return thisString

end

    
    
    

def rubyVersionCode
        
        versionCodeString = RUBY_VERSION
        
        versionCodeString = versionCodeString.suball(".","")
        
        versionCodeString = versionCodeString[ 0..1 ]
        
        versionCode = versionCodeString.to_i
        
        return versionCode
        
end


def buildResolver(className, indexArray , columnID)
        
        
        metaFileName = ""
        metaFileName << className << "ResolverMetaDebug.txt"
        metaFile = CustomFile.new(metaFileName,"meta code for resolving Objects")
        metaFile.create
        metaFile.openWrite
        
        executableString = ""
        
        templateStart = ERB.new %q{
    
def get<%=className%>Object(name)
        thisObject = nil
}
        executableString << templateStart.result(binding)
        
        
        indexArray.each do
                |name|
                
                name = name.downcase
                
                executableString << "\n        if ( name.eql?(\"" << name << "\") ) ; thisObject = $" << name << " ; end"
                
                
        end
        
        



        templateStop = ERB.new %q{
        return(thisObject)
end

}
        
         executableString << templateStop.result(binding)
         
         metaFile.append(executableString)

        metaFile.close
        
        eval(executableString)
        
        return
end
 

def getDate
        
        result = ""
        
        time = Time.new

       #puts time.to_s
       #puts time.ctime
       #puts time.localtime
       # result = time.strftime("%Y-%m-%d %H:%M:%S")
        result = time.strftime("%a %d/%m/%y")
        
        
        return result

end

        
def getYear
        
        result = ""
        
        time = Time.new

       #puts time.to_s
       #puts time.ctime
       #puts time.localtime
        result = time.strftime("%Y")
        
        
        return result

end
 
 
 
