/*  Parametric shaft hub generator

    Builds a simple hub with clamping, set screw, or plain mounting to the shaft

    Adjust any variables to customize geometry, or use Customizer feature to do the same
   
    Released to the public domain by the author 8/7/24

    Robert Zacharias, rzachari@andrew.cmu.edu
    */
   
/* [Clamp style and overall dimensions] */

//  "roundClamp" gives you a hole for a clamping bolt and nut, and matching relief cuts, good for a smooth shaft; "squaredClamp" adds a large flat which uses more material but gives you a stronger grip on the shaft; "setScrew" gives you one hole facing into the shaft and no relief cuts, good for a shaft with a flat; "none" leaves an uncut cylinder, which could work for a press fit onto a splined shaft
clampingDesign = "squaredClamp"; // [roundClamp, squaredClamp, setScrew, none]

// modify to remove overhangs shallower than 45º
optimizeFor3Dprinting = true;

// diameter of base that will face surface
baseDiameter = 30;
// height of base that will face surface
baseHeight = 4;

// thickness of raised portion that will clamp shaft
shaftClampWallThickness = 5;
// height of raised portion that will clamp shaft
shaftClampHeight = 10;

// clearance for through shaft
shaftDiameter = 6.7;

// mounting holes (0 to however many you want)
numberMountingHoles = 4; // [0:10]
mountingHolesDiameter = 3.5; // [2:.1:5]

// set the distance of the mounting holes from the center
holeDist = ((shaftDiameter/2 + shaftClampWallThickness) + (baseDiameter/2)) / 2;
// holeDist = 12; // set any value you prefer by uncommenting this line

/* [Clamping bolt options] */

// move the clamping bolt towards or away from the shaft; 1 = centered across thickness of clamp wall, lower values are closer to shaft
clampBoltLateralPositionAdjustment = 0.9; // [0.8:0.05:1]

// move the clamping bolt up or down—especially useful if you're optimizing for 3D printing and wish to move the bolt hole away from the chamfered clamp wall
clampBoltVerticalPositionAdjustment = 0; // [0:1:5]

// slot to separate moving part of clamp from base
clampBaseCutoutHeight = 1;

// slot for clamping clearance
clampClearanceWidth = 2.5; // [0.5:0.25:5]

// imperial fractions are baked into customizer values below as rounded
// to nearest thousandth (I can't feed the customizer fractions in its
// inline format)

// hole for clamping bolt (or set screw)
clampingBoltDiameter = 3.5; // [3:M3, 4:M4]
clampingBoltCounterboreDiameter = 5.5; // [5.5:M3]
clampingBoltCounterboreAdditionalInsetDepth = 1;
clampingNutDiameter = 6.5; // [6.35:M3, 8.08:M4, 0.397:#8-32, 0.506:1/4-20]
clampingNutDepth = 2; // [2.4:M3, 3.2:M4, 0.125:#8-32, 0.219:1/4-20]
// move the nut cutout deeper into the clamp
clampingNutAdditionalInsetDepth = 0;
// typically ~0.75 for "roundClamp", 1 for "squaredClamp"; higher for shallower insets
clampingHardwareProportionalDepth = 1; // [0.25:0.1:1.5]

/* [Emboss version text] */
// emboss text of part version onto top of base
embossVersion = true; //
version = "v5";


/* [Rendering accuracy] */
// OpenSCAD rendering accuracy (higher draws more faces)
$fn = 100; // [10:10:300]

/* [Hidden] */
// small value to move things a smidge off of a surface
epsilon = 0.001;


// you can't create and then modify a global variable
// so instead, this function is used to move clamping hardware
// upwards when optimizing for 3D printing
function clampingHardwareAdjustmentFor3Dprinting() = optimizeFor3Dprinting ? 1.5 : 2;
usuallyTwo = clampingHardwareAdjustmentFor3Dprinting();          

           
difference (){

    // base plus clamping part
    union (){        
               
        // base
        cylinder(h=baseHeight,r=baseDiameter/2);
       
        // clamping part
        translate([0,0,baseHeight])
            cylinder(h=shaftClampHeight,r=shaftDiameter/2+shaftClampWallThickness);
       
        // add square shoulders if requested
        if (clampingDesign == "squaredClamp"){
            translate([0,-(shaftDiameter/2 + shaftClampWallThickness),baseHeight])
                cube([shaftDiameter/1.5+shaftClampWallThickness, shaftDiameter+shaftClampWallThickness*2, shaftClampHeight]);
        }
    }

    // shaft hole
    translate([0,0,-epsilon]) cylinder(h=baseHeight+shaftClampHeight+(epsilon*2), r=shaftDiameter/2);
   
    // array of mounting holes
    if (numberMountingHoles > 0){
        for (i=[0:numberMountingHoles])
            rotate([0,0,i*(360/numberMountingHoles)]){
                // single mounting hole
                translate([holeDist,0,-epsilon])
                    cylinder (h=baseHeight+2*epsilon, r=mountingHolesDiameter/2);
        }
    }
   
    if (optimizeFor3Dprinting && (clampingDesign == "squaredClamp" || clampingDesign == "roundClamp")){
           
               
        // teardrop cutout at top of clamping bolt hole
        // this prevents overhang greater than 45º
        translate([(shaftDiameter/2 + shaftClampWallThickness/2) * clampBoltLateralPositionAdjustment, 0, baseHeight + shaftClampHeight/usuallyTwo + (clampingBoltDiameter / 8) + clampBoltVerticalPositionAdjustment]) // the last value there is empirical and wonky
            rotate([90, 0, 0])
                linear_extrude(baseDiameter, center = true, convexity = 1)
                    polygon([[-clampingBoltDiameter/2, 0], [clampingBoltDiameter/2, 0], [0, (clampingBoltDiameter/2)*sqrt(2)]]);
               
        // additional equilateral triangle cutout at top of bolt cutout to prevent overhang
               translate([(shaftDiameter/2 + shaftClampWallThickness/2) * clampBoltLateralPositionAdjustment, -(shaftClampWallThickness+shaftDiameter/2)+(clampingNutDepth/2)-epsilon, baseHeight + shaftClampHeight/usuallyTwo + clampBoltVerticalPositionAdjustment])
            rotate([90, 0, 0])
                linear_extrude(clampingNutDepth, center = true, convexity = 1)
                    polygon([[-clampingNutDiameter/2, 0], [clampingNutDiameter/2, 0], [0, clampingNutDiameter/2 * sqrt(3)]]);
               
        if (clampingDesign == "squaredClamp"){
            // 45º chamfer at base of clamping body
            translate([(shaftDiameter/1.5 + shaftClampWallThickness), 0, baseHeight + clampBaseCutoutHeight])
                rotate([90, 0, 0])
                    linear_extrude(baseDiameter, center = true, convexity = 1)
                        polygon([[epsilon, epsilon], [epsilon, shaftClampWallThickness + clampBaseCutoutHeight + epsilon], [-(shaftClampWallThickness + clampBaseCutoutHeight), 0]]);
            
            // remove redundant upper outer piece of nut cutout
            translate([(shaftDiameter/2 + shaftClampWallThickness/2) * clampBoltLateralPositionAdjustment, -(shaftClampWallThickness+shaftDiameter/2)+(clampingNutDepth)-epsilon, baseHeight + shaftClampHeight/usuallyTwo + clampBoltVerticalPositionAdjustment])
            mirror([0,1,0])
                cube(shaftClampWallThickness, center = false);
        }
       
        if (clampingDesign == "roundClamp"){
            // 45º chamfer at base of clamping body
            translate([(shaftDiameter/2 + shaftClampWallThickness), 0, baseHeight + clampBaseCutoutHeight])
                rotate([90, 0, 0])
                    linear_extrude(baseDiameter, center = true, convexity = 1)
                        polygon([[epsilon, epsilon], [epsilon, shaftClampWallThickness + shaftDiameter/2 + epsilon], [-(shaftClampWallThickness + shaftDiameter/2), 0]]);
        }
           
        }
       
       
    if (clampingDesign == "roundClamp" || clampingDesign == "squaredClamp"){

        // slot for clamping clearance
        translate([0, -clampClearanceWidth/2, baseHeight+epsilon])
           cube(size=[baseDiameter, clampClearanceWidth, shaftClampHeight+epsilon]);
       
        // hole for clamping bolt
        translate([(shaftDiameter/2 + shaftClampWallThickness/2) * clampBoltLateralPositionAdjustment, baseDiameter/2, baseHeight + shaftClampHeight/usuallyTwo + clampBoltVerticalPositionAdjustment])
            rotate([90, 0, 0])
                cylinder(h=baseDiameter, r=clampingBoltDiameter/2);
   
        // cutout for hexagonal nut
        translate([(shaftDiameter/2 + shaftClampWallThickness/2) * clampBoltLateralPositionAdjustment, -(shaftClampWallThickness+shaftDiameter/2)+(clampingNutDepth/2)-epsilon, baseHeight + shaftClampHeight/usuallyTwo + clampBoltVerticalPositionAdjustment])
            rotate([90, 0, 0])
                hexagon(clampingNutDiameter/2, clampingNutDepth+clampingNutAdditionalInsetDepth, true);  
       
       
    }
   
   
            // triangular slot to separate moving part of square clamp from base
    if (clampingDesign == "squaredClamp"){
        translate([0,0,baseHeight+epsilon])
            rotate([0,0,-45])
                cube(size=[(shaftDiameter+shaftClampWallThickness*2)*sqrt(2), (shaftDiameter+shaftClampWallThickness*2)*sqrt(2), clampBaseCutoutHeight]);
           
        // and another rectangular slot to allow clearance for moving part of square clamp
        translate([(shaftDiameter/2),-baseDiameter/2,baseHeight+epsilon])
           cube(size=[baseDiameter/2, baseDiameter, clampBaseCutoutHeight]);
    }
   
   
    // rectangular slot to separate moving part of round clamp from base
    if (clampingDesign == "roundClamp"){
        translate([0,-baseDiameter/2,baseHeight+epsilon])
           cube(size=[baseDiameter/2, baseDiameter, clampBaseCutoutHeight]);
   
        // hole for counterbore for clamping bolt, only for "round clamp" design
        translate([(shaftDiameter/2 + shaftClampWallThickness/2) * clampBoltLateralPositionAdjustment, shaftClampWallThickness+shaftDiameter*clampingHardwareProportionalDepth - clampingBoltCounterboreAdditionalInsetDepth, baseHeight + shaftClampHeight/usuallyTwo + clampBoltVerticalPositionAdjustment])
            rotate([90, 0, 0])
                cylinder(h=shaftClampWallThickness, r=clampingBoltCounterboreDiameter/2);
        }
   
    if (clampingDesign == "setScrew"){
        translate([0, 0, baseHeight + shaftClampHeight/2])
            rotate([0, 90, 0])
                cylinder(h=baseDiameter, r=clampingBoltDiameter/2);
    }
    
    if (embossVersion){
        translate([-baseDiameter/4, baseDiameter/4, baseHeight-1+epsilon])
            linear_extrude(1){
                text(version, size = 4, font=":style=Bold", halign = "center");
        }
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
