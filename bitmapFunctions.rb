#!/usr/bin/ruby
#File: bitmapFunctions.rb
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

# bitmapFunctions.rb


def checkCompatiblity(bitmapA,bitmapB)
        
        result = true
        
        if ( bitmapA.getId              != bitmapB.getId         ) ; result = false ; end
        if ( bitmapA.getSize            != bitmapB.getSize       ) ; result = false ; end
        if ( bitmapA.getOffset          != bitmapB.getOffset     ) ; result = false ; end
        if ( bitmapA.getHeaderSize      != bitmapB.getHeaderSize ) ; result = false ; end
        if ( bitmapA.getWidth           != bitmapB.getWidth      ) ; result = false ; end
        if ( bitmapA.getHeight          != bitmapB.getHeight     ) ; result = false ; end
        if ( bitmapA.getPlanes          != bitmapB.getPlanes     ) ; result = false ; end
        if ( bitmapA.getBpp             != bitmapB.getBpp        ) ; result = false ; end
        
        return result
end


def  compareImages( inputImageA, inputImageB, outputImageA)
        
        contentsA = IO.binread(inputImageA.getName)
        contentsB = IO.binread(inputImageB.getName)
 
        subPixelMatrixA = contentsA [ inputImageA.getOffset ..  inputImageA.getSize ]
        subPixelMatrixB = contentsB [ inputImageB.getOffset ..  inputImageB.getSize ]
        
        pixels = subPixelMatrixA.size /   ( inputImageA.getBpp / 8 )
        
        xMax =  inputImageA.getWidth - 1
        
        yMax =  inputImageA.getHeight - 1
        
        
        # Preview file
        max = -999999999999
        min =  999999999999
        count = 0
        runningTotal = 0.00
        
        for y in 0 .. yMax
                
                #print "\n"
                
                for x in 0 .. xMax 
                        
                        address = ( x * 3 ) + ( ( ( xMax + 1 ) * 3 ) * y )
                        
                        blueA = subPixelMatrixA[address].ord
                        greenA = subPixelMatrixA[address].ord
                        redA = subPixelMatrixA[address].ord
                        meanA = (  blueA + greenA + redA ) / 3 
                        greynessA = blueA + ( 256 * greenA ) + ( 65536 * redA )
                        
                        blueB = subPixelMatrixB[address].ord
                        greenB = subPixelMatrixB[address].ord
                        redB = subPixelMatrixB[address].ord
                        meanB = (  blueB + greenB + redB ) / 3 
                        greynessB = blueB + ( 256 * greenB ) + ( 65536 * redB )
                        deltaGreyness = greynessB - greynessA
                        deltaGreyness = deltaGreyness.abs
                        
                        max = [ max ,  deltaGreyness ].max 
                        
                        min = [ min ,  deltaGreyness ].min 
                        
                        count = count + 1
                        
                        runningTotal = runningTotal + deltaGreyness
                        
                        mean = runningTotal / count
        
                end
                                
        end
        
        span = [1.0, ( max - min ) ].max ; # avoid divide by zero
        adjustment = span.to_f
        disturbance = mean / span.to_f 
        #print "\nmax = ",max," min = ",min," span = ",span,"  adjustment = ", adjustment," runningTotal = ",runningTotal," mean = ",mean," disturbance = ",disturbance
        
       
  
  
        for y in 0 .. yMax
                
                
                for x in 0 .. xMax 
                        
                        address = ( x * 3 ) + ( ( ( xMax + 1 ) * 3 ) * y )
                        
                        blueA = subPixelMatrixA[address].ord
                        greenA = subPixelMatrixA[address].ord
                        redA = subPixelMatrixA[address].ord
                        meanA = (  blueA + greenA + redA ) / 3 
                        greynessA = blueA + ( 256 * greenA ) + ( 65536 * redA )
                        
                        blueB = subPixelMatrixB[address].ord
                        greenB = subPixelMatrixB[address].ord
                        redB = subPixelMatrixB[address].ord
                        meanB = (  blueB + greenB + redB ) / 3 
                        greynessB = blueB + ( 256 * greenB ) + ( 65536 * redB )
                        deltaGreyness = greynessB - greynessA
                        deltaGreyness = deltaGreyness.abs
                        
                        # The monochrome difference
                        if ( false )
                        
                                if ( deltaGreyness < 1000000 )
                                        deltaGreyness = $WHITE
                                end

                                outputImageA.colour(deltaGreyness)
                        
                        end
                
                        # The colourised difference 
                        if ( true )
                                
                                delta = deltaGreyness.to_f
                        
                                ratio = delta / adjustment
                                
                                
                                if ( adjustment == 1.0 )
                                        
                                        outputImageA.colour($GREY)
                                        
                                else
                                        
                                         outputImageA.colourRatio(ratio)
                                        
                                end
                                
                        
                        end
                        
                        
                        outputImageA.pixel(x,y)

                end
                                
        end
        
 
        return disturbance
end
