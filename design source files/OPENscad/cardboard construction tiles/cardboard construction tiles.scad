/*

Makes a disc with radial rectangluar cutouts, meant for lasercutting out of cardboard for making simple building blocks

Written by Robert Zacharias 6/29/26. Claude helped me get the rotation and translation in the right order to get the radial arrangement correct, and to get the Hershey text library to play nice with my 2d geometry.

Adding semicircle design 8/4/26.

*/

// library sourced from user arpruss via Thingiverse, licensed CC BY: https://www.thingiverse.com/thing:2404566
include <hershey.scad>

/* [Mode] */
// circleWithSlots is a circle with radial slots around the edge. variableSidedRectangle is sized based on the number of slots along the top/bottom and left/right edges.
mode = "circleWithSlots"; // ["circleWithSlots", "semicircleWithSlots", "variableSidedRectangle"]

/* [Options for all designs] */

// depth of slots
throatDepth = 10;
// width of slots
cutWidth = 2;

/* [Circle with Slots and Semicircle with Slots options] */

diameter = 50;
numCuts = 8;
radialTranslateValue = diameter/2 - throatDepth;

/* [Variable Sided Rectangle options] */

numTopBottomSlots = 8;
numLeftRightSlots = 3;
slotSpacing = 15;


/* [Text to be written in the center of the shape] */
writeText = true;

// An array of lines of text (there are no automatic line breaks)
textLines = ["What's something that", "you recently made?", "And did it work?", "Or was it a beautiful failure?"];
fontChoice = "Script"; // ["Script", "Sans", "Serif"]
textHeight = 2;
lineHeightMultiplier = 1.2;

difference(){
    if (mode == "circleWithSlots"){
        difference(){
            circle(d = diameter, $fn = 100);
            for (i = [0 : numCuts - 1]) {
                rotate([0, 0, i * 360 / numCuts])
                translate([0, radialTranslateValue, 0])
                rectCutout();
            }
            if (writeText){
                // vertically center the text block
                translate([0, (textHeight*lineHeightMultiplier*(len(textLines)-1))/2, 0])
                    for( i = [0 : len(textLines) - 1]){
                        translate([0, -i * textHeight * lineHeightMultiplier, 0])
                            drawHersheyText(textLines[i], size=textHeight, font=fontChoice, halign="center") {
                                circle(r=0.0001, $fn=3);
                            }
                    }
            }
        }
    }
    
    if (mode == "semicircleWithSlots"){
        difference(){
            circle(d = diameter, $fn = 100);
            for (i = [0 : numCuts - 1]) {
                rotate([0, 0, 270 + ( 180 / (numCuts + 1) * (i + 1))])
                translate([0, radialTranslateValue, 0])
                rectCutout();
            }
            if (writeText){
                // vertically center the text block
                translate([0, (textHeight*lineHeightMultiplier*(len(textLines)-1)), 0])
                    for( i = [0 : len(textLines) - 1]){
                        translate([0, -i * textHeight * lineHeightMultiplier, 0])
                            drawHersheyText(textLines[i], size=textHeight, font=fontChoice, halign="center") {
                                circle(r=0.0001, $fn=8);
                            }
                    }
            }
            translate([-(diameter+1)/2, -diameter/2, 0])
                square(size = [diameter + 1, (diameter)/2]);
        }
    }
        
    if (mode == "variableSidedRectangle"){
        rectWidth = (numTopBottomSlots + 1) * slotSpacing;
        rectHeight = (numLeftRightSlots + 1) * slotSpacing;
        
        difference(){
            polygon(points = [
                [0, 0],
                [0, rectHeight],
                [rectWidth, rectHeight],
                [rectWidth, 0]
            ]);
            
            // top row slots
            for ( i = [0 : numTopBottomSlots - 1] ){
                translate([(i * slotSpacing) + slotSpacing, rectHeight - throatDepth, 0]) 
                    rectCutout(); 
            }
            
            // bottom row slots
            for ( i = [0 : numTopBottomSlots - 1] ){
                translate([(i * slotSpacing) + slotSpacing, 0, 0]) 
                    rectCutout(); 
            }
            
            // left row slots
            for ( i = [0 : numLeftRightSlots -1 ] ){
                translate([0, (i * slotSpacing) + slotSpacing, 0]) 
                    rotate([0,0,270])
                        rectCutout(); 
            }
            
            // right row slots
            for ( i = [0 : numLeftRightSlots -1 ] ){
                translate([rectWidth - throatDepth, (i * slotSpacing) + slotSpacing, 0]) 
                    rotate([0,0,270])
                        rectCutout(); 
            }
            
            if (writeText){
                // vertically center the text block
                translate([0, (textHeight*lineHeightMultiplier*(len(textLines)-1))/2, 0])
                    for( i = [0 : len(textLines) - 1]){
                        translate([rectWidth/2, (-i * textHeight * lineHeightMultiplier) + rectHeight/2, 0])
                            drawHersheyText(textLines[i], size=textHeight, font=fontChoice, halign="center") {
                                circle(r=0.0001, $fn=8);
                            }
                    }
            }
            
        }
        
    }
    
}



module rectCutout(){
    polygon(points = [
        [-cutWidth/2, 0],
        [-cutWidth/2, throatDepth],
        [cutWidth/2, throatDepth],
        [cutWidth/2, 0]
    ]);
}