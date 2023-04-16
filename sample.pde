import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import controlP5.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 


ControlP5 cp5;

int Bgcolor;
int Width;
int Length;
float Weight;
float Gap;
float r1;
float r2;
int C1;
int C2;
int C3;
int col_l;
int col_c;
int circular=1;

int COLOR;

int Cx=1000, Cy=1000;//canvas size

int i,j,a=0,b=0;
int coord =2;
float rAngle = 360;
int Helix;//helix per cycle
float del;
float gap;
float[][] r1p, r2p, r1m, r2m, r1n, r2n;


public float myCircle(float x, float y){
   return sqrt(sq(x)-sq(y));
}

public void setup(){

   size(Cx,Cy);
   //colorMode(RGB,100,100,100);
   background(0,0,0);
   C1 = color(255, 255, 255);
   C2 = color(31, 128, 255);
   C3 = color(15, 64, 128);
   
   col_c = C2;
   col_l = C3;
   
   //noLoop();
   noStroke();
  
  slider("Length", 160, 40, 400, 200);
  slider("Width", 160, 80, 100, 25);
  slider("Helix", 450, 40, 100, 50);
  slider("Gap", 450, 80, 0.5f, 0.25f);
  slider("Weight", 740, 40, 10, 2);
  slider2("Bgcolor", 740, 80, 255, 12);
  col("COLOR", 20, 720);


}

public void col(String name, int x, int y){

   cp5 = new ControlP5(this);  
  
  //Color wheel
  cp5.addColorWheel(name)
  .setPosition(x, y)
  .setRGB(C2);  
}


public void button(String name, int x, int y, int col){

   cp5 = new ControlP5(this);
  
    cp5.addButton(name)
    .setLabel(name)//\u30c6\u30ad\u30b9\u30c8
    .setPosition(x, y)
    .setSize(100, 40)
    .setColorBackground(col) //\u901a\u5e38\u6642\u306e\u8272
    //.setColorForeground(C2) //hover\u3057\u305f\u3068\u304d\u306e\u8272    
    .setColorCaptionLabel(C1); //\u30c6\u30ad\u30b9\u30c8\u306e\u8272
}

public void slider(String name, int x, int y, float range, float initial){

  cp5 = new ControlP5(this);

  int myColor = color(255, 0, 0);

  cp5.addSlider(name)
    .setLabel(name)
    .setRange(0, range)//range
    .setValue(initial)//initial value
    .setPosition(x, y)//position
    .setSize(200, 20)//size
    .setNumberOfTickMarks(21);//Range\u3092(\u5f15\u6570\u306e\u6570-1)\u3067\u5272\u3063\u305f\u5024\u304c1\u30e1\u30e2\u30ea\u306e\u5024

  //\u30b9\u30e9\u30a4\u30c0\u30fc\u306e\u73fe\u5728\u5024\u306e\u8868\u793a\u4f4d\u7f6e
  cp5.getController(name)
    .getValueLabel()
    .align(ControlP5.RIGHT, ControlP5.BOTTOM_OUTSIDE)//\u4f4d\u7f6e\u3001\u5916\u5074\u306e\u53f3\u5bc4\u305b
    .setPaddingX(-30);//padding\u5024\u3092\u3068\u308b aline\u3067\u8a2d\u5b9a\u3057\u305fRIGHT\u304b\u3089\u306epadding  
}

public void slider2(String name, int x, int y, float range, float initial){

  cp5 = new ControlP5(this);

  int myColor = color(255, 0, 0);

  cp5.addSlider(name)
    .setLabel(name)
    .setRange(0, range)//range
    .setValue(initial)//initial value
    .setPosition(x, y)//position
    .setSize(200, 20)//size
    .setColorActive(color(200))
    .setColorBackground(color(0)) //\u30b9\u30e9\u30a4\u30c0\u306e\u80cc\u666f\u8272 \u5f15\u6570\u306fint\u3068\u304bcolor\u3068\u304b
    .setColorForeground(color(100)) //\u30b9\u30e9\u30a4\u30c0\u306e\u8272
    .setNumberOfTickMarks(21);//Range\u3092(\u5f15\u6570\u306e\u6570-1)\u3067\u5272\u3063\u305f\u5024\u304c1\u30e1\u30e2\u30ea\u306e\u5024

  //\u30b9\u30e9\u30a4\u30c0\u30fc\u306e\u73fe\u5728\u5024\u306e\u8868\u793a\u4f4d\u7f6e
  cp5.getController(name)
    .getValueLabel()
    .align(ControlP5.RIGHT, ControlP5.BOTTOM_OUTSIDE)//\u4f4d\u7f6e\u3001\u5916\u5074\u306e\u53f3\u5bc4\u305b
    .setPaddingX(-30);//padding\u5024\u3092\u3068\u308b aline\u3067\u8a2d\u5b9a\u3057\u305fRIGHT\u304b\u3089\u306epadding  
}

public void draw(){
  //lights();
  background(Bgcolor);

  button("Circular", 40, 40, col_c);
  button("Linear", 40, 80, col_l);
  
  if(circular == 1) circular_DNA();
  else linear_DNA();
}

public void Circular(){
  circular = 1;
  col_l = C3;
  col_c = C2;
  
}

public void Linear(){
  circular = 0;
  col_l = C2;
  col_c = C3; 
  
  println("Linear pushed!!");
  
}

public void circular_DNA(){
   noFill();
   smooth();

  r1 = Length;
  r2 = r1 + Width;

   del = rAngle/(float)Helix;//a degree for one helix
   println("pitch=", del);
   println("gap=", gap);
   
   Helix+=1;
   r1p = new float[Helix][coord];
   r2p = new float[Helix][coord];
   r1m = new float[Helix][coord];
   r2m = new float[Helix][coord];
   r1n = new float[Helix][coord];
   r2n = new float[Helix][coord];
   Helix-=1;
  
 //first set 
 for(i=0;i<Helix+1;i++){
   for(j=0;j<coord;j++){
     r1p[i][j] = 0;
     r2p[i][j] = 0;
     //println(r1p[i][0],r1p[i][1],r2p[i][0],r2p[i][1]);     
   }
 }
 

 gap = 0;
 Calc_DNA();
 Draw_DNA(); 

 gap = del*Gap;
 Calc_DNA();
 Draw_DNA(); 

}


public void linear_DNA(){
   noFill();
   smooth();
   strokeWeight(Weight);
   stroke(COLOR);   

   float del_l = 2*Length/(float)Helix;
   gap = -del_l*Gap;
   
   Helix+=1;
   r1p = new float[Helix][coord];
   r2p = new float[Helix][coord];
   r1m = new float[Helix][coord];
   r2m = new float[Helix][coord];
   r1n = new float[Helix][coord];
   r2n = new float[Helix][coord];
   Helix-=1;
  
 //first set 
 for(i=0;i<Helix+1;i++){
   j=0;
     r1p[i][j] = i*del_l;
     r2p[i][j] = i*del_l+del_l/2;
     r1m[i][j] = i*del_l+del_l/4;
     r2m[i][j] = i*del_l+del_l/4;
     r1n[i][j] = i*del_l-del_l/4;
     r2n[i][j] = i*del_l-del_l/4;     
  }
 for(i=0;i<Helix+1;i++){
   j=1;
     r1p[i][j] = 0;
     r2p[i][j] = Width;
     r1m[i][j] = 0;
     r2m[i][j] = Width;
     r1n[i][j] = 0;
     r2n[i][j] = Width;
 }
 
 float init_x = 100;
 pushMatrix();
 translate(init_x, height/2);
 beginShape();
 a = 1;
 b = 1;

   for(i=0;i<Helix+1;i++){

     bezier(a*r1p[i][0],b*r1p[i][1],a*r1m[i][0],b*r1m[i][1],a*r2m[i][0],b*r2m[i][1],a*r2p[i][0],b*r2p[i][1]);
     if(i != Helix){

       bezier(a*r2p[i][0],b*r2p[i][1],a*r2n[i+1][0],b*r2n[i+1][1],a*r1n[i+1][0],b*r1n[i+1][1],a*r1p[i+1][0],b*r1p[i+1][1]);         
     }
   }   

 translate(gap, 0);

   for(i=0;i<Helix+1;i++){

     bezier(a*r1p[i][0],b*r1p[i][1],a*r1m[i][0],b*r1m[i][1],a*r2m[i][0],b*r2m[i][1],a*r2p[i][0],b*r2p[i][1]);
     if(i != Helix){

       bezier(a*r2p[i][0],b*r2p[i][1],a*r2n[i+1][0],b*r2n[i+1][1],a*r1n[i+1][0],b*r1n[i+1][1],a*r1p[i+1][0],b*r1p[i+1][1]);         
     }
   }  
   
 endShape();
 popMatrix(); 
}


public void Calc_DNA(){
 //calc
 for(i=0;i<Helix+1;i++){
   j=0;
     //initiation point (innner circle)
     r1p[i][j] = r1*cos((i*del+gap)*PI/180);
     //end point (outer circle)
     r2p[i][j] = r2*cos((i*del+del/2+gap)*PI/180);
     //control point 1 (inner)
     r1m[i][j] = r1*cos((i*del+del/4+gap)*PI/180);
     //control point 2 (outer)
     r2m[i][j] = r2*cos((i*del+del/4+gap)*PI/180);
     r1n[i][j] = r1*cos((i*del-del/4+gap)*PI/180);
     r2n[i][j] = r2*cos((i*del-del/4+gap)*PI/180);     
     //println(r1p[i][0],r1p[i][1],r2p[i][0],r2p[i][1]);  
  }
  //println("max_del", Helix*del);
  
  //y^2=r^2-x^2
 int fugo = 1;
 for(i=0;i<Helix+1;i++){
   j=1;
   if(i*del+gap > 180 && i*del+gap < 360 ) fugo = -1;
   else fugo =1;
     r1p[i][j] = fugo*myCircle(r1,r1p[i][0]);
   if(i*del+del/2+gap > 180 && i*del+del/2+gap < 360 ) fugo = -1;
   else fugo =1;
     r2p[i][j] = fugo*myCircle(r2,r2p[i][0]);
   if(i*del+del/4+gap > 180 && i*del+del/4+gap < 360 ) fugo = -1;   
   else fugo =1;
     r1m[i][j] = fugo*myCircle(r1,r1m[i][0]);
     r2m[i][j] = fugo*myCircle(r2,r2m[i][0]);
   if(i*del-del/4+gap > 180 && i*del-del/4+gap < 360 ) fugo = -1;
   else fugo =1;
     r1n[i][j] = fugo*myCircle(r1,r1n[i][0]);
     r2n[i][j] = fugo*myCircle(r2,r2n[i][0]);
     println(i, i*del+gap, i*del+gap+del/4, i*del+gap-del/4); 
 }
     println(r1n[0][0],r1n[0][1],r2n[0][0],r2n[0][1]);  

}

public void Draw_DNA(){
 //draw
 pushMatrix();
 translate(width/2, height/2);
 strokeWeight(Weight); 
 stroke(COLOR);
 beginShape();
 a = 1;
 b = 1;
   for(i=0;i<Helix+1;i++){
     //println(r1p[i][0],r1p[i][1],r2p[i][0],r2p[i][1]);
     bezier(a*r1p[i][0],b*r1p[i][1],a*r1m[i][0],b*r1m[i][1],a*r2m[i][0],b*r2m[i][1],a*r2p[i][0],b*r2p[i][1]);
     if(i != Helix){
       //println(r2p[i][0],r2p[i][1],r1p[i+1][0],r1p[i+1][1]);
       bezier(a*r2p[i][0],b*r2p[i][1],a*r2n[i+1][0],b*r2n[i+1][1],a*r1n[i+1][0],b*r1n[i+1][1],a*r1p[i+1][0],b*r1p[i+1][1]);         
     }
   }   

 endShape();
 popMatrix();  
}

