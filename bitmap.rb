#!/usr/bin/ruby
#File: bitmap.rb
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

# bitmap.rb

class Bitmap < CustomFile
        
        
        @id
        @size
        @reserved
        @offset
        @headerSize
        @width
        @height
        @planes
        @bpp
        @compression
        @bitmapDataSize
        @hRes
        @vRes
        @colours
        @importantColours
        
        
        
        def initialize(fileName)
		
		super(fileName,"Bitmap Image")
		
	end
        
        
        def getId ; value = @id ; return value ; end
        def getSize ; value = @size ; return value ; end 
        def getReserved ; value = @reserved ; return value ; end 
        def getOffset ; value = @offset ; return value ; end 
        def getHeaderSize ; value = @headerSize ; return value ; end 
        def getWidth ; value = @width ; return value ; end 
        def getHeight ; value = @height ; return value ; end 
        def getPlanes ; value = @planes ; return value ; end 
        def getBpp ; value = @bpp ; return value ; end 
        def getCompression ; value = @compression ; return value ; end 
        def getBitmapDataSize ; value = @bitmapDataSize ; return value ; end 
        def getHRes ; value = @hRes ; return value ; end 
        def getVRes ; value = @vRes ; return value ; end 
        def getColours ; value = @colours ; return value ; end 
        def getImportantColours ; value = @importantColours ; return value ; end              
        
        

        
        def openReadBinary
                thisFile = @name
                @file = File.open thisFile,"rb"
		return
	end
        
        
        def getDouble(header,position)
                
                value = 9999 ; # Dummy value
                
                value = header[position].ord + ( 256 * header[position + 1 ].ord )
                
                return value
                
        end
        
        
         def getQuad(header,position)
                
                value = 9999 ; # Dummy value
                
                value = getDouble(header,position)
                
                value = value + ( 65536 *  getDouble(header,( position + 2 ) ) )
                
                return value
                
        end
        
        
        


        def setInfo
                
                contents = IO.binread(@name)
                
                header = contents [ 0 .. 0x36 ]
                
                @id                      = getDouble(header,0)
                @size                    = getQuad(header,2)
                @reserved                = getQuad(header,6)
                @offset                  = getQuad(header,10)
                @headerSize              = getQuad(header,14)
                @width                   = getQuad(header,18)
                @height                  = getQuad(header,22)
                @planes                  = getDouble(header,26)    
                @bpp                     = getDouble(header,28)
                @compression             = getQuad(header,30)
                @bitmapDataSize          = getQuad(header,34)
                @hRes                    = getQuad(header,38)
                @vRes                    = getQuad(header,42)
                @colours                 = getQuad(header,46)
                @importantColours        = getQuad(header,50)         
                
                return
        end
        
        
        
        def dumpInfo
                print "\n",getName," Header Info:-" 
                print "\nid                 = ",sprintf("%04X",  @id              ) ,sprintf("   %8d (dec)",  @id              )   
                print "\nsize               = ",sprintf("%08X",  @size            ) ,sprintf("   %8d (dec)",  @size            )
                print "\nreserved           = ",sprintf("%08X",  @reserved        ) ,sprintf("   %8d (dec)",  @reserved        )
                print "\noffset             = ",sprintf("%08X",  @offset          ) ,sprintf("   %8d (dec)",  @offset          )
                print "\nheaderSize         = ",sprintf("%08X",  @headerSize      ) ,sprintf("   %8d (dec)",  @headerSize      )
                print "\nwidth              = ",sprintf("%08X",  @width           ) ,sprintf("   %8d (dec)",  @width           )
                print "\nheight             = ",sprintf("%08X",  @height          ) ,sprintf("   %8d (dec)",  @height          )
                print "\nplanes             = ",sprintf("%04X",  @planes          ) ,sprintf("   %8d (dec)",  @planes          )   
                print "\nbpp                = ",sprintf("%04X",  @bpp             ) ,sprintf("   %8d (dec)",  @bpp             )
                print "\ncompression        = ",sprintf("%08X",  @compression     ) ,sprintf("   %8d (dec)",  @compression     )
                print "\nbitmapDataSize     = ",sprintf("%08X",  @bitmapDataSize  ) ,sprintf("   %8d (dec)",  @bitmapDataSize  )
                print "\nhRes               = ",sprintf("%08X",  @hRes            ) ,sprintf("   %8d (dec)",  @hRes            )
                print "\nvRes               = ",sprintf("%08X",  @vRes            ) ,sprintf("   %8d (dec)",  @vRes            )
                print "\ncolours            = ",sprintf("%08X",  @colours         ) ,sprintf("   %8d (dec)",  @colours         )
                print "\nimportantColours   = ",sprintf("%08X",  @importantColours ) ,sprintf("   %8d (dec)", @importantColours )      
                
                return
        end
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
    


        def getDimensions
                
                dimensions = []
                
                contents = IO.binread(@name)
                
                header = contents [ 0 .. 0x36 ]
                
                headerList = header.split("")
                
                #print "\n",contents.size
                
                #print "\n",header.size
                
               count = 0
               wIndex = 1
               hIndex = 1
               
               width = 0
               
               height = 0
               
               headerList.each do 
                       |byte|
                       
                    
                    
                       
                       if ( ( count >= 18 ) && ( count <= 21 ) )
                               
                                #print "\n",count," ",byte," ",byte[0].ord," ",sprintf("%02X",byte[0].ord)
                               
                               width = width + (  byte[0].ord * wIndex )
                               
                               wIndex =wIndex * 256
                       end
                       
  
                        if ( ( count >= 22 ) && ( count <= 25 ) )
                               
                                #print "\n",count," ",byte," ",byte[0].ord," ",sprintf("%02X",byte[0].ord)
                               
                                height = height + (  byte[0].ord * hIndex )
                               
                                hIndex =hIndex * 256
                       end
                       
                       
                       count = count + 1
               end
                
                #print "\nwidth = ",width
                #print "\nheight = ",height
                
                dimensions.push(width)
                dimensions.push(height)

                return dimensions
        end
        

end


