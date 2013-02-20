import ddf.minim.*;
import ddf.minim.analysis.*;
import processing.pdf.*;

Minim minim;
AudioPlayer song;

int volLen = 10000; 
float[] volumes;
float[] smoothedVolumes;
int myCount = 0;

boolean savePDF = false;

PFont myFont;

//==============================================
void setup()
{
  size(1440, 550);

  minim = new Minim(this);
  //song = minim.loadFile("theoden.mp3");
  song = minim.loadFile("henryV.mp3");
  song.play();

  volumes = new float[volLen];
  smoothedVolumes = new float[volLen];

  myFont = createFont("Avenir Next.ttc", 12);
  textFont(myFont);
}

//==============================================
void draw()
{
  if ( savePDF ) {
    beginRecord( PDF, "pdf/blade-####.pdf" );
    textFont(myFont);
  }
  volumes[myCount] = (song.mix.level()*1000); 
  myCount++;

  background( 0 );
  //fill (250,20,20,255); 
  stroke (255); 

  for (int i=0; i<myCount; i++) {
    smoothedVolumes[i] = volumes[i];
  }

  int nPasses = mouseX/5;
  for (int n=0; n<nPasses; n++) {
    for (int i=1; i<myCount-1; i++) {
      smoothedVolumes[i] = (smoothedVolumes[i-1] + smoothedVolumes[i] + smoothedVolumes[i+1])/3;
    }
  }
  pushMatrix();
  translate(0, height/2);
  for (int i=0; i<myCount-1; i++) {
    int scaler = 2 ;
//    line(i+20, smoothedVolumes[i], (i+21), smoothedVolumes[i+1]);
//    line(i+20, - smoothedVolumes[i], (i+21), -smoothedVolumes[i+1]);
//    line(i+20, smoothedVolumes[i]*scaler, (i+21), smoothedVolumes[i+1]*scaler);
//    line(i+20, - smoothedVolumes[i]*scaler, (i+21), -smoothedVolumes[i+1]*scaler);
    int j = int(abs(dist(i+20, height/2, (i+21), smoothedVolumes[i+1]*scaler)));
    stroke((abs(255-j))+25);
    line(i+20, smoothedVolumes[i], i+20, smoothedVolumes[i]*scaler);
    line(i+20, - smoothedVolumes[i], i+20, - smoothedVolumes[i]*scaler);
    stroke(200,200,200);
    line(i+20, - smoothedVolumes[i], i+20, smoothedVolumes[i]);
  }
  popMatrix();  
  //  endRecord();

  drawType(width);

  if ( savePDF ) {
    endRecord();
    savePDF = false;
  }
}

//==============================================
void mousePressed() {
  song.close();
  minim.stop();
  super.stop();
  savePDF = true;
  // endRecord();
}

//==============================================
void stop()
{
  song.close();
  minim.stop();
  super.stop();
  //  endRecord();
}

//==============================================
void keyPressed()
{
  if ( key == 's' ) {
    savePDF = true;
  }
}

//==============================================
void drawType(float x) {
  fill(0);
  //text("WHERE IS THE HORSE & THE RIDER? WHERE IS THE HORN THAT WAS BLOWNING? THE DAYS HAVE GONE DOWN IN THE WEST. BEHIND THE HILLS, INTO SHADOW. HOW DID IT COME TO THIS?", 30, (height/2)+5);
  text("ONCE MORE UNTO THE BREACH, DEAR FRIENDS, ONCE MORE; OR CLOSE THE WALL UP WITH OUR ENGLISH DEAD. WHEN THE BLAST OF WAR BLOWS IN OUR EARS, THEN IMITATE THE ACTION OF THE TIGER.", 45, (height/2)+5);
}

