class Bullet{
  float speed,x,y;
  int size = 6;
  byte dir;
  boolean hit;
  int moreSpeed = 5;
  PVector vel, loc, targ;
  int lifespan;
  AggroBox hitbox;
  
  Bullet(float x, float y, float finalX, float finalY){
    this.x = x;
    this.y = y;
    lifespan = 0;
    speed = 0.05;
    hit = false;
    
    loc = new PVector(x,y);
    targ = new PVector(finalX,finalY);
    vel = new PVector();
    vel = vel.sub(targ, loc);
    
    hitbox = new AggroBox(int(x),int(y),5);
    
    vel.normalize();
    vel.mult(4);
  }
  
  void draw(){
    fill(255);
    rect(x-0.5*size,y-0.5*size, size, size);
    lifespan ++;
    
    hitbox.draw(int(x),int(y));
  }
  
  void moveBullet(){
    loc.add(vel);
    
    x = loc.x;
    y = loc.y;
  }
}