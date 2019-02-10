#!/usr/bin/ruby
#File: extendString.rb
#
# Abstract: Ruby Framework Component
# 
# Copyright (C) 2017 Dialog Semiconductor GmbH and its Affiliates, unpublished work
# 
# This computer program includes Confidential, Proprietary Information and is a
# Trade Secret of Dialog Semiconductor GmbH and its Affiliates. All use, disclosure,
# and/or reproduction is prohibited unless authorized in writing. All Rights Reserved.
#
# Fri 20/01/17     Revision: ( Under separate revision control )
#
# Notes: 
#
#
#
#

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
