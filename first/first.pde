int a = 0;
void setup() {
  size(600,600);
}
void draw() {
 background(a % 255, 255 - (a % 255), a % 255); 
 a++;
}
