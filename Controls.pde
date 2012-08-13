void keyPressed() {
  if (key==' ') {
    record = !record;
    doRecord(record);
  }
  if(key=='d'||key=='D'){
    rawDepth = !rawDepth;
  }
}

