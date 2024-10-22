
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

module cameraBracket()
{
    cameraTabWidth = 20;
    backHeight = 60;
    tabDepth = 40;
    servoPadWidth = 45;
    thickness = 4;
    cornerRadius = 5;
    servoHoleRadius = 4.5;
    servoFittingHoleRadius = 1.5;
    fittingoffset = 10.0;
    union(){
        color("red",0.5){
            plate(cameraTabWidth,tabDepth,thickness,cornerRadius,[1,1,0,0]);
        }
        color("blue",0.5){
            translate([cameraTabWidth/2.0,0,backHeight/2.0]){
                rotate(90,[0,1,0]){
                    plate(backHeight,tabDepth,thickness,cornerRadius,[0,0,0,0]);
                }
            }
        }
        color("green",0.5){
            union(){
                translate([servoPadWidth/2.0+cameraTabWidth/2.0+thickness,0,backHeight-thickness]){
                    difference(){
                        plate(servoPadWidth,tabDepth,thickness,tabDepth/2.0,[0,0,1,1]);
                        translate([servoPadWidth/2.0-tabDepth/2.0,0,-extra]){
                            cylinder(h=thickness+(2*extra),r=servoHoleRadius);
                            translate([-fittingoffset,0,0]) cylinder(h=thickness+(2*extra),r=servoFittingHoleRadius);
                            translate([fittingoffset,0,0]) cylinder(h=thickness+(2*extra),r=servoFittingHoleRadius);
                            translate([0,-fittingoffset,0]) cylinder(h=thickness+(2*extra),r=servoFittingHoleRadius);
                            translate([0,fittingoffset,0]) cylinder(h=thickness+(2*extra),r=servoFittingHoleRadius);
                        }
                    }
                }
            }
        }
    }
}

module tiltBracket(){
    tiltTabWidth = 20;
    backHeight = 40;
    tabDepth = 60;
    servoPadDepth = 40;
    servoPadWidth = 40;
    thickness = 4;
    cornerRadius = 10;
    servoHoleRadius = 4.5;
    servoFittingHoleRadius = 1.5;
    servoHoleWidth = 21.0;
    servoHoleDepth = 41.0;
    fittingoffset = 10.0;
    servoHoleWidthSpacing = 9;
    servoHoleDepthSpacing = 48;
    union(){
        color("blue",0.5){
            translate([tiltTabWidth/2.0,0,backHeight/2.0]){
                rotate(90,[0,1,0]){
                    difference(){
                        plate(backHeight,tabDepth,thickness,cornerRadius,[1,1,1,1]);
                        translate([0,0,-extra]){
                            plate(servoHoleWidth,servoHoleDepth,thickness+2*extra,1,[0,0,0,0]);
                            x = servoHoleWidthSpacing/2.0;
                            y = servoHoleDepthSpacing/2.0;
                            translate([-x,-y,0]) cylinder(h=thickness+(2*extra),r=servoFittingHoleRadius);
                            translate([x,y,0]) cylinder(h=thickness+(2*extra),r=servoFittingHoleRadius);
                            translate([-x,y,0]) cylinder(h=thickness+(2*extra),r=servoFittingHoleRadius);
                            translate([x,-y,0]) cylinder(h=thickness+(2*extra),r=servoFittingHoleRadius);
                        }
                    }
                }
            }
        }
        color("green",0.5){
            union(){
                translate([servoPadWidth/2.0+tiltTabWidth/2.0+thickness,0,backHeight-thickness]){
                    difference(){
                        plate(servoPadWidth,servoPadDepth,thickness,servoPadDepth/2.0,[0,0,1,1]);
                        translate([servoPadWidth/2.0-servoPadDepth/2.0,0,-extra]){
                            cylinder(h=thickness+(2*extra),r=servoHoleRadius);
                            translate([-fittingoffset,0,0]) cylinder(h=thickness+(2*extra),r=servoFittingHoleRadius);
                            translate([fittingoffset,0,0]) cylinder(h=thickness+(2*extra),r=servoFittingHoleRadius);
                            translate([0,-fittingoffset,0]) cylinder(h=thickness+(2*extra),r=servoFittingHoleRadius);
                            translate([0,fittingoffset,0]) cylinder(h=thickness+(2*extra),r=servoFittingHoleRadius);
                        }
                    }
                }
            }
        }
    }
}

module tripodBracket(){
    tiltTabWidth = 20;
    backHeight = 45;
    tabDepth = 60;
    servoPadDepth = 40;
    servoPadWidth = 60;
    thickness = 4;
    cornerRadius = 5;
    servoHoleRadius = 4.5;
    servoFittingHoleRadius = 1.5;
    servoHoleWidth = 21.0;
    servoHoleDepth = 41.0;
    fittingoffset = 10.0;
    servoHoleWidthSpacing = 9;
    servoHoleDepthSpacing = 48;
    union(){
        color("blue",0.5){
            translate([tiltTabWidth/2.0,0,backHeight/2.0]){
                rotate(90,[0,1,0]){
                    difference(){
                        plate(backHeight,tabDepth,thickness,cornerRadius,[1,1,1,1]);
                        translate([10,0,-extra]){
                            plate(servoHoleWidth,servoHoleDepth,thickness+2*extra,1,[0,0,0,0]);
                            x = servoHoleWidthSpacing/2.0;
                            y = servoHoleDepthSpacing/2.0;
                            translate([-x,-y,0]) cylinder(h=thickness+(2*extra),r=servoFittingHoleRadius);
                            translate([x,y,0]) cylinder(h=thickness+(2*extra),r=servoFittingHoleRadius);
                            translate([-x,y,0]) cylinder(h=thickness+(2*extra),r=servoFittingHoleRadius);
                            translate([x,-y,0]) cylinder(h=thickness+(2*extra),r=servoFittingHoleRadius);
                        }
                    }
                }
            }
        }
        color("green",0.5){
            union(){
                translate([servoPadWidth/2.0+tiltTabWidth/2.0+thickness,0,backHeight-thickness]){
                    difference(){
                        plate(servoPadWidth,servoPadDepth,thickness,servoPadDepth/2.0,[0,0,1,1]);
                        translate([servoPadWidth/2.0-servoPadDepth/2.0,0,-extra]){
                            cylinder(h=thickness+(2*extra),r=servoHoleRadius);
                        }
                    }
                }
            }
        }
    }
}

module wallBracket(){
    tiltTabWidth = 20;
    backHeight = 50;
    tabDepth = 60;
    servoPadDepth = 40;
    servoPadWidth = 70;
    thickness = 4;
    cornerRadius = 5;
    servoHoleRadius = 2.0;
    servoFittingHoleRadius = 1.5;
    servoHoleWidth = 21.0;
    servoHoleDepth = 41.0;
    fittingoffset = 10.0;
    servoHoleWidthSpacing = 9;
    servoHoleDepthSpacing = 48;
    union(){
        color("blue",0.5){
            translate([tiltTabWidth/2.0,0,backHeight/2.0]){
                rotate(90,[0,1,0]){
                    difference(){
                        plate(backHeight,tabDepth,thickness,cornerRadius,[1,1,1,1]);
                        translate([10,0,-extra]){
                            plate(servoHoleWidth,servoHoleDepth,thickness+2*extra,1,[0,0,0,0]);
                            x = servoHoleWidthSpacing/2.0;
                            y = servoHoleDepthSpacing/2.0;
                            translate([-x,-y,0]) cylinder(h=thickness+(2*extra),r=servoFittingHoleRadius);
                            translate([x,y,0]) cylinder(h=thickness+(2*extra),r=servoFittingHoleRadius);
                            translate([-x,y,0]) cylinder(h=thickness+(2*extra),r=servoFittingHoleRadius);
                            translate([x,-y,0]) cylinder(h=thickness+(2*extra),r=servoFittingHoleRadius);
                        }
                    }
                }
            }
        }
        color("green",0.5){
            union(){
                translate([servoPadWidth/2.0+tiltTabWidth/2.0+thickness,0,backHeight-thickness]){
                    difference(){
                        plate(servoPadWidth,servoPadDepth,thickness,servoPadDepth/2.0,[0,0,1,1]);
                        translate([servoPadWidth/2.0-servoPadDepth/2.0,0,-extra]){
                            cylinder(h=thickness+(2*extra),r=servoHoleRadius);
                        }
                        translate([servoPadWidth/2.0-servoPadDepth/2.0-30,0,-extra]){
                            cylinder(h=thickness+(2*extra),r=servoHoleRadius);
                        }
                    }
                }
            }
        }
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

module fourSlots(width,depth,thickness,slotWidth,slotDepth){
    x=width/2.0 - slotWidth/2.0;
    y=depth/2.0 - slotDepth/2.0;
    translate([-x,-y,-extra]) cube([slotWidth,slotDepth,thickness+(2*extra)]);
    translate([-x,y,-extra]) cube([slotWidth,slotDepth,thickness+(2*extra)]);
    translate([x,-y,-extra]) cube([slotWidth,slotDepth,thickness+(2*extra)]);
    translate([x,y,-extra]) cube([slotWidth,slotDepth,thickness+(2*extra)]);
}

module panTilt ()
{
    union(){
        cameraBracket();
        translate([100,0,0]) tiltBracket();
        translate([200,0,0]) tripodBracket();
        translate([300,0,0]) wallBracket();
    }
}
panTilt();
