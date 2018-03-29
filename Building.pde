class Building{
  String type;
  int x, y;
  PImage sprite;
  
  boolean detonated, shrinking, dead;
  int radius, maxRadius, growrate, shrinkrate;
  
  Building(int x, int y, String type){
    this.x = x;
    this.y = y;
    this.type = type;
    
    detonated = false;
    dead = false;
    radius = 1;
    maxRadius = 400;
    
    sprite = new PImage();
    
    if(type == "bombFactory"){
      sprite = loadImage("res/bomb_fac.jpg");
    }
    else if (type == "civilian"){
      sprite = loadImage("res/civilian_village.jpg");
    }
    else if (type == "launchpad"){
      sprite = loadImage("res/launch_pad");
    }
  }
  void draw(){
    if(!detonated){
      image(sprite,x,y);
    }
    else{
      if(radius <= maxRadius && !shrinking){
        fill(255,0,0);
        ellipse(x+32,y+32,radius,radius);
        radius = radius + growrate;
      }
      else{
        shrinking = true;
        if(radius >= 0){
          fill(255,0,0);
          ellipse(x+32,y+32,radius,radius);
          radius = radius - shrinkrate;
        }
        else{
          dead = true;
        }
      }
    }
  }
  
  void detonate(){
    detonated = true;
    radius = 3;
    growrate = 3;
    shrinkrate = 1;
    
    if(type == "civilian"){
      score -= 1000;
      player.murderer = true;
    }
    else{
      score += 1000;
    }
  }
}