PImage flag;
void setup() {
   size(600,600);
   flag = loadImage("flag.png");
}

void draw() {
  
  background(200);
  image(flag, 0, 0, 100, 100);
}
