#!/usr/bin/ruby

# diagram.rb
#

# 24 bit colours
#            BBGGRR
$BLACK   = 0X000000
$BROWN   = 0X3C3C6B
$RED     = 0X0000FF
$ORANGE  = 0X007FFF
$YELLOW  = 0X12FFFF
$GREEN   = 0X00FF00
$BLUE    = 0XFF0000
$VIOLET  = 0XFF03D5
$GREY    = 0X7F7F7F
$WHITE   = 0XFFFFFF

$LIGHT_GREEN = 0X66FF99
$CYAN = 0XFFFF99

# lookup table for trig functions
$sineCache = Array.new(6283)

# cache of bits for font
$fontCache = Array.new($FONTMAX,0X00)

class Diagram
	@name
	@xDim
	@yDim
	@frameBuffer
	@bitMapFile
	@redCol
	@greenCol
	@blueCol
	
	def initialize(name,xDim,yDim)
		@name = name
		@xDim = xDim
		@yDim = yDim
		@frameBuffer = Array.new(xDim * yDim * 3,0XFF)
		@redCol = 0;
		@greenCol = 0;
		@blueCol = 0;
                @red = 0;
		@green = 0;
		@blue = 0;
        
        
		
		open
		writeHeader(xDim,yDim)
	
		
	end # of initialize
	
	
	
	def tell
		print "\nname = ",@name
		print "\nxDim = ",@xDim
		print "\nyDim = ",@yDim
		print "\nframeBuffer size = ",@frameBuffer.size
		print "\nredCol = ",@redCol
		print "\ngreenCol = ",@greenCol
		print "\nblueCol = ",@blueCol
	end
	
	
	
	def open
		bitMapFileName = @name + ".bmp"
		@bitMapFile = File.open bitMapFileName, "wb"
	end
	private :open
	
	def close
		@bitMapFile.close
	end
	private :close
	
	
	
	def writeByte(x)
		
		@bitMapFile.putc(x)
			
	end
		
	private :writeByte	
	
	def writeDouble(x)
		
		writeByte( ( x >> 8 ) & 0XFF )
		writeByte( x & 0XFF)
			
	end
		
	private :writeDouble
	
	def writeQuad(x)
		
		writeByte( x & 0XFF)
		writeByte( ( x >> 8  ) & 0XFF )
		writeByte( ( x >> 16 ) & 0XFF )
		writeByte( ( x >> 24 ) & 0XFF )
		
	end
	
	private :writeQuad	
	
	def writeHeader(wide,high)
		
		offset = 0x36 # hardwired
		size = (wide * high ) + offset
  		writeDouble(0X424D) # id hardwired
		writeQuad(size)
		writeQuad(0X00000000) # reserved hardwired
		writeQuad(offset)
		writeQuad( ( offset - 14 ) ) # header size
		writeQuad(wide)
		writeQuad(high)
		writeDouble(0X0100) # planes, hardwired
		writeDouble(0X1800) # bits per pixel, hardwired
		writeQuad(0X00000000) # compression, hardwired
		writeQuad(@xDim & @yDim * 3 ) # bitmap data size
		writeQuad(0X00000000) # hresolution
		writeQuad(0X00000000) # vresolution
		writeQuad(0X00000000) # colours
		writeQuad(0X00000000) # important colours
		
	end 
	private :writeHeader
	
	def dumpBuffer
		for i in ( 0 .. ( ( @xDim * @yDim * 3 ) - 1 ) )
			@bitMapFile.putc( @frameBuffer[i] )
		end
	end
	
	private :dumpBuffer
	
	def finish
		dumpBuffer
		close
	end
	
	
	
	def colour(myColour)

		@redCol   = myColour &0XFF    
		@greenCol = ( myColour &0XFF00 ) /   0X100
		@blueCol  = ( myColour &0XFF0000 ) / 0X10000
		
	end
	
	
	
	def pixel(x,y)

		address = ( y * ( @xDim * 3 ) ) + ( x * 3 )
		@frameBuffer[address]       = @blueCol   
		@frameBuffer[address + 1] = @greenCol
		@frameBuffer[address + 2] = @redCol   
		
	end
	
	
	
	
	def box(xpos,ypos,wide,high)

		for y in ( ypos .. ( ypos + high ) )
		
			for x in ( xpos .. ( xpos + wide ) )
			
				pixel(x,y)	
			
			end

		end
	
	end	


	
	
	def gradient(a,b,c,d)
	
		a = a.to_f
		b = b.to_f
		c = c.to_f
		d = d.to_f
		m = ( d - b ) / ( c - a )
		return m
	
	end
	private :gradient
	
	def verticalLine(a,b,c,d)
	
		if ( ( d - b ) > 0 )
			inc = 1
			else
				inc = -1
			end
				
		b.step(d,inc){	
			|y|
			pixel(a,y)
		}
	
	end

	private :verticalLine
	
	def horizontalLine(a,b,c,d)

		if ( ( c - a ) > 0 )
			inc = 1
				else
					inc = -1
		end	
	
		a.step(c,inc){
		|x|
		pixel(x,b)
		
		}

	end

	private :horizontalLine
	
	def steepVector(a,b,c,d)
			
		if ( ( d - b ) > 0 )
			inc = 1
				else
					inc = -1
				end
				
		b.step(d,inc){
			|y|
			m = gradient(a,b,c,d)
			x = a + ( ( y - b ) * ( 1.0 / m ) )
			x = x.to_i
			y = y.to_i
			pixel(x,y)

		}	
		
	
	end



	private :steepVector
	
	def shallowVector(a,b,c,d)
	
		if ( ( c - a ) > 0 )
			inc = 1
				else
					inc = -1
				end
				
		a.step(c,inc){
			|x|
			m = gradient(a,b,c,d)
			y = b + ( ( x - a ) * m )		
			x = x.to_i
			y = y.to_i
			pixel(x,y)

		}	
		end


	private :shallowVector
	
	def vector(a,b,c,d)
	
		m = gradient(a,b,c,d)
	
		if ( m.abs > 1.0 )
			steepVector(a,b,c,d)
		else
			shallowVector(a,b,c,d)
		end
		
	end


	private :vector
	
	def line(a,b,c,d)

		if ( a == c ) 
			verticalLine(a,b,c,d)
			elsif ( b == d ) 
				horizontalLine(a,b,c,d)
		else
			vector(a,b,c,d)
		end
	
	end


	def mySine(angle)
		angle = angle.remainder(6.282)
		angle = angle * 1000 # scale to 1000 * 2 x PI
		value = $sineCache[angle]
		return(value)
	end
	private :mySine

	def myCos(angle)
		angle = angle + 1.57079
		value = mySine(angle)
		return(value)
	end
	private :myCos

	def drawArc(x,y,r,startRad,stopRad)
		startRad.step((stopRad),   0.002){ ## 0.0002
			|theta|
			circleX = ( r * myCos(theta) ).to_i
			circleY = ( r * mySine(theta) ).to_i
			pixel( ( x + circleX) , ( y + circleY )) 
		}
	end
	
	def drawCircle(x,y,r)
		drawArc(x,y,r,0.0,( Math::PI * 2 ))
	end
	
	def drawSegment(x,y,r,startRad,stopRad)
		startRad.step((stopRad),   0.0005){
			|theta|
			circleX = ( r * mySine(theta) ).to_i
			circleY = ( r * myCos(theta) ).to_i
			line( x,y, ( x + circleX) , ( y + circleY ) )
		}
	end

	
	def fillCircle(x,y,r)
		drawSegment(x,y,r,0.0,( Math::PI * 2 ))
	end
	

	
	def drawGraphPaper
		colour($LIGHT_GREEN)
		
		0.step(@xDim,10){
			|index|
			line(0,index,@xDim,index)
			line(index,0,index,@yDim)
		}
	

		colour($RED)
		
		0.step(@xDim,100){
			|index|
			line(0,index,@xDim,index)
			line(index,0,index,@yDim)
		}
	
	end
	

	def drawBoxPaper
		colour($CYAN)
		
		0.step(@yDim,25){
			|index|
			line(0,index,@xDim,index)
			
		}
		
		0.step(@xDim,25){
			|index|
			
			line(index,0,index,@yDim)
		}
	

	
	end




	def plotChar (xOffset,yOffset,chas)
		
                thisChar = 0
                
                threshold = 5

                versionCode = rubyVersionCode

        
                if ( versionCode >= 19 )
		
                        thisChar = chas[0].ord ; # because this changed in Ruby 1.9
        
                else
            
                        thisChar = chas ; # pre Ruby 1.9 character to ascii conversion
            
                end
        

		thisChar = 126 - thisChar.to_i
		x = 0
		y = 0
		offset = 1536 *thisChar
		# save the colour to restore it at the end
		localBlueCol  = @blue 
		localGreenCol = @green
		localRedCol   = @red  

		( 0x36 + offset ).step( ((96 * 16 ) + offset), 3 ){
			|index|
			
			@blue =    $fontCache[index]     
			@green =   $fontCache[index + 1] 
			@red =     $fontCache[index + 2] 
			
			if ( @blue != 255 ) && ( @green != 255 ) && ( @red != 255 )
			
				if ( x > 10 ) # was 14
					pixel(x + xOffset,y + yOffset )
				end
			
			end
		
		
			x = x + 1
		
			if ( x > 31 )
				x = 0
				y = y + 1
			end
			
	
		} # step
	
		@blue = localBlueCol
		@green = localGreenCol
		@red = localRedCol
	
	end
	private :plotChar
	
	def string(x,y,myString)

		( 0 .. ( myString.size - 1 ) ).each{
			|index|
			c = myString[index]
			# don't print a space
			if ( c != 32 )
				plotChar(x,y,c)
			end
			#x = x + 13 # was 14
			x = x + 10 # was 14
		}
	end
	
	
	
	def doColour(incoming)
		#@redCol = 0
		#@greenCol = 0
		#@blueCol = 0
		phase = 0
		factor = 0.0
	
		for index in ( 0 .. 6 )
			lower = index * 2396745.0
			upper = lower + 2396745.0
			if ( (  incoming >= lower ) && ( incoming < upper ) )	
				phase = index
				factor = ( incoming - lower ) 
			end
		end
	
		# intermediate variables to keep coding tidy
		pos = 0.0
		pos = ( factor / 2396745 ) * 256.0
		pos = pos.to_i
		neg = 255 - pos

		case phase
			when(0) then @redCol = pos; @greenCol = 0;   @blueCol  = 0;
			when(1) then @redCol = 255; @greenCol = pos; @blueCol  = 0;
			when(2) then @redCol = neg; @greenCol = 255; @blueCol  = 0;
			when(3) then @redCol = 0;   @greenCol = 255; @blueCol  = pos;
			when(4) then @redCol = 0;   @greenCol = neg; @blueCol  = 255;
			when(5) then @redCol = pos; @greenCol = 0;   @blueCol  = 255;
			when(6) then @redCol = 255; @greenCol = pos; @blueCol  = 255;
				else         @redCol = 0;   @greenCol = 0;   @blueCol  = 0;
		end # case phase
	
	end

	private :doColour
	
	def colourRatio(ratio)
		thisColour = 0XFFFFFF * ratio
		thisColour = thisColour.to_i
		doColour(thisColour)
	end	
	
end # of class Diagram

##############################################################################

def fillSineCache
	for x in ( 0 .. 6282 )
		$sineCache[x] = Math.sin(x/1000.0)
	end
end

##############################################################################



