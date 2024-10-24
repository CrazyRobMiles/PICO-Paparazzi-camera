$fs=0.1;
extra = 0.5;

module box(width,depth,height){
    translate([-width/2.0, -depth/2.0, 0]){
        cube([width,depth,height]);
    }
}

module plate(width,depth,height, cornerRadius,corners)
{
    translate([-width/2.0, -depth/2.0, 0])
    {
        difference()
        {
            cube([width,depth,height]);
            if (corners[0]==1){
                translate([-extra,-extra,-extra])
                {
                     cube([cornerRadius+extra,cornerRadius+extra,height+2*extra]);
                }
            }
            if (corners[1]==1){
                translate([-extra,depth-cornerRadius,-extra])
                {
                    cube([cornerRadius+extra,cornerRadius+extra,height+2*extra]);
                }
            }
            if (corners[2]==1){
                translate([width-cornerRadius,depth-cornerRadius,-extra])
                { 
                    cube([cornerRadius+extra,cornerRadius+extra,height+2*extra]);
                }
            }
            if (corners[3]==1){
                translate([width-cornerRadius,-extra,-extra])
                {
                    cube([cornerRadius+extra,cornerRadius+extra,height+2*extra]);
                }
            }
        }
        translate([cornerRadius,cornerRadius,0]) cylinder(r=cornerRadius,h=height);
        translate([width-cornerRadius,cornerRadius,0]) cylinder(r=cornerRadius,h=height);
        translate([cornerRadius,depth-cornerRadius,0]) cylinder(r=cornerRadius,h=height);
        translate([width-cornerRadius,depth-cornerRadius,0]) cylinder(r=cornerRadius,h=height);
    }
}   

module fourHoles(width,depth,thickness,radius){
    x=width/2.0;
    y=depth/2.0;
    translate([-x,-y,-extra]) cylinder(h=thickness+(2*extra),r=radius);
    translate([x,y,-extra]) cylinder(h=thickness+(2*extra),r=radius);
    translate([-x,y,-extra]) cylinder(h=thickness+(2*extra),r=radius);
    translate([x,-y,-extra]) cylinder(h=thickness+(2*extra),r=radius);
}

module fourHolesCross(width,depth,thickness,radius){
    x=width/2.0;
    y=depth/2.0;
    translate([-x,-0,-extra]) cylinder(h=thickness+(2*extra),r=radius);
    translate([x,0,-extra]) cylinder(h=thickness+(2*extra),r=radius);
    translate([0,y,-extra]) cylinder(h=thickness+(2*extra),r=radius);
    translate([0,-y,-extra]) cylinder(h=thickness+(2*extra),r=radius);
}

module fourSlots(width,depth,thickness,slotWidth,slotDepth){
    x=width/2.0 ;
    y=depth/2.0 ;
    translate([-slotWidth/2.0, -slotDepth/2.0,0]) {
        translate([-x,-y,-extra]) cube([slotWidth,slotDepth,thickness+(2*extra)]);
        translate([-x,y,-extra]) cube([slotWidth,slotDepth,thickness+(2*extra)]);
        translate([x,-y,-extra]) cube([slotWidth,slotDepth,thickness+(2*extra)]);
        translate([x,y,-extra]) cube([slotWidth,slotDepth,thickness+(2*extra)]);
    }
}    
    
module fourSlotsCross(width,depth,thickness,slotWidth,slotDepth){
    x=width/2.0 ;
    y=depth/2.0 ;
    translate([-slotWidth/2.0, -slotDepth/2.0,0]) {
        translate([-x,0,-extra]) cube([slotWidth,slotDepth,thickness+(2*extra)]);
        translate([x, 0,-extra]) cube([slotWidth,slotDepth,thickness+(2*extra)]);
        translate([0,-y,-extra]) cube([slotWidth,slotDepth,thickness+(2*extra)]);
        translate([0,y,-extra]) cube([slotWidth,slotDepth,thickness+(2*extra)]);
    }
}    



module fourMountingHoles(width,depth,thickness,sideHeight,radius){
    x=width/2.0 ;
    y=depth/2.0 ;
    z = thickness+(sideHeight/2.0);
    
    translate([-x,y,-extra]) cylinder(r=radius,h=sideHeight,center=true);
}


plateWidth=35;
plateDepth=22;
cornerRadius=5.0;
cornerHoleInset = 10.0;
cornerHoleRadius = 1.0;
centreHoleRadius = 3.5;
centreSupportWidth = 4.0;
centerSupportHeight = 15.0;
cameraHoleInset = 15.0;
plateThickness = 2.5;

backplateCornerHoleInset = 3;
backplateCornerHoleRadius = 0.7;

module backplate(){
    difference(){
        union(){
            plate(plateWidth,plateDepth,plateThickness,cornerRadius,[1,1,1,1]);
            translate([0,0,plateThickness]) cylinder(r1=centreHoleRadius+centreSupportWidth,r2=centreHoleRadius+centreSupportWidth-1.5,h=centerSupportHeight);
        }
        fourHolesCross(plateWidth-backplateCornerHoleInset,plateDepth-backplateCornerHoleInset,plateThickness,backplateCornerHoleRadius);
        translate([0,0,centerSupportHeight-centreHoleRadius]) sphere(r=centreHoleRadius);
        cylinder(h=10,r1=8,r2=centreHoleRadius-0.45);
    }
}

module universalBackplate(){
    difference(){
        union(){
            plate(plateWidth,plateDepth,plateThickness,cornerRadius,[1,1,1,1]);
            translate([0,0,plateThickness/2]){
                universalSupport();
            }
        }
        fourHolesCross(plateWidth-backplateCornerHoleInset,plateDepth-backplateCornerHoleInset,plateThickness,backplateCornerHoleRadius);
        translate([0,0,centerSupportHeight-centreHoleRadius]) sphere(r=centreHoleRadius);
        cylinder(h=10,r1=8,r2=centreHoleRadius-0.45);
    }
}

servoSlotWidth=10;
servoShotDepth=25;
backPlateWidth=169;
backPlateDepth=169;
servoMountSpacing = 28;
servoAxisOffset = 20;
servoBlockDepth=4;
servoFixingHoleRadius=1;
servoPillarThickness=13;
servoOffsetFromHole=30;
servoOffsetFromAxis=5;
servoOuterDepth=35.0;
servoBodyDepth=23.0;
servoMountDepth=5.0;

supportCornerHoleRadius = 1.5;
supportCornerHoleInset=2.5;
baseWidth=40;

servoInset=30.0;

servoAreaWidth=40;
servoAreaDepth=40;

pillarHoleTopRadius=3.0;
pillarHoleBottomRadius = 3.5;
pillarHoleRadius = 1.55;

personSensorWidth = 28;
personSensorDepth = 22;
sensorUnitWidth=20;
sensorHoleSpacing=18;
personSensorHoleInset=3.5;
 
cameraHoleRadius = 4.5;
personSensorYPos = 60;
personSensorPillarRadius = 3;
personSensorPillarHoleRadius = 1.0;
personSensorPillerHeight=3;

module pillar(height,pillarRadius,holeRadius){
    difference(){
        cylinder(h=height,r=pillarRadius);
        cylinder(h=height,r=holeRadius);
    }
}

module mountingPillars(xSpacing,ySpacing,pillarHeight,pillarRadius, pillarHoleRadius){
    x=xSpacing/2;
    y=ySpacing/2;
    translate([-x,-y,0]) pillar(pillarHeight,pillarRadius,pillarHoleRadius);
    translate([-x,y,0]) pillar(pillarHeight,pillarRadius,pillarHoleRadius);
    translate([x,-y,0]) pillar(pillarHeight,pillarRadius,pillarHoleRadius);
    translate([x,y,0]) pillar(pillarHeight,pillarRadius,pillarHoleRadius);
}

module addServo(plate,thickness){
    union(plate){
        translate([0,0,thickness]){
            difference(){
                box(servoPillarThickness,servoOuterDepth,servoMountDepth);
                box(servoPillarThickness,servoBodyDepth,servoMountDepth);
            }
        }
    }
}


module servoPlate(){
    
    difference(){
        union(){
            plate(backPlateWidth,backPlateDepth,plateThickness,cornerRadius,[1,1,1,1]);
            translate([0,0,plateThickness]){
                difference(){
                    fourSlots(servoAreaWidth,servoAreaDepth+servoOffsetFromHole,servoPillarThickness,servoOuterDepth,servoMountDepth);
                    fourSlots(servoAreaWidth,servoAreaDepth+servoOffsetFromHole,servoPillarThickness,servoBodyDepth,servoMountDepth);
                }
            }
            translate([(personSensorWidth/2)-personSensorHoleInset+3,personSensorYPos+(personSensorDepth/2.0)-personSensorHoleInset,plateThickness]){
                pillar(personSensorPillerHeight, personSensorPillarRadius, personSensorPillarHoleRadius);
                translate([0,-(personSensorDepth-(2*personSensorHoleInset)),0]){
                    pillar(personSensorPillerHeight, personSensorPillarRadius, personSensorPillarHoleRadius);
                }
            }
            
            translate([-20,-60,plateThickness]){
                mountingPillars(47,11.4,4,3,1);
                translate([80,50,0]){
                    mountingPillars(18,56,4,3,1);
                }
            }
        }
        
        cylinder(h=plateThickness,r=pillarHoleRadius);

        fourSlots(servoAreaWidth,servoAreaDepth,plateThickness,servoShotDepth,servoSlotWidth);
        
        translate([sensorUnitWidth-personSensorWidth+8,personSensorYPos,0])cylinder(h=plateThickness,r=cameraHoleRadius);
    }

}

module fullServoPlate()
{
    
    plate(backPlateWidth,backPlateDepth,plateThickness,cornerRadius,[1,1,1,1]);
    
    
}

supportBaseRadius = 15;
rodwidth=60;
rodRadius=2.0;
rodSphereRadius = 3.45;
rodScrewHoleRadius = 1.4;
rodScrewHoleHeight = 10;


module centreSupport(){
    difference(){
        union(){
            cylinder(h=rodwidth,r1=rodRadius+3,r2=rodRadius);
            translate([0,0,rodwidth]){
                sphere(r=rodSphereRadius);
            }
        }
        cylinder(h=rodScrewHoleHeight,r1=rodScrewHoleRadius+0.1,r2=rodScrewHoleRadius);
    }
}

ujRadius=4.65;
ujHeight=6.0;
sleeveThickness=2.0;
grubScrewHeight=2.5;
grubScrewRadius = 1.7;

module universalSupport(){
    difference(){
        // Make the outer cylinder
        cylinder(h=ujHeight+sleeveThickness,r=ujRadius++sleeveThickness);
        translate([0,0,sleeveThickness])cylinder(h=ujHeight,r=ujRadius);
        translate([0,0,grubScrewHeight+sleeveThickness]){
            rotate([0,90,0]){
                cylinder(h=ujRadius+sleeveThickness,r=grubScrewRadius);
            }
        }
    }
}

module universalCentreSupport(){
    difference(){
        union(){
            cylinder(h=rodwidth,r=ujRadius+sleeveThickness);
            translate([0,0,rodwidth]){
                universalSupport();
            }
        }
        cylinder(h=rodScrewHoleHeight,r1=rodScrewHoleRadius+0.1,r2=rodScrewHoleRadius);
    }
}


union(){
    backplate();
    translate ([0,-100,0]) servoPlate();
    translate ([0,-200,0]) centreSupport();
    translate ([0,-250,0]) universalBackplate();
    translate ([0,-300,0]) universalCentreSupport();
}



