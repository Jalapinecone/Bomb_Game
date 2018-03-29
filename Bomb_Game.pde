//vars
int score, bombCooldown, wallDist;
ArrayList<Item> bombs, decoys;
ArrayList<Building> buildings;
ArrayList<Enemy> enemies;
Player player;
boolean endgame;
boolean tutorial = true;

boolean up,down,left,right, sneak, isOnBombFac, isOnDecoy, eHit, detonated;
PImage background, hud_inv, bomb_img, decoy_img;
int speedMultiplier, bombCount;

void setup(){
  up = false;
  down = false;
  left = false;
  right = false;
  sneak = false;
  isOnBombFac = false;
  isOnDecoy = false;
  detonated = false;
  endgame = false;
  speedMultiplier = 1;
  bombCount = 0;
  bombCooldown = 0;
  wallDist = 70;
  
  bombs = new ArrayList<Item>(4);
  decoys = new ArrayList<Item>(2);
  buildings = new ArrayList<Building>(3);
  enemies = new ArrayList<Enemy>(4);
  
  buildings.add(new Building(200, 150, "bombFactory"));
  buildings.add(new Building(900, 500, "bombFactory"));
  buildings.add(new Building(540, 300, "civilian"));
  
  Waypoint[] waypoints = new Waypoint[4];
  
  print(buildings.get(0).x - wallDist);
  print(",");
  print(buildings.get(0).y - wallDist);
  waypoints[0] = new Waypoint(buildings.get(0).x - wallDist, buildings.get(0).y - wallDist);
  waypoints[1] = new Waypoint(buildings.get(0).x - wallDist, buildings.get(0).y + buildings.get(0).sprite.height + wallDist);
  waypoints[2] = new Waypoint(buildings.get(0).x + buildings.get(0).sprite.width + wallDist, buildings.get(0).y + buildings.get(0).sprite.height + wallDist);
  waypoints[3] = new Waypoint(buildings.get(0).x + buildings.get(0).sprite.width + wallDist, buildings.get(0).y - wallDist);
  
  enemies.add(new Enemy(waypoints[0].x,waypoints[0].y, waypoints,0));
  enemies.add(new Enemy(waypoints[2].x,waypoints[2].y, waypoints,2));
  
  Waypoint[] waypoints2 = new Waypoint[4];
  waypoints2[0] = new Waypoint(buildings.get(1).x - wallDist, buildings.get(1).y - wallDist);
  waypoints2[1] = new Waypoint(buildings.get(1).x - wallDist, buildings.get(1).y + buildings.get(1).sprite.height + wallDist);
  waypoints2[2] = new Waypoint(buildings.get(1).x + buildings.get(1).sprite.width + wallDist, buildings.get(1).y + buildings.get(1).sprite.height + wallDist);
  waypoints2[3] = new Waypoint(buildings.get(1).x + buildings.get(1).sprite.width + wallDist, buildings.get(1).y - wallDist);

  enemies.add(new Enemy(waypoints2[0].x,waypoints2[0].y, waypoints2,0));
  enemies.add(new Enemy(waypoints2[2].x,waypoints2[2].y, waypoints2,2));
  
  
  
  frameRate(60);
  //objects
  player = new Player(100, 660);
  
  background = new PImage();
  background = loadImage("res/back.jpg");
  hud_inv = new PImage();
  hud_inv = loadImage("res/HUD_inv.png");
  bomb_img = new PImage();
  bomb_img = loadImage("res/bomb.png");
  decoy_img = new PImage();
  decoy_img = loadImage("res/decoy.jpg");
  
  size(1280,720);
}

void draw(){
  if(!endgame){
    if(tutorial){ 
      background(150);
      textSize(47);
      text("TACTICAL SABOTAGE 200X",300,150);
      text("WASD to move.",300,250);
      text("E to pick up bomb.",300,300);
      text("Q to detonate (only 1 per game).",300,350);
      if (keyCode == 'W'){tutorial = false;}
      if (keyCode == 'S'){tutorial = false;}
      if (keyCode == 'A'){tutorial = false;}
      if (keyCode == 'D'){tutorial = false;}
    }
    else{
      if(player.wasKilled){
        killed();
      }
      background(background);
      
      checkCollisions();
      
      if (up){player.yMove(-speedMultiplier, sneak);}
      if (down){player.yMove(speedMultiplier, sneak);}
      if (left){player.xMove(-speedMultiplier, sneak);}
      if (right){player.xMove(speedMultiplier, sneak);}
      if(bombCooldown != 0){bombCooldown--;}
      
      for(int i = 0; i < buildings.size(); i++){
        buildings.get(i).draw();
      }
      
      for(int i = 0; i < bombs.size(); i++){
        bombs.get(i).draw();
      }
      
      for(int i = 0; i < decoys.size(); i++){
        decoys.get(i).draw();
      }
      
      for(int i = 0; i < enemies.size(); i++){
        enemies.get(i).draw();
      }
      
      player.draw();
      drawHUD();
    }
  }
  else{
    background(20);
    String scoreOut = "Score: " + score;
    textSize(47);
    text(scoreOut,500,500);
    if(mousePressed){
      setup();
    }
  }
}

void drawHUD(){
  image(hud_inv, 5,5);
  if(player.inv.checkItems()){
    if(player.inv.item.type == "bomb"){
      image(bomb_img,32-bomb_img.width/2, 32-bomb_img.height/2);
    }
    else if(player.inv.item.type == "decoy"){
      image(decoy_img,32-decoy_img.width/2, 32 - decoy_img.height/2);
    }
  }
}
void checkCollisions(){
  //player is on a bomb factory tile
  for(int i = 0; i < buildings.size(); i++){
    if(buildings.get(i).type == "bombFactory"){
      if(player.x >= buildings.get(i).x && player.x <= buildings.get(i).x + buildings.get(i).sprite.width && player.y <= buildings.get(i).y + buildings.get(i).sprite.height && player.y >= buildings.get(i).y){
        isOnBombFac = true;
        break;
      }
      else{
        isOnBombFac = false;
      }
    }
  }
  
  
  //bombs explode and chain
  for(int i = 0; i < bombs.size(); i++){
    
    for(int j = 0; j < bombs.size(); j++){
      if(i != j){
        if(sqrt(pow(bombs.get(i).x - bombs.get(j).x,2)+pow(bombs.get(i).y - bombs.get(j).y,2)) <= bombs.get(i).radius/1.5 + bombs.get(j).radius/1.5){
          if(!bombs.get(j).detonated){
            bombs.get(j).detonate();
            break;
          }
        }
      }
      for(int k = 0; k < buildings.size();k++){
            if(buildings.get(k).dead){
              buildings.remove(k);
              endgame = true;
              break;
            }
          }
    }
    //check if each bomb is detonated and hits a building radius.
    for(int j = 0; j < buildings.size(); j++){
      if(sqrt(pow(bombs.get(i).x - buildings.get(j).x,2)+pow(bombs.get(i).y - buildings.get(j).y,2)) <= bombs.get(i).radius/1.5 + 32){
        if(!buildings.get(j).detonated){
          buildings.get(j).detonate();
          break;
        }
        if(buildings.get(j).radius <= 0){
          buildings.remove(j);
          break;
        }
      }
    }
    //check if enemy explodes
    for(int j = 0; j < enemies.size(); j++){
      if(sqrt(pow(bombs.get(i).x - enemies.get(j).x,2)+pow(bombs.get(i).y - enemies.get(j).y,2)) <= bombs.get(i).radius/1.5 + 32){
        if(bombs.get(i).detonated){
          enemies.get(j).kill();
          enemies.remove(j);
          break;
        }
      }
    }
  }
  
  // player is in enemy range
  for(int i = 0; i < enemies.size(); i++){
    if(sqrt(pow(player.x - enemies.get(i).x,2)+pow(player.y - enemies.get(i).y, 2)) <= player.sprite.width/2 + enemies.get(i).outerRange.rad/2){
      if(!sneak){
        //fill(0,255,0);
        //ellipse(enemies.get(i).x, enemies.get(i).y,enemies.get(i).outerRange.rad, enemies.get(i).outerRange.rad);
        enemies.get(i).state = "trackPlayer";
      }
    }
    else{
      enemies.get(i).state = "passive";
    }
    
    if(sqrt(pow(player.x - enemies.get(i).x,2)+pow(player.y - enemies.get(i).y, 2)) <= player.sprite.width/2 + enemies.get(i).innerRange.rad/2){
      //fill(255,255,0);
      //ellipse(enemies.get(i).x, enemies.get(i).y,enemies.get(i).innerRange.rad, enemies.get(i).innerRange.rad);
      enemies.get(i).state = "killPlayer";
    }
  }
}

void keyPressed(){
  if (keyCode == 'W'){up = true;}
  if (keyCode == 'S'){down = true;}
  if (keyCode == 'A'){left = true;}
  if (keyCode == 'D'){right = true;}
  if (keyCode == SHIFT){sneak = true;}
  
  if (keyCode == 'Q'){
    if(bombs.size() > 0){
      if(!detonated){
        detonated = true;
        bombs.get(0).detonate();
      }
    }
  }
  
  if (keyCode == 'E'){
    if(bombCooldown == 0){
      if (player.inv.checkItems()){
        if (player.inv.item.type == "bomb"){
          //plant bomb
          player.inv.remove();
          bombs.add(new Item("bomb"));
          bombs.get(bombCount).plant(player.x , player.y);
          bombs.get(bombCount).draw();
          bombCount++;
          
          print(" Bomb has been planted");
        }
        else if (player.inv.item.type == "decoy"){
          //plant decoy
          player.inv.remove();
          decoys.add(new Item("decoy"));
          decoys.get(bombCount).plant(player.x , player.y);
          decoys.get(bombCount).draw();
          print(" Decoy Out!");
        }
      }
      if(isOnBombFac){
      player.inv.add(new Item("bomb"));
      }
      else if(isOnDecoy){
        player.inv.add(new Item("decoy"));
      }
      bombCooldown = 60;
    }
  }
}

void keyReleased(){
  if (keyCode == 'W'){up = false;}
  if (keyCode == 'S'){down = false;}
  if (keyCode == 'A'){left = false;}
  if (keyCode == 'D'){right = false;}
  if (keyCode == SHIFT){sneak = false;}
}
void killed(){
  setup();
}