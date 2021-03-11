#!/usr/bin/ruby

# extendString.rb

class String

        def suball(originalString,replacementString)
                
                outputString = self
                
                
                begin
                        
                        count = outputString.count(originalString)
                                
                        outputString = outputString.sub(originalString,replacementString)
                                 
                end while ( count > 0 )


                return outputString
                
        end
        
                

end ; # of class String
