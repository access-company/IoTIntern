// javasctipt

JavaScript javascript;

interface JavaScript {
  void notify(String msgType);
}

void bindJavaScript(JavaScript js) {
  javascript = js
}

// Robot/Room Objects class

class Sprite {
  PImage img;

  PImage img1;
  PImage img2;
  int lastUpdateTime;

  int xwidth;
  int xheight;

  int bbox_width;
  int bbox_height;

  int x = 0;
  int y = 0;
  int old_x = 0;
  int old_y = 0;

  float rot; // rotation
  float v = 0.0; // velocity

  boolean hit = false;

  // Effects to the robot from other objects.
  float v_weight = 1.0;

  boolean already_notified = false;

  // Static objects like room walls.
  Sprite(int xwidth, int xheight, int x, int y) {
    this.x = x;
    this.y = y;
    this.xwidth = xwidth;
    this.xheight = xheight;
    this.bbox_width = xwidth;
    this.bbox_height = xheight;
    this.v_weight = 1.0;
  }

  Sprite(int xwidth, int xheight, int x, int y, float v_weight) {
    this(xwidth, xheight, x, y);
    this.v_weight = v_weight;
  }

  Sprite(PImage img, int w, int h, int x, int y, float rot, float v, float v_weight) {
    this(w, h, x, y, v_weight);
    this.img = img;
    this.img1 = this.img;
    this.img2 = this.img;
    this.rot = rot;
    this.v = v;
  }

  void set_bbox(int width, int height) {
    this.bbox_width  = width;
    this.bbox_height = height;
  }

  void setFlippedImage(PImage flippedImg) {
    this.img1 = this.img
    this.img2 = flippedImg;
  }

  ArrayList<Integer> bbox() {
    ArrayList<Integer> arr = new ArrayList<Integer>();
    arr.add(this.x - int(this.bbox_width / 2));
    arr.add(this.y - int(this.bbox_height / 2));
    arr.add(this.x + int(this.bbox_width / 2));
    arr.add(this.y + int(this.bbox_height / 2));
    return arr;
  }

  void update() {
    int currentTime = hour() * 60 * 60 + minute() * 60 + second();
    if (this.lastUpdateTime == null) {
      this.lastUpdateTime = currentTime;
    }

    if (currentTime - this.lastUpdateTime > 1) {
      this.lastUpdateTime = currentTime;
      if (this.img == this.img2) {
        this.img = this.img1;
      } else {
        this.img = this.img2;
      }
    }

    if (this.img != null) {
      this.img.resize(this.xwidth, this.xheight);
    }
    this.draw();
  }

  void update(float v_weight) {
    this.v = this.v * v_weight;

    if (this.hit) {
      this.x = this.old_x;
      this.y = this.old_y;
      this.rot += random(-PI, PI);
    } else {
      this.old_x = this.x;
      this.old_y = this.y;
      this.x += this.v * cos(this.rot);
      this.y += this.v * sin(this.rot);
    }
    this.update()
  }

  void draw() {
    pushMatrix();
    translate(this.x, this.y);
    rotate(this.rot);
    if (this.img != null) {
      image(this.img, 0, 0);
    }
    fill(255, 0, 0, 0);
    stroke(255, 0, 0);
    // Drawing bbox rect.
    // rect(0, 0, this.bbox_width, this.bbox_height);
    popMatrix();
  }
}

PImage bg;
PImage explosion;
Sprite robot;
ArrayList<Sprite> room_objs = new ArrayList<Sprite>();

int startTime;

void setup() {
  size(600, 700);
  imageMode(CENTER);
  rectMode(CENTER);

  // FIXME: ugly workaround.
  startTime = hour() * 60 * 60 + minute() * 60 + second();

  bg        = loadImgAsset("background");
  explosion = loadImgAsset("explosion");

  robot    = new Sprite(loadImgAsset("pet_robot_soujiki_cat"),
                        100, 100,
                        400, 400,
                        0.0, 3.0, 1.0); // rot, v, v_weight
  senpuki  = new Sprite(loadImgAsset("kaden_senpuki"),
                        120, 160,
                        200, 300,
                        0.0, 0.0, 1.0);
  senpuki.setFlippedImage(loadImgAsset("kaden_senpuki2"))
  kitchen  = new Sprite(loadImgAsset("room_island_kitchen_nobg"),
                        180, 180,
                        120, 90,
                        0.0, 0.0, 1.0);
  tv       = new Sprite(loadImgAsset("tv_girl_chikaku"),
                        180, 180,
                        500, 80,
                        0.0, 0.0, 1.0);
  yukasita = new Sprite(loadImgAsset("room_yukashita_syuunou_open"),
                        180, 180,
                        400, 600,
                        0.0, 0.0, 0.0);

  yukasita.set_bbox(90, 90);

  room_objs.add(senpuki);
  room_objs.add(kitchen);
  room_objs.add(tv);
  room_objs.add(yukasita);
  room_objs.add(new Sprite(10, height, 10, height/2));
  room_objs.add(new Sprite(width, 10, width/2, 10));
  room_objs.add(new Sprite(10, height, width-10, height/2));
  room_objs.add(new Sprite(width, 10, width/2, height-10));

  //room_objs.add(new Sprite(10, int(height / 8), width - 300, 100, 1.0));
}

void draw() {
  frameRate(25);
  background(255, 255, 255);
  bg.resize(width, height);
  image(bg, bg.width/2, bg.height/2);
  robot.hit = false;
  ArrayList<Integer> robot_bb = robot.bbox();

  float v_weight = 1.0;
  for(Sprite obj: room_objs) {
    obj.update();
    if (collision_jadge(robot_bb, obj.bbox())){
      robot.hit = true;
      v_weight = obj.v_weight;
    }
  }

  if (robot.v == 0.0 && javascript != null && !robot.already_notified) {
    robot.already_notified = true;
    javascript.notify("derailment");
  }

  int currentTime = hour() * 60 * 60 + minute() * 60 + second();
  // robot will be down after 15s.
  if (currentTime - startTime > 10) {
    robot.v = 0.4
  }
  if (currentTime - startTime > 15) {
    robot.v = 0.0;
    if (!robot.already_notified) {
      javascript.notify("dead_battery");
    }
    robot.already_notified = true;
  }

  robot.update(v_weight);

  if (robot.v == 0.0) {
    image(explosion, robot.x, robot.y);
  }
}

PImage loadImgAsset(String filename) {
  String baseAssetsUrl = "/ui/image/";
  String imgUrl = baseAssetsUrl + filename + ".png";
  return loadImage(imgUrl);
}

boolean collision_jadge(ArrayList<Integer> bb1, ArrayList<Integer> bb2) {
  Integer width1  = bb1.get(2) - bb1.get(0);
  Integer width2  = bb2.get(2) - bb2.get(0);
  Integer height1 = bb1.get(3) - bb1.get(1);
  Integer height2 = bb2.get(3) - bb2.get(1);

  int[] x_list = {bb1.get(0), bb1.get(2), bb2.get(0), bb2.get(2)};
  int[] y_list = {bb1.get(1), bb1.get(3), bb2.get(1), bb2.get(3)};

  Integer x_max = max(x_list);
  Integer x_min = min(x_list);
  Integer y_max = max(y_list);
  Integer y_min = min(y_list);

  boolean x_cond = ((x_max - x_min) - (width1 + width2)) <= 0;
  boolean y_cond = ((y_max - y_min) - (height1 + height2)) <= 0;

  return (x_cond && y_cond);
}

void keyPressed() {
  if (javascript != null) {
    javascript.notify("derailment");
  }
}
