// import UDP library
import hypermedia.net.*;
import processing.opengl.*;

UDP udp;  // define the UDP object
UDP udp2;

float PI = 3.14159;

//float camX = 0, camY = 0;
//float speed = 12;
float cam_azi = PI/4, cam_ele = 3*PI/4, cam_dis = 1500;
float speed = 0.1;
int dis_speed = 50;

int cnt_f = 0;
int cnt_mag = 0;
int cnt_mag_max = 120;
int mag_scale = 10;
float[]mag_x = new float[cnt_mag_max];
float[]mag_y = new float[cnt_mag_max];
float[]mag_z = new float[cnt_mag_max];
float mid_mag_x = 0;
float mid_mag_y = 0;
float mid_mag_z = 0;



int COUNT = 60;

int DELTA = 1;
int SCALE = 2;
int MIN_THRESHOLD = 10000;

int angle_count = 0;

int norm_scale = 1;

float THRESHOLD_FACTOR = 0.9;
float FACTOR2 = 0;

int press_A_flag = 0;
int reset_flag = 0;
int reset_done_flag = 0;
int display_flag = 0;

float angle = 0;

float angle_1 = 0;
float rad_1 = 0;
float angle_l = 0;

int cnt_period = 0;

int NUM = 6;
int gap=300;
int[] lsensors0 = new int[NUM];

int[] sensors0 = new int[NUM];

int[] sensMid = new int[NUM];
int[] psensMid = new int[NUM];

float lnorm = 0;
float llnorm = 0;

float norm;
float norm_max = 0;
float norm_min = MIN_THRESHOLD;

float median_x = 0;
float median_xp = 0;

float median_y = 0;
float median_yp = 0;

float median_z = 0;
float median_zp = 0;

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



//Position Display
int dia = 10;
int distance = 0;
int ldistance = 0;
float angle_sm = 0;
float rad_sm = 0;
int x_sm = 0;
int y_sm = 0;
int lx_sm = 0;
int ly_sm = 0;



//offset
int offset_x = 0;
int offset_y = 0;
int offset_z = 0;



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
    
    if (key == 'r') {
      offset_x = sensors0[0];
      offset_y = sensors0[1];
      offset_z = sensors0[2];
    }
    if (key == 'q') {
      background(0);
    }
    
    //if ( (keyPressed == true) && key == 'z') {
      //strokeWeight(0);
      //fill(255,0,0);
      //box(50);
    //}
    
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



synchronized void draw_angle_count(){
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



synchronized void write_extreme_ratio(){
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
     distance = int(map(norm_scale*norm,0,5000,0,500));
     rad_sm =  3.141592653*2*angle/360.0;
     x_sm = int(distance*sin(rad_sm));
     y_sm = int(distance*cos(rad_sm));
     
     fill(0);
     stroke(128,128,128);
     ellipse(cx+lx_sm,cy+ly_sm,dia*2,dia*2);
     fill(255);
     stroke(255,255,255);
     ellipse(cx+x_sm,cy+y_sm,dia*2,dia*2);
     ldistance = distance;
     lx_sm = x_sm;
     ly_sm = y_sm;
}



void draw_mag_vector() {
  background(0);
  lights();
    
  //ambientLight(63, 31, 31);
  //directionalLight(255,255,255,-1,0,0);
  //pointLight(63, 127, 255, mouseX, mouseY, 200);
  //spotLight(100, 100, 100, mouseX, mouseY, 200, 0, 0, -1, PI, 2);
  
  //a position of a camera
  translate(width/2, height/2, 0);
  
  if (keyPressed) {
    if (keyCode == LEFT) cam_azi -= speed;
    if (keyCode == RIGHT) cam_azi += speed;
    if (keyCode == UP) cam_ele -= speed;
    if (keyCode == DOWN) cam_ele += speed;
    if (key == 'z') cam_dis -= dis_speed;
    if (key == 'x') cam_dis += dis_speed;
  }
  
  //camera(camX + mouseX, camY + mouseY, 1500, camX, camY, 0, 0, 1, 0);
  //camera(camX + 720, camY + 360, 1500, camX, camY, 0, 0, 1, 0);
  camera(cam_dis*sin(cam_azi), cam_dis*cos(cam_ele), cam_dis*cos(cam_azi), 0, 0, 0, 0, 1, 0);
  
  //draw axes
  strokeWeight(5);
  stroke(255, 0, 0);//red:x axis
  line(0, 0, 0, 0, 0, 500);
  stroke(0, 255, 0);//green:y axis
  line(0, 0, 0, 500, 0, 0);
  stroke(0, 0, 255);//blue:z axis
  line(0, 0, 0, 0, -500, 0);
  
  mag_x[cnt_mag] = mag_scale * sensors0[1];
  mag_y[cnt_mag] = mag_scale * sensors0[2];
  mag_z[cnt_mag] = mag_scale * sensors0[3];
      
  strokeWeight(0);
  stroke(255);//color of line of box:white
  fill(255);//color of box:white
    
    for(cnt_f=0; cnt_f<cnt_mag; cnt_f++){
      translate( mag_y[cnt_f] - mid_mag_y, -(mag_z[cnt_f] - mid_mag_z), mag_x[cnt_f] - mid_mag_x);
      //translate( mag_x[cnt_f] - mid_mag_x, -(mag_z[cnt_f] - mid_mag_z), mag_y[cnt_f] - mid_mag_y);
      box(30);
      translate( -(mag_y[cnt_f] - mid_mag_y), mag_z[cnt_f] - mid_mag_z, -(mag_x[cnt_f] - mid_mag_x));
      //translate( -(mag_x[cnt_f] - mid_mag_x), mag_z[cnt_f] - mid_mag_z, -(mag_y[cnt_f] - mid_mag_y));
    }
    
    cnt_mag ++;
    
    if(cnt_mag == cnt_mag_max ){
      cnt_mag = 0;
      for(cnt_f=0; cnt_f<cnt_mag_max; cnt_f++){
        mid_mag_x = mid_mag_x + mag_x[cnt_f];
        mid_mag_y = mid_mag_y + mag_y[cnt_f];
        mid_mag_z = mid_mag_z + mag_z[cnt_f];
      }
      mid_mag_x = mid_mag_x/cnt_mag_max;
      mid_mag_y = mid_mag_y/cnt_mag_max;
      mid_mag_z = mid_mag_z/cnt_mag_max;
    }
    
}



void drawMode(){
  if( press_A_flag == 0 ){
    //textSize(100);
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
  size(1800, 1000, OPENGL);
  noStroke();
  fill(255,190);
  frameRate(60);
  background(0);
   udp = new UDP( this, 22222 );
  //udp.log( true );     // <-- printout the connection activity
  udp.listen( true );
  udp2 = new UDP( this, 22221 );
  //udp.log( true );     // <-- printout the connection activity
  udp2.listen( true );
   gap = height;///4;

  //initGraph();
}



synchronized void draw() {
  
  draw_mag_vector();
  
  //write_extreme_ratio();
  
  //drawMode();
  
  //for (int i = 0; i < NUM; i++) {

    //float tx = map(cnt, 0, width, 0, width*DELTA);
    //float txl = map(cnt-1, 0, width, 0, width*DELTA);
    //float ty0 = map(SCALE*(sensors0[i]-sensMid[i]), -1200, 1200, 0,gap);
    //float tyl = map(SCALE*(lsensors0[i]-sensMid[i]), -1200, 1200, 0,gap);

    //stroke(col[i+20]);
    //strokeWeight(3);
    //from last (x,y) point, to new (x,y) point, draw a line
    //line(txl,tyl,tx,ty0);
    
    //lsensors0[i] = sensors0[i];
  //}
  
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
        //drawExtremeValues();
        //drawExtremeRatio();
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
      
      cnt_period ++;
      
      if( display_flag == 1){
        //drawPeriodCount();
      }
      
    }
    
      angle_count ++;
      //draw_angle_count();
}



void receive( byte[] data, String ip, int port ) {  // <-- extended handler

  String message = new String( data );
  if(message.indexOf("MAG") == -1 && message.indexOf("ACC") == -1){
    String aa[]= split(message,',');
    angle = float(aa[1]);
    rad=  3.141592653*2*angle/360.0;
    sensors0[4] = int(-1*angle);
    
  }else{
  // time\tMAG\ttime,0.0,0.0,0.0
  String bb[] = split(message,'\t');
  // stores sensor value
  String aa[]= split(bb[2],',');
  float xval = float(aa[1]);
  float yval = float(aa[2]);
  float zval = float(aa[3]);
  
  // filter MAG value. if real value is too small, fix magnifying rate
  if(bb[1].equals("MAG")){
    //println( "receive: \""+message+"\" from "+ip+" on port "+port );
    //println("xyz: " + xval + "," + yval +"," + zval);
    
    cnt_m ++;
    
    // xval showed in red.
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
    sensors0[5] = int (-1*norm);
  }
  }
}



void initGraph() {
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
  col[20] = color(255,0,0);
  col[21] = color(0,255,0);
  col[22] = color(0,150,255);
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