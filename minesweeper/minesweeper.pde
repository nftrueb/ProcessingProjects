ArrayList<Cell> cells;
IntList visited;
int wid = 150, highlight = 0, total_flagged = 0;
boolean follow_mouse, playing, game_won;
PImage flag_img;

void setup() {
  size(1200, 1200);
  textSize(50);
  textAlign(CENTER, CENTER);
  imageMode(CENTER);

  cells = new ArrayList<Cell>();
  visited = new IntList();
  flag_img = loadImage("flag.png");

  for (int i = 0; i < 8; i++) {
    for (int j = 0; j < 8; j++) {
      cells.add(new Cell(j, i, false, 0));
    }
  }

  set_board();
  follow_mouse = false;
  highlight = find_start_tile();
  if (highlight == -1) {
    println("ERROR: Empty tile not found");
  }
  playing = true;
  game_won = false;
}

void draw() {
  
  background(51);

  for (Cell c : cells) {
    stroke(0);
    strokeWeight(1);
    c.show();
  }

  //draw red highlight
  stroke(255, 0, 0);
  strokeWeight(3);
  noFill();
  Cell temp = cells.get(highlight);
  rect(temp.x*wid, temp.y*wid, wid, wid);
  if (!playing && !game_won) {
    display_fail_message();
  } else if(!playing && game_won) {
    display_win_message();
  }
}

void keyPressed() {

  switch(key) {
  case 'r':
    set_board();
    playing = true;
    break;
  }
}

void mousePressed() {
  if(mouseButton == LEFT) {
    if (!follow_mouse) 
      follow_mouse = true;
    for (Cell c : cells) {
      if (!c.covered) {
        continue;
      }
      //check if cell needs to be uncovered
      if (mouseX > c.x*wid && mouseX < (c.x+1)*wid && mouseY > c.y*wid && mouseY < (c.y+1)*wid) {
        c.currently_pressed = true;
        println("X: " + c.x + "   Y: " + c.y);
        if (!c.bomb) {
          println("Neighbors: " + c.neighbors);
        } else {
          println("Bomb");
        }
      }
    }
  } else {
     //place flag 
     for(Cell c : cells) {
       if(c.within_cell(mouseX,mouseY)){
         if(c.flag) {
           c.flag = false;
           total_flagged--;
         } else {
           c.flag = true;
           total_flagged++;
           if(total_flagged == 10) {
             if(check_win()) {
               game_won = true;
               playing = false;
               display_win_message();
             }
           }
         }
       }
     }
  }
}

void mouseReleased() {
  if(mouseButton == LEFT) {
  for (Cell c : cells) {
    if (c.currently_pressed) {
      //check if cell needs to be uncovered
      if (mouseX > c.x*wid && mouseX < (c.x+1)*wid && mouseY > c.y*wid && mouseY < (c.y+1)*wid) {
        c.currently_pressed = false;
        if (c.bomb) {
          c.covered = false;
          playing = false;
          display_fail_message();
        } else
          uncover_cells(c.x, c.y);
      } else {
        c.currently_pressed = false;
      }
      c.covered = false;
      return;
    }
  }
  }
}

boolean check_win() {
  
  for(Cell c : cells) {
    if(c.flag && !c.bomb) 
      return false;
  }
  
  return true;
}

void display_win_message() {
  playing = false;
  stroke(0,255,0);
  fill(100, 200);
  rect(100, 100, 1000, 1000);

  textSize(100);
  fill(255);
  text("ALL BOMBS FOUND", width/2, height/3);
  textSize(75);
  text("Press 'r' to Restart", width/2, height/2);
  textSize(50);
}

void display_fail_message() {
  playing = false;
  fill(100, 200);
  rect(100, 100, 1000, 1000);

  textSize(100);
  fill(255);
  text("GAME OVER", width/2, height/3);
  textSize(75);
  text("Press 'r' to Restart", width/2, height/2);
  textSize(50);
}


int find_start_tile() {
  for (int i = 0; i < 8*8; i++) {
    if (cells.get(i).neighbors == 0 && !cells.get(i).bomb) {
      return i;
    }
  }
  return -1;
}

void set_board() {
  total_flagged = 0;
  game_won = false;
  for (Cell c : cells) {
    c.bomb = false; 
    c.covered = true;
    c.currently_pressed = false;
    c.flag = false;
  }

  for (int i = 0; i < 10; i++) {
    int bombX = int(random(8));
    int bombY = int(random(8));
    while (cells.get(bombX + bombY*8).bomb) {
      bombX = int(random(8));
      bombY = int(random(8));
    }
    cells.get(bombX + bombY*8).bomb = true;
  }

  for (Cell c : cells) {
    c.neighbors = get_neighbors(c.x, c.y);
  }

  visited.clear();

  follow_mouse = false;
  highlight = find_start_tile();
}

int get_neighbors(int x, int y) {
  //println("-------------------------------------");
  //println("Checking Neighbors for X: " + x + "   Y: " + y);
  int neighboring_bombs = 0;

  if (cells.get(x+y*8).bomb)
    return neighboring_bombs;

  for (int i = -1; i <= 1; i++) {
    for (int j = -1; j <= 1; j++) {

      int checkX = x + i;
      int checkY = y + j;

      if (i == 0 && j == 0)
        continue;

      if (checkX < 0 || checkX >= 8 || checkY < 0 || checkY >= 8)
        continue;

      if (cells.get(checkX + checkY*8).bomb) {
        //println("X: " + checkX + "   Y: " + checkY);
        neighboring_bombs++;
      }
    }
  }

  //println("-------------------------------------");
  return neighboring_bombs;
}

void uncover_cells(int x, int y) {
  if (x < 0 || x >= 8 || y < 0 || y >= 8) 
    return;

  int index = x + y*8;
  //initial check if cell has any neighbors
  if (cells.get(index).neighbors != 0) {
    cells.get(index).covered = false;
    return;
  }

  if (visited.hasValue(index))
    return;

  visited.append(index);

  for (int i = -1; i <= 1; i++) {
    for (int j = -1; j <= 1; j++) {
      int checkX = x + i;
      int checkY = y + j;

      if (checkX < 0 || checkX >= 8 || checkY < 0 || checkY >= 8) 
        continue;

      cells.get(checkX + checkY*8).covered = false;
    }
  }

  uncover_cells(x, y-1); //check up
  uncover_cells(x+1, y); //check right
  uncover_cells(x, y+1); //check down
  uncover_cells(x-1, y); //check left
  uncover_cells(x-1, y-1);
  uncover_cells(x+1, y-1);
  uncover_cells(x-1, y+1);
  uncover_cells(x+1, y+1);
}

class Cell {
  int x, y, neighbors = 0;
  boolean covered = true, currently_pressed = false, bomb, flag = false;

  Cell(int x_, int y_, boolean bomb_, int neighbors_) {
    x = x_;
    y = y_;
    bomb = bomb_;
    neighbors = neighbors_;
  }

  boolean within_cell(float x_, float y_) {
    int curr_x = int(x_);
    int curr_y = int(y_);

    if (curr_x > x * wid && curr_x < (x+1) * wid) {
      if (curr_y > y * wid && curr_y < (y+1) * wid) {
        return true;
      }
    }

    return false;
  }

  void show() {
    //different fills for different states
    if (currently_pressed) {
      fill(100);
    } else if (!covered) {
      switch(neighbors) {
      case 0:
        fill(255);
        break;
      case 1:
        fill(110, 230, 120);
        break;
      case 2:
        fill(230, 230, 110);
        break;
      case 3:
        fill(255, 160, 50);
        break;
      case 4:
        fill(255, 50, 50);
        break;
      case 5:
        fill(130, 60, 230);
        break;
      }
    } else { //covered
      fill(150);
    }

    if (!covered && bomb)
      fill(0, 0, 255);

    if (follow_mouse && within_cell(mouseX, mouseY)) {
      highlight = x + y*8;
    }

    rect(x*wid, y*wid, wid, wid);
    if (!covered && !bomb && neighbors != 0) {
      fill(25);
      text(str(neighbors), x*wid + wid/2, y*wid + wid/2);
    }
    
    if(covered && flag) {
      image(flag_img, (x*wid)+wid/2, (y*wid)+wid/2, 100, 100); 
    }
  }
}
