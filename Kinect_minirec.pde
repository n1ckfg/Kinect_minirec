import SimpleOpenNI.*;

int sW = 640;
int sH = 480;
int fps = 24;
color bgColor = color(0);

int imgW = sW;
int imgH = sH;

boolean rawDepth = false;

int previewLevel = 5;

boolean mirror = true;
SimpleOpenNI context;
boolean depthSwitch = true;
boolean rgbSwitch = false;
boolean firstRun = true;
int bufferSizeInSec = 30;
int[] depthFrame = new int[sW*sH];
int[][] depthArray = new int[bufferSizeInSec*fps][sW*sH];


boolean record = false;

String shotName = "shot";
int shotCounter = 0;
int frameCounter = 0;

PImage viewImg, saveImg;

void setup() {
  size(sW, sH, P2D);
  frameRate(fps);
  initKinect();
  viewImg = createImage(imgW, imgH, RGB);
  saveImg = createImage(sW, sH, RGB);
}

void draw() {
  background(bgColor);
   context.update();
    if(rawDepth){
      depthFrame = context.depthMap();
    }else{
       depthFrame = context.depthImage().pixels;
    }
  if (record && frameCounter<bufferSizeInSec*fps) {
    //depthArray[frameCounter] = context.depthMap();
    
    for(int i=0;i<depthFrame.length;i++){
      depthArray[frameCounter][i] = depthFrame[i];
    }
    
    frameCounter++;
    println("fps: " + frameRate + "   frame: " + frameCounter + " / " + bufferSizeInSec * fps);
    if (frameCounter>=bufferSizeInSec*fps) {
      record=false;
      doRecord(record);
    }
  }
  for(int i=0;i<640*480;i+=previewLevel){
  viewImg.pixels[i] = depthFrame[i];
  }
  imageMode(CENTER);
  image(viewImg, sW/2, sH/2);
}

void initKinect() {
  context = new SimpleOpenNI(this, SimpleOpenNI.RUN_MODE_MULTI_THREADED);
  context.setMirror(mirror);
  if (depthSwitch) {
    context.enableDepth();
  }
  if (rgbSwitch) {
    context.enableRGB();
  }
}

void doRecord(boolean _r){
    if (_r) {
      shotCounter++;
      frameCounter=0;
    } 
    else if (!_r) {
      for(int j=0;j<depthArray.length;j++){
        for(int i=0;i<sW*sH;i++){
          saveImg.pixels[i] = depthArray[j][i];
        }
        imageMode(CENTER);
        image(saveImg,sW/2,sH/2);
        saveFrame("data/" + shotName + shotCounter + "_" + (j+1) + ".tga");
      }
    }
}
