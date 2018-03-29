class Item{
  String type;
  PImage sprite;
  int x,y;
  
  boolean detonated, shrinking;
  int radius, maxRadius, growrate, shrinkrate;
  
  Item(String type){
    this.type = type;
    sprite = new PImage();
    detonated = false;
    radius = 1;
    maxRadius = 200;
  }
  
  void plant(int px, int py){
    if(type == "bomb"){
      sprite = loadImage("res/bomb.png");
    }
    else{
      sprite = loadImage("res/decoy.jpg");
    }
    this.x = px;
    this.y = py;
  }
  
  void draw(){
    if(!detonated){
      image(sprite,x-16,y-16);
    }
    else{
      if(radius <= maxRadius && !shrinking){
        fill(255,0,0);
        ellipse(x,y,radius,radius);
        radius = radius + growrate;
      }
      else{
        shrinking = true;
        if(radius >= 0){
          fill(255,0,0);
          ellipse(x,y,radius,radius);
          radius = radius - shrinkrate;
        }
      }
    }
  }
  
  void detonate(){
    detonated = true;
    radius = 3;
    growrate = 3;
    shrinkrate = 1;
  }
}