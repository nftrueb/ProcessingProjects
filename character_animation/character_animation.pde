Player p;
boolean up_flag = false, down_flag = false, left_flag = false, right_flag = false;
PImage sprite;
void setup() {
  size(800, 800);
  rectMode(CENTER);
  p = new Player(width/2, height/2);
  sprite = loadImage("mario_sprites.jpg");
}

void draw() {
  background(51);  
  image(sprite, 0,0);
  //p.move();
}

void keyPressed() {
  //get key that was pressed and track it until it is released
  switch(keyCode) {
     case UP:
       up_flag = true;
       break;
     
     case DOWN:
       down_flag = true;
       break;
     
     case LEFT:
       left_flag = true;
       break;
     
     case RIGHT:
       right_flag = true;
       break;
  }
}

void keyReleased() {
  //mark correct key as released
  switch(keyCode) {
     case UP:
       up_flag = false;
       break;
     
     case DOWN:
       down_flag = false;
       break;
     
     case LEFT:
       left_flag = false;
       break;
     
     case RIGHT:
       right_flag = false;
       break;
  }
}

class Player {
  float x, y, speed = 2.0, pwidth = 40, pheight = 40;
  int col = 255;
  
  Player(float x_, float y_) {
    x = x_;
    y = y_;
  }
  
  void move() {
    if(up_flag && left_flag) {
    x -= speed;
    y -= speed;
      
    } else if(up_flag && right_flag) {
      x += speed;
      y -= speed;
      
    } else if(down_flag && left_flag) {
      x -= speed;
      y += speed;
      
    } else if(down_flag && right_flag) {
      x += speed;
      y += speed;
      
    } else if(up_flag) {
      y -= speed;
      
    } else if(left_flag) {
      x -= speed;
    } else if(down_flag) {
      y += speed;
    } else if(right_flag) {
      x += speed;
    }
    
    show();
  }
  
  void show() {
    fill(col);
    rect(x, y, pwidth, pheight);
  }
  
}
