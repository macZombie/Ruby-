#!/usr/bin/ruby


class SVGImage
        
        @fileName
        @svgFile
        @originX
        @originY
        @width
        @height
        
        def initialize(value)
                @fileName = value
                @originX = 25
                @originY = 25
                @width = 800
                @height = 600
                return
        end
        
        def open
		@svgFile = File.open @fileName, "w"
                return
	end
	
	
	def close
		@svgFile.close
                return
	end
        
        
        def append(thisString)
                
                @svgFile.puts(thisString)
                
                return
        end
        
        def writeHeader
                
                template = ERB.new %q{<?xml version="1.0" encoding="UTF-8" ?>
<svg xmlns="http://www.w3.org/2000/svg" version="1.1">
}
                
                
                outputString = template.result(binding)
                
                append(outputString)
                
                return
        end
        
        
        def writeFooter
                
                template = ERB.new %q{</svg>
}
                
                outputString = template.result(binding)
                
                append(outputString)
                
                return
        end
        
        
        def x_rectangle
                
                template = ERB.new %q{
<rect x="25" y="25" width="200" height="200" fill="lime" stroke-width="4" stroke="pink" />
}
                
                outputString = template.result(binding)
                
                append(outputString)
                
                return
        end
        
        
        def x_circle
                
                template = ERB.new %q{
<circle cx="125" cy="125" r="75" fill="orange" />
}
                
                outputString = template.result(binding)
                
                append(outputString)
                
                return
        end
        
        
        def x_polyline
                
                template = ERB.new %q{
<polyline points="50,150 50,200 200,200 200,100" stroke="red" stroke-width="4" fill="none" />
}
                
                outputString = template.result(binding)
                
                append(outputString)
                
                return
        end
        
      

        def x_line
                
                template = ERB.new %q{
<line x1="50" y1="50" x2="200" y2="200" stroke="blue" stroke-width="4" />
}
                
                outputString = template.result(binding)
                
                append(outputString)
                
                return
        end
        
        
#############################################################        
        def background
                
                
                x = @originX
                y = @originY
                
                width = @width
                height = @height
                
                template = ERB.new %q{
<rect x="<%=x%>" y="<%=y%>" width="<%=width%>" height="<%=height%>" fill="lightgray" stroke-width="2" stroke="black" />
}
                
                outputString = template.result(binding)
                
                append(outputString)
                
                return
        end
        
        
        
        def trace(colour,listOfCoords)
                

                
                outputString = ""
                outputString << "<polyline points=\""
                
                listOfCoords.each do
                        |coords|
                        
                        x = coords[0]
                        y = coords[1]
                        
                        x = x + @originX
                        
                        y = ( @height - y ) + @originY
                        
                        x = [ x , ( @originX + @width ) ].min
                        
                       y = [y,@originY].max
                       
                       x = [x,@originX].max
                       
                       y = [ y,@originY + @height ].min
                       
                        
                        outputString << x.to_s << ","
                        
                        outputString << y.to_s << " "
                        
                        
                end
                
                
                outputString << "\" stroke=\""
                outputString <<colour
                outputString << "\" stroke-width=\"4\" fill=\"none\" />"
                
                append(outputString)
                
                return
        end
        
        
	
	 def test
                open
                writeHeader
                        #       x_rectangle
                        #       x_circle
                        #       x_polyline
                        #       x_line
                background 
                
                coordsList = Array.new
                
                coordsList.push  [-10,-15]
                coordsList.push  [0,0]
                coordsList.push  [100,0]
                coordsList.push  [400,50]
                coordsList.push  [500,0]
                coordsList.push  [600,50]
                coordsList.push  [700,25]
                coordsList.push  [800,50]
                coordsList.push  [900,25]
                coordsList.push  [950,620]

               # trace("red", coordsList )
                trace("blue", coordsList )
                        
                writeFooter
                
                close
        end
        
        
        

                
                
	
end # of  classSVGImage




