class Player{
  int x, y, speed;
  PImage sprite;
  AggroBox playerHitbox;
  Inventory inv;
  boolean wasKilled, murderer;
  
  Player(int initX, int initY){
    this.x = initX;
    this.y = initY;
    this.speed = 3;
    wasKilled = false;
    inv = new Inventory();
    
    sprite = new PImage();
    sprite = loadImage("res/player_neutral.jpg");
    
    playerHitbox = new AggroBox(x,y,32,32);
  }
  
  void draw(){
    image(sprite,x-16,y-16);
  }
  
  void xMove(int dir, boolean sneak){
    //if (x <= 0){x = width;}
    //if (x > width){x = 0;}
    if (sneak){speed = 1;}
    else{speed = 3;}
    
    if(x >= width){
      x--;
    }
    else if(x <= 0){
      x++;
    }
    else{
      x = x + (dir * speed);
    }
  }
  
  void yMove(int dir, boolean sneak){
    //if (y <= 0){y = height;}
    //if (y > height){y = 0;}
    if (sneak){speed = 1;}
    else{speed = 3;}
    
    if(y >= height){
      y--;
    }
    else if(y <= 0){
      y++;
    }
    else{
      y = y + (dir * speed);
    }
  }
}