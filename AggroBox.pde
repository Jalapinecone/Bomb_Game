class AggroBox{
  int x, y ,wid ,hei ,rad;
  boolean isCircle;
  
  //square aggrobox init
  AggroBox(int x, int y, int wid, int hei){
    this.x = x;
    this.y = y;
    this.wid = wid;
    this.hei = hei;
    this.isCircle = false;
  }
  
  
  //circle aggrobox init
  AggroBox(int x, int y, int rad){
    this.x = x;
    this.y = y;
    this.rad = rad;
    this.isCircle = true;
  }
  
  void draw(int enX, int enY){
    fill(100,4);
    //draw circle
    if(isCircle == true){
      stroke(255,0,0);
      ellipse(enX, enY, rad, rad);
    }
    //draw square
    if(isCircle == false){
      stroke(255,0,0);
      rect(enX, enY, wid, hei);
    }
  }
  
}