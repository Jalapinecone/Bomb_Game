class Enemy{
  int  x,y,outerDia, innerDia;
  float speed;
  AggroBox outerRange, innerRange;
  PImage sprite;
  Waypoint[] waypoints;
  int bulletCooldown, waypointCount;
  ArrayList<Bullet> bullets;
  AggroBox hitbox;
  PVector location, target, velocity;
  
  float finalX;
  float finalY;
  
  String state;
  
  Enemy(int initX, int initY, Waypoint[] waypoints, int startingIndex){
    this.x = initX;
    this.y = initY;
    outerDia = 350;
    innerDia = 210;
    speed = 1;
    state = "killPlayer";
    bulletCooldown = 0;
    
    bullets = new ArrayList<Bullet>(5);
    
    this.waypoints =  waypoints;
    
    waypointCount = startingIndex + 1;
    
    finalX = waypoints[waypointCount].x;
    finalY = waypoints[waypointCount].y;
    
    
    
    location = new PVector(x,y);
    target = new PVector(finalX,finalY);
    velocity = new PVector();
    velocity = velocity.sub(target, location);
    
    hitbox = new AggroBox(int(x),int(y),5);
    
    velocity.normalize();
    velocity.mult(speed);
    
    outerRange = new AggroBox(int(x),int(y),outerDia);
    innerRange = new AggroBox(int(x),int(y),innerDia);
    
    sprite = new PImage();
    sprite = loadImage("res/enemy1_neutral.jpg");
    
  }
  
  void draw(){
    AI();
    move();
    image(sprite,x-16, y-16);
    for(int i = 0; i < bullets.size(); i++){
      bullets.get(i).moveBullet();
      bullets.get(i).draw();
      if(sqrt(pow(player.x - bullets.get(i).x,2)+pow(player.y - bullets.get(i).y,2)) <= player.sprite.width/2 + 2){
        
        player.wasKilled = true;
      }
      if (bullets.get(i).lifespan > 1000){
        bullets.remove(i);
      }
    }
    //debug
    //outerRange.draw(int(x),int(y));
    //innerRange.draw(int(x),int(y));
      
  }
  void AI(){
    if(state == "passive"){
      target.set(finalX, finalY);
      
      if(waypointCount > waypoints.length){
        waypointCount = 0;
      }
      if (x == finalX  && y == finalY){
       
        if(waypointCount ==3){
          waypointCount = 0;
        }
        else{
          waypointCount++;
        }
        finalX = waypoints[waypointCount].x;
        finalY = waypoints[waypointCount].y;
        
        target.set(finalX, finalY);
      }
      velocity = velocity.sub(target, location);
      velocity.normalize();
      velocity.mult(speed);
      
    }
    if(state == "trackPlayer"){
      target.set(player.x, player.y);
      
      velocity = velocity.sub(target, location);
      velocity.normalize();
      velocity.mult(speed+1);
      
    }
    if(state == "killPlayer"){
      if(bulletCooldown == 0){
        bullets.add(new Bullet(x,y, player.x + random(-15, 15), player.y + random(-15, 15)));
      }
    }
  }
  void move(){
    location.add(velocity);
    
    if (location.x > finalX){
      this.x = floor(location.x);
    }
    else{
      this.x = ceil(location.x);
    }
    if (location.y > finalY){
      this.y = floor(location.y);
    }
    else{
      this.y = ceil(location.y);
    }
  }
  
  void kill(){
    score += 100;
  }
}