// import UDP library
import hypermedia.net.*;
UDP udp;  // define the UDP object
UDP udp2;


int COUNT = 60;

int DELTA = 1;
int SCALE = 2;
int MIN_THRESHOLD = 10000;

int angle_count = 0;

int norm_scale = 1;

float THRESHOLD_FACTOR = 0.9;
float FACTOR2 = 0;

int press_A_flag = 0;
//int under_threshold_flag = 0;
int reset_flag = 0;
int reset_done_flag = 0;
int display_flag = 0;

float angle = 0;

float angle_1 = 0;
float rad_1 = 0;
float angle_l = 0;

//float m_motor = 0;
//line(sensor      ,cos(rad) ,sin(rad));

//float A = 0.098;
//float B = 0.002;

int cnt_period = 0;

int NUM = 6;
int gap=300;
int[] lsensors0 = new int[NUM];

int[] sensors0 = new int[NUM];
//int[] sensors1 = new int[NUM];
//int[] sensors2 = new int[NUM];

int[] sensMid = new int[NUM];
int[] psensMid = new int[NUM];

float lnorm = 0;
float llnorm = 0;

float norm;
float norm_max = 0;
float norm_min = MIN_THRESHOLD;

float median_x = 0;
float median_xp = 0;
//int cnt_mx = 0;

float median_y = 0;
float median_yp = 0;
//int cnt_my = 0;

float median_z = 0;
float median_zp = 0;
//int cnt_mz = 0;

int cnt_m = 0;

float angle_cur = 0;
float threshold = 0;



// Radar Display.
float rad=0,lrad=0;
int wid = 50;
//int cx=wid+100,cy=wid+25;
int cx = 900, cy = 500;
float median,lv;
int cnt=0;
color[] col = new color[35];
int llx=0 ,lly=0;
/*
// Vector Display z
float rad2=0,lrad2=0;
int wid2 = 150;
int cx2=wid2+1300,cy2=wid2+25;
int cnt2=0;
color[] col2 = new color[28];
float llx2=0 ,lly2=0;

// Vector Display x
float rad3=0,lrad3=0;
int wid3 = 150;
int cx3=wid2+500,cy3=wid2+25;
int cnt3=0;
color[] col3 = new color[28];
float llx3=0 ,lly3=0;

// Vector Display y
float rad4=0,lrad4=0;
int wid4 = 150;
int cx4=wid2+900,cy4=wid4+25;
int cnt4=0;
color[] col4 = new color[28];
float llx4=0 ,lly4=0;
*/

//Position Display
int dia = 10;
int distance = 0;
int ldistance = 0;
float angle_sm = 0;
float rad_sm = 0;
int x_sm = 0;
int y_sm = 0;
int z_sm = 0;
int lx_sm = 0;
int ly_sm = 0;
int lz_sm = 0;



// When key is pressed
void keyPressed() {
    if (key == 'a') {
        press_A_flag = 1;
    }
    
    if (key == 'b') {
        threshold = THRESHOLD_FACTOR * norm_max;
        press_A_flag = 0;
    }
    
    if (key == 'c') {
        threshold = 0;
        norm_max = 0;
        norm_min = MIN_THRESHOLD;
        press_A_flag = 0;
    }
    
    if (key == 'd') {
        display_flag = 1;
    }
    if (key == 'e') {
        display_flag = 0;
        erase_display();
    }
    
    if (key == 'f') {
        norm_scale = 1;
    }
    if (key == 'g') {
        norm_scale = 30;
    }
    if (key == 'h') {
        norm_scale = 300;
    }
    
}



synchronized void drawRadar(){
//  if(lrad != rad){
    stroke(color(127,127,127));
    noFill();
    strokeWeight(1);
    ellipse(cx,cy,wid*2,wid*2);
    strokeWeight(5);
    stroke(color(10,10,10));
    line(cx,cy,llx,lly);
    llx = int(wid*sin(rad))+cx;
    lly = int(wid*cos(rad))+cy;
    strokeWeight(1);
    stroke(color(200,200,200));
    line(cx,cy,llx,lly);
    strokeWeight(3);
}



synchronized void drawAngle(){
  //if(norm-lnorm < 0 && lnorm - llnorm > 0){

  //if( press_A_flag == 1 ){
    colorMode(RGB,256);
    fill(0);
    rect(1000,100,500,100);
    textSize(100);
    fill(255);
    text("angle:", 1000, 200);
    //text(-sensors0[4], 1300, 200);
    text(int(angle_sm), 1300, 200);
    //text(reset_flag,1300,200);
    
    //angle_sm = -sensors0[4];
    //drawPosition();
  //}
  
  //llnorm = lnorm;
  //lnorm = norm;
}

synchronized void drawPeriodCount(){
    textSize(100);
    fill(0);
    rect(800,900,500,100);
    fill(255);
    text("period:", 800, 1000);
    text(cnt_period, 1150, 1000);
    //cnt_period++;
}



synchronized void angleCount(){
    textSize(100);
    fill(0);
    rect(1300,900,600,100);
    fill(255);
    text("count:", 1300, 1000);
    text(angle_count, 1600, 1000);
}



synchronized void drawExtremeValues(){
    textSize(100);
    fill(0);
    rect(1100,600,700,100);
    fill(255);
    text("max:", 1100, 700);
    text(norm_max, 1300, 700);
    fill(0);
    rect(1100,700,700,100);
    fill(255);
    text("min:", 1100, 800);
    text(norm_min, 1300, 800);
}



synchronized void drawExtremeRatio(){
    textSize(100);
    fill(0);
    rect(1100,800,700,100);
    fill(255);
    text("ratio:", 1100, 900);
    text(norm_max/norm_min, 1400, 900);
}



void erase_display(){
  fill(0);
  stroke(0,0,0);
  rect(1100,600,700,100);
  rect(1100,700,700,100);
  rect(1100,800,700,100);
  rect(800,900,500,100);
}



synchronized void drawPosition(){
   //if( flag == 1 ){
     //distance = -1 * int(norm_max);
     distance = int(map( -1*norm_max,-3000,0,0,500));
     rad_sm =  3.141592653*2*angle_sm/360.0;
     x_sm = int(distance*sin(rad_sm));
     y_sm = int(distance*cos(rad_sm));
     //x_sm = int(500*sin(rad_sm));
     //y_sm = int(500*cos(rad_sm));
     
     fill(0);
     stroke(0,0,0);
     ellipse(cx+lx_sm,cy+ly_sm,dia*2,dia*2);
     fill(255);
     stroke(255,255,255);
     ellipse(cx+x_sm,cy+y_sm,dia*2,dia*2);
     ldistance = distance;
     lx_sm = x_sm;
     ly_sm = y_sm;
   //}
}



synchronized void drawNorm(){
   //if( flag == 1 ){
     //distance = -1 * int(norm_max);
     distance = int(map(norm_scale*norm,0,5000,0,500));
     rad_sm =  3.141592653*2*angle/360.0;
     //x_sm = int(distance*sin(rad_sm));
     //y_sm = int(distance*cos(rad_sm));
     x_sm = int(sensors0[0]-sensMid[0]);
     y_sm = int(sensors0[1]-sensMid[1]);
     z_sm = int(sensors0[2]-sensMid[2]);
     //x_sm = int(sensors0[0]);
     //y_sm = int(sensors0[1]);
     //x_sm = int(500*sin(rad_sm));
     //y_sm = int(500*cos(rad_sm));
     
     fill(0);
     stroke(125,125,125);
     ellipse(cx+lx_sm,cy+ly_sm,dia*2,dia*2);
     
     fill(0);
     stroke(125,125,0);
     ellipse(cx+lx_sm,cy+lz_sm,dia*2,dia*2);
     
     fill(255);
     stroke(255,255,255);
     ellipse(cx+x_sm,cy+y_sm,dia*2,dia*2);
     
     fill(255,255,0);
     stroke(255,255,0);
     ellipse(cx+x_sm,cy+z_sm,dia*2,dia*2);
     
     ldistance = distance;
     lx_sm = x_sm;
     ly_sm = y_sm;
     lz_sm = z_sm;
   //}
}



void drawMode(){
  if( press_A_flag == 0 ){
    //textSize(100); //<>//
    fill(0);
    rect(0,0,700,100);
    fill(255);
    text("vector mode", 0, 100);
  }
  
  if( press_A_flag == 1 ){
    //textSize(100);
    fill(0);
    rect(0,0,700,100);
    fill(255);
    text("position mode", 0, 100);
  }
}



void setup() {
  size(1800, 1000);
  frameRate(60);
  background(0);
   udp = new UDP( this, 22222 );
  //udp.log( true );     // <-- printout the connection activity
  udp.listen( true );
  udp2 = new UDP( this, 22221 );
  //udp.log( true );     // <-- printout the connection activity
  udp2.listen( true );
   gap = height;///4;

  initGraph();
}



synchronized void draw() {
  drawRadar();
  
  //drawVector_x();
  
  //drawVector_y();
  
  //drawVector_z();
  
  //drawAngle();
  
  //drawPosition();
  
  if( press_A_flag == 0 ){
      drawNorm();
    }
    drawMode();
    
    
  
  for (int i = 0; i < NUM; i++) {

    float tx = map(cnt, 0, width, 0, width*DELTA);
    float txl = map(cnt-1, 0, width, 0, width*DELTA);
    float ty0 = map(SCALE*(sensors0[i]-sensMid[i]), -1200, 1200, 0,gap);
    float tyl = map(SCALE*(lsensors0[i]-sensMid[i]), -1200, 1200, 0,gap);

    stroke(col[i+20]);
    strokeWeight(3);
    //from last (x,y) point, to new (x,y) point, draw a line
    line(txl,tyl,tx,ty0);

    lsensors0[i] = sensors0[i];
  }
  
  if (cnt > width/DELTA) {
    initGraph();
  }
  
  cnt++;
  
  
  
  //if(press_A_flag == 1){
      if(norm_max < norm){
        norm_max = norm;
        //angle_sm = angle;
        angle_sm = -sensors0[4];
      }
      if(norm_min > norm){
        norm_min = norm;
      }
      
      if( display_flag == 1 && angle_count == COUNT*2 ){
        drawExtremeValues();
        drawExtremeRatio();
      }
      
      //drawAngle();
      //drawPosition();
      
  //}
  
  
  
    if( press_A_flag == 1 && angle_count == COUNT ){
      drawAngle();
      drawPosition();
      
      //reset_flag = 1;
      //angle_count = 0;
    }
    
    if( press_A_flag == 1 && angle_count == COUNT*2 ){
      drawAngle();
      drawPosition();
      
      reset_flag = 1;
      angle_count = 0;
    }
        
    
    
    if( press_A_flag == 0 && angle_count == COUNT*2 ){      
      reset_flag = 1;
      angle_count = 0;
    }
    
    
    
    //average
    if(reset_flag == 1){
      
      //drawAngle();
      //drawPosition();
      
      norm_max = 0;
      norm_min = MIN_THRESHOLD;
      angle_sm = 0;
      
      sensMid[0] = psensMid[0];
      sensMid[1] = psensMid[1];
      sensMid[2] = psensMid[2];
      
      psensMid[0] = 0;
      psensMid[1] = 0;
      psensMid[2] = 0;
      
      cnt_m = 0;
      median_xp = 0;
      median_yp = 0;
      median_zp = 0;
      
      reset_flag = 0;
      //reset_done_flag = 0;
      
      cnt_period ++;
      
      if( display_flag == 1){
        drawPeriodCount();
      }
      
      
      
    }
    
    //if( press_A_flag == 1 ){
      angle_count ++;
    //}
    //if( press_A_flag == 1 ){
      angleCount();
    //}
    
    
    
}



void receive( byte[] data, String ip, int port ) {  // <-- extended handler

  // get the "real" message =
  // forget the ";\n" at the end <-- !!! only for a communication with Pd !!!
  //data = subset(data, 0, data.length-2);
  String message = new String( data );
   // print the result
  //println( "receive: \""+message+"\" from "+ip+" on port "+port );
  if(message.indexOf("MAG") == -1 && message.indexOf("ACC") == -1){
    String aa[]= split(message,',');
    angle = float(aa[1]);
 //   lrad = rad;
    rad=  3.141592653*2*angle/360.0;
    sensors0[4] = int(-1*angle);
    
    
    
    //if(flag == 2){
      //angle_cur = angle;
      //textSize(50);
      //fill(0);
      //text(norm_max, 1000, 500);
      //fill(1);
      //text(angle, 1000, 500);
      //angle_l = angle;
      //rad_1 = 3.141592653*2*angle_1/360.0;
    //}
    
  }else{
  // time\tMAG\ttime,0.0,0.0,0.0
  String bb[] = split(message,'\t');
  // stores sensor value
  String aa[]= split(bb[2],',');
  float xval = float(aa[1]);
  float yval = float(aa[2]);
  float zval = float(aa[3]);
  //norm = sqrt((xval-sensMid[0])*(xval-sensMid[0]) + (yval-sensMid[1])*(yval-sensMid[1]) + (zval-sensMid[2])*(zval-sensMid[2]));
  //norm = sqrt((xval-sensMid[0])*(xval-sensMid[0]));
 
  // filter MAG value. if real value is too small, fix magnifying rate
  if(bb[1].equals("MAG")){
    //println( "receive: \""+message+"\" from "+ip+" on port "+port );
    //println("xyz: " + xval + "," + yval +"," + zval);
    
    // xval showed in red.
    cnt_m ++;
    
    sensors0[0] = int(-SCALE*xval);
    median_xp = (median_xp + sensors0[0]);
    median_x = median_xp/cnt_m;
    psensMid[0] = int(median_x);
    
    // yval showed in green.
    sensors0[1] = int(-SCALE*yval);
    //cnt_my ++;
    median_yp = (median_yp + sensors0[1]);
    median_y = median_yp/cnt_m;
    psensMid[1] = int(median_y);
    
    // zval showed in blue.
    sensors0[2] = int(-SCALE*zval);
    //cnt_mz ++;
    median_zp = (median_zp + sensors0[2]);
    median_z = median_zp/cnt_m;
    psensMid[2] = int(median_z);
    
    sensors0[3] = 0;//zero axis

    norm = sqrt((sensors0[0]-sensMid[0])*(sensors0[0]-sensMid[0]) + (sensors0[1]-sensMid[1])*(sensors0[1]-sensMid[1]) + (sensors0[2]-sensMid[2])*(sensors0[2]-sensMid[2]));
    //norm = 0.1 * sqrt((sensors0[0])*(sensors0[0]) + (sensors0[1])*(sensors0[1]) + (sensors0[2])*(sensors0[2]));
    sensors0[5] = int (-1*norm);
      
       
    
    //process to get extreme values (uncompleted)
    /*
    if(flag == 1){
      if(norm-lnorm < 0 && lnorm - llnorm > 0){
        under_threshold_flag = 1;
        //lnorm = norm;
      }else{
        flag2 = 0;
        //lnorm = norm;
      }
    }
    //llnorm = lnorm;
    //lnorm = norm;
    */
    
    
  }
  
  /*if(bb[1].equals("ACC")){
    //println( "receive: \""+message+"\" from "+ip+" on port "+port );
    //println("xyz: " + xval + "," + yval +"," + zval);
    // xval showed in orange.
    sensors0[0] = int(-10*xval);
    // yval showed in green.
    sensors0[1] = int(-10*yval);
    // zval showed in purple.
    sensors0[2] = int(-10*zval);
    sensors0[3] = 0;
    sensors0[5] = int(-1*norm);
    median = median*A+sensors0[0]*B;
    //sensors0[6]= int(-1*median);
    sensors0[3] = int(median);
  }*/
  
  }
}



void initGraph() {
  //background(47);
  background(0);
  noStroke();
  cnt = 0;
  col[0] = color(255/3, 127/2, 31/2);
  col[1] = color(31/3, 255/3, 127/3);
  col[2] = color(127/3, 31/3, 255/3);
  col[3] = color(31/3, 127/3, 255/3);
  col[4] = color(127/3, 255/3, 31/3);
  col[5] = color(127/3);
  col[6] = color(127/3,127/3,255/3);
  col[7] = color(255/3,127/3,127/3);
  col[10] = color(255/2, 127/2, 31/2);
  col[11] = color(31/2, 255/2, 127/2);
  col[12] = color(127/2, 31/2, 255/2);
  col[13] = color(31/2, 127/2, 255/2);
  col[14] = color(127/2, 255/2, 31/2);
  col[15] = color(127/2);
  col[16] = color(127/2,127/2,255/2);
  col[17] = color(255/2,127/2,127/2);
  //col[20] = color(255, 127, 31);
  //col[21] = color(31, 255, 127);
  //col[22] = color(127, 31, 255);
  col[20] = color(255,0,0);
  col[21] = color(0,255,0);
  col[22] = color(0,150,255);
  //col[23] = color(31, 127, 255);
  col[23] = color(205,97,155);
  col[24] = color(230, 180, 34);
  col[25] = color(255);
  col[26] = color(127,127,255);
  col[27] = color(255,127,127);
  col[28] = color(205,97,155);
  col[29] = color(127, 255, 31);
  col[30] = color(127);
  col[31] = color(127,127,255);
  col[32] = color(255,127,127);
}



/*
synchronized void drawVector_z(){
    stroke(color(127,127,127));
    noFill();
    strokeWeight(10);
    ellipse(cx2,cy2,wid2*2,wid2*2);
    
    strokeWeight(5);
    stroke(color(0,0,0));
    //line(cx2,cy2, - (sensors0[0] - cx2)+(cos(rad)+cx2), - (sensors0[1] - cy2)+(sin(rad)+cy2));
    line(cx2,cy2,llx2, lly2);
    
    strokeWeight(5);
    stroke(color(0,150,255));//light blue
    line(cx2,cy2, - (sensors0[0] - cx2)*(1000*cos(rad - 3.141592653*2*180/360.0)+cx2)+(sensors0[1] - cy2) * (1000*sin(rad - 3.141592653*2*180/360.0)+cy2) , - (sensors0[0] - cx2)+(1000*sin(rad - 3.141592653*2*90/360.0)+cx2) + (sensors0[1] - cy2) * (1000*cos(rad - 3.141592653*2*180/360.0)+cy2));
    //line(cx2,cy2,1000*cos(rad - 3.141592653*2*90/360.0)+cx2, - (1000*sin(rad - 3.141592653*2*90/360.0)+cy2));
    
    //llx2 = - (sensors0[0] - cx2);
    //lly2 = - (sensors0[1] - cy2);
    //llx2 = 1000*cos(rad - 3.141592653*2*90/360.0)+cx2;
    //lly2 = - (1000*sin(rad - 3.141592653*2*90/360.0)+cy2);
}

synchronized void drawVector_x(){
    stroke(color(127,127,127));
    noFill();
    strokeWeight(10);
    ellipse(cx3,cy3,wid3*2,wid3*2);
    
    strokeWeight(5);
    stroke(color(0,0,0));
    line(cx3,cy3,llx3,lly3);
    
    strokeWeight(5);
    stroke(color(255,0,0));//red
    line(cx3,cy3, - (sensors0[1] - cx3), - (sensors0[2] - cy3));
    
    llx3 = - (sensors0[1] - cx3);
    lly3 = - (sensors0[2] - cy3);
}

synchronized void drawVector_y(){
    stroke(color(127,127,127));
    noFill();
    strokeWeight(10);
    ellipse(cx4,cy4,wid4*2,wid4*2);
    
    strokeWeight(5);
    stroke(color(0,0,0));
    line(cx4,cy4,llx4,lly4);
    
    strokeWeight(5);
    stroke(color(0,255,0));//green
    line(cx4,cy4, - (sensors0[0] - cx4), - (sensors0[2] - cy4));
    
    llx4 = - (sensors0[0] - cx4);
    lly4 = - (sensors0[2] - cy4);
}
*/