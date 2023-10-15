/*  Parametric shaft hub generator

    Builds a simple hub with clamping, set screw, or plain mounting to the shaft

    Adjust any variables to customize geometry
    
    Released to the public domain by the author 10/12/23

    Robert Zacharias, rzachari@andrew.cmu.edu
    */
    
// select style of clamping design:
//  "clamp" gives you a hole for a clamping bolt and nut, and matching relief cuts, good for a smooth shaft; "squaredClamp" adds a large flat which uses more material but gives you a stronger grip on the shaft; "setScrew" gives you one hole facing into the shaft and no relief cuts, good for a shaft with a flat; "none" leaves an uncut cylinder, which could work for a press fit onto a splined shaft
clampingDesign = "squaredClamp"; // [clamp, squaredClamp, setScrew, none]


// base that will face surface
baseDiameter = 30;
baseHeight = 4;

// raised portion that will clamp shaft
shaftClampWallThickness = 5;
shaftClampHeight = 10;

// clearance for through shaft
shaftDiameter = 6.35;

// mounting holes (0 to however many you want)
numberMountingHoles = 4; // [0:10]
mountingHolesDiameter = 2;

// set the distance of the mounting holes from the center
holeDist = ((shaftDiameter/2 + shaftClampWallThickness) + (baseDiameter/2)) / 2; // default
//holeDist = 123; // set any value you prefer by uncommenting this line

// move the clamping bolt towards or away from the shaft
// 1 = centered across thickness of clamp wall, lower values are closer to shaft
clampBoltLateralPositionAdjustment = 0.9; // [0.6:0.1:1]

// slot to separate moving part of clamp from base
clampBaseCutoutHeight = 0.5;

// slot for clamping clearance
clampClearanceWidth = 0.5;

// hole for clamping bolt (or set screw)
clampingBoltDiameter = 3;
clampingBoltCounterboreDiameter = 5.5;
clampingNutDiameter = 5.4;
// typically ~0.75 for "clamp", 1 for "squaredClamp"; higher for shallower insets
clampingHardwareProportionalDepth = 1; 


// other variables
// OpenSCAD rendering accuracy (higher draws more faces)
$fn = 100; // [10:10:300]
// small value to move things a smidge off of a surface
epsilon = 0.001; 
           

// drill the shaft hole
difference (){

    // base plus clamping part
    union (){
        // base
//        color("yellow")
        cylinder(h=baseHeight,r=baseDiameter/2);
        
        // clamping part
//        color("green", 0)
        translate([0,0,baseHeight])
            cylinder(h=shaftClampHeight,r=shaftDiameter/2+shaftClampWallThickness);
        
        // add square shoulders if requested
        if (clampingDesign == "squaredClamp"){
//        color("yellow", 0)
            translate([0,-(shaftDiameter/2 + shaftClampWallThickness),baseHeight])
                cube([shaftDiameter/2+shaftClampWallThickness, shaftDiameter+shaftClampWallThickness*2, shaftClampHeight]);
        }
    }

    // shaft hole
    translate([0,0,-1]) cylinder(h=baseHeight+shaftClampHeight+2, r=shaftDiameter/2);
    
    // array of mounting holes
    for (i=[0:numberMountingHoles])
    rotate([0,0,i*(360/numberMountingHoles)]){
       // single mounting hole
       translate([holeDist,0,-epsilon]) 
           cylinder (h=baseHeight+2*epsilon, r=mountingHolesDiameter/2);
    }
       
       
    if (clampingDesign == "clamp" || "squaredClamp"){

        // slot for clamping clearance
        translate([0, -clampClearanceWidth/2, baseHeight+epsilon])
           cube(size=[baseDiameter, clampClearanceWidth, shaftClampHeight+epsilon]);
        
        // triangular slot to separate moving part of square clamp from base
        if (clampingDesign == "squaredClamp"){
            translate([0,0,baseHeight+epsilon])
            rotate([0,0,-45])
               cube(size=[(shaftDiameter+shaftClampWallThickness*2)*sqrt(2), (shaftDiameter+shaftClampWallThickness*2)*sqrt(2), clampBaseCutoutHeight]); 
        }
    
        // rectangular slot to separate moving part of round clamp from base
        if (clampingDesign == "clamp"){
            translate([0,-baseDiameter/2,baseHeight+epsilon])
               cube(size=[baseDiameter/2, baseDiameter, clampBaseCutoutHeight]); 
        }
    
        // hole for clamping bolt
        translate([(shaftDiameter/2 + shaftClampWallThickness/2) * clampBoltLateralPositionAdjustment, baseDiameter/2, baseHeight + shaftClampHeight/2])
            rotate([90, 0, 0])
                cylinder(h=baseDiameter, r=clampingBoltDiameter/2);
           
        // hole for counterbore for clamping bolt, only for regular "clamp" design
        if (clampingDesign == "clamp"){
            translate([(shaftDiameter/2 + shaftClampWallThickness/2) * clampBoltLateralPositionAdjustment, shaftClampWallThickness+shaftDiameter*clampingHardwareProportionalDepth, baseHeight + shaftClampHeight/2])
                rotate([90, 0, 0])
                    cylinder(h=shaftClampWallThickness, r=clampingBoltCounterboreDiameter/2);
        }
    
    
        // cutout for hexagonal nut
        translate([(shaftDiameter/2 + shaftClampWallThickness/2) * clampBoltLateralPositionAdjustment, -(shaftClampWallThickness+shaftDiameter*clampingHardwareProportionalDepth), baseHeight + shaftClampHeight/2])
            rotate([90, 0, 0])
                hexagon(clampingNutDiameter/2,10,true);        
    }
    
    if (clampingDesign == "setScrew"){
        translate([0, 0, baseHeight + shaftClampHeight/2])
            rotate([0, 90, 0])
                cylinder(h=baseDiameter, r=clampingBoltDiameter/2);
    }
}




// this hexagon generator from Michael Chapman (username m66n) on Github: https://gist.github.com/m66n/9d9f92d761aebbf953ca6749d53b8e2e
module hexagon(side, height, center) {
  length = sqrt(3) * side;
  translate_value = center ? [0, 0, 0] :
                             [side, length / 2, height / 2];
  translate(translate_value)
    for (r = [-60, 0, 60])
      rotate([0, 0, r])
        cube([side, length, height], center=true);
}

