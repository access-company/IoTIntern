// robot vacuum simulator
// Reference: https://p5js.org/reference/

const frame_rate = 25; // frame/sec
const flip_frame_interval = 25; // frame interval of image flipping
const frame_battery_dead = frame_rate * 10; // time limit

let img_bg, img_explosion;
let robot, senpuki, kitchen, tv, yukasita, you;
let room_objs = [];
let frame_counter = 0;
let robot_message = "";
let is_notified = false;

function setup() {
  createCanvas(600, 700);
  imageMode(CENTER);
  rectMode(CENTER);
  frameRate(frame_rate);

  img_bg = loadImage("image/background.png");
  img_explosion = loadImage("image/explosion.png");

  robot = new RectObj(
    loadImage("image/pet_robot_soujiki_cat.png"),
    100,
    100,
    400,
    400,
    0.0,
    3.0,
    1.0
  );

  senpuki = new RectObj(
    loadImage("image/kaden_senpuki.png"),
    120,
    160,
    200,
    300,
    0.0,
    0.0,
    1.0
  );
  senpuki.set_flipped_image(loadImage("image/kaden_senpuki2.png"));
  room_objs.push(senpuki);

  kitchen = new RectObj(
    loadImage("image/room_island_kitchen_nobg.png"),
    180,
    180,
    120,
    90,
    0.0,
    0.0,
    1.0
  );
  room_objs.push(kitchen);

  tv = new RectObj(
    loadImage("image/tv_girl_chikaku.png"),
    180,
    180,
    500,
    80,
    0.0,
    0.0,
    1.0
  );
  room_objs.push(tv);

  yukasita = new RectObj(
    loadImage("image/room_yukashita_syuunou_open.png"),
    180,
    180,
    400,
    600,
    0.0,
    0.0,
    0.0
  );
  yukasita.set_bbox(90, 90);
  room_objs.push(yukasita);
}

function draw() {
  frame_counter += 1;
  image(img_bg, img_bg.width / 2, img_bg.height / 2);

  senpuki.flip(flip_frame_interval);

  room_objs.forEach((obj) => {
    obj.display();
  });

  robot.collision_judge(room_objs);
  robot.move();
  robot.display();

  if (robot.v == 0.0) {
    handle_message("derailment");
  } else if (frame_counter == frame_battery_dead - 2.0 * frame_rate) {
    // decrease velocity about two seconds before time limit
    robot.v = 0.7;
  } else if (frame_counter == frame_battery_dead) {
    let msg = Math.random() < 0.5 ? "jamming" : "dead_battery";
    handle_message(msg);
    robot.v = 0.0;
  }

  if (is_notified) {
    image(img_explosion, robot.x, robot.y);
    show_text(robot_message, robot.x - robot.display_width, robot.y);
  }
}

class RectObj {
  constructor(img, w, h, x, y, rot, v, v_weight) {
    this.display_width = w;
    this.display_height = h;
    this.x = x;
    this.y = y;
    this.bbox_width = w;
    this.bbox_height = h;
    this.v_weight = v_weight;
    this.img = img;
    this.img1 = this.img;
    this.img2 = this.img;
    this.rot = rot;
    this.v = v;

    this.hit = false;
    this.v_weight_collision = 1.0;
    this.old_x = 0.0;
    this.old_y = 0.0;
  }

  collision_judge(room_objs) {
    if (this.boundary_collision_judge()) this.hit = true;
    room_objs.forEach((obj) => {
      if (this.bbox_collision_judge(this.bbox(), obj.bbox())) {
        this.hit = true;
        this.v_weight_collision = obj.v_weight;
      }
    });
  }

  move() {
    this.v = this.v * this.v_weight_collision;

    if (this.hit) {
      this.x = this.old_x;
      this.y = this.old_y;
      this.rot += random(-PI, PI);
      this.hit = false;
    } else {
      this.old_x = this.x;
      this.old_y = this.y;
      this.x += this.v * cos(this.rot);
      this.y += this.v * sin(this.rot);
    }
  }

  set_flipped_image(img_flipped) {
    this.img1 = this.img;
    this.img2 = img_flipped;
  }

  flip(frame_interval) {
    if (int(frame_counter / frame_interval) % 2 == 0) {
      this.img = this.img1;
    } else {
      this.img = this.img2;
    }
  }

  display() {
    image(this.img, this.x, this.y, this.display_width, this.display_height);
  }

  // collision detection between RectObj and canvas boundary
  boundary_collision_judge() {
    return (
      this.x > width - this.display_width / 2 ||
      this.x < this.display_width / 2 ||
      this.y > height - this.display_height / 2 ||
      this.y < this.display_height / 2
    );
  }

  // collision detection between RectObjs
  bbox_collision_judge(bb1, bb2) {
    const width1 = bb1[2] - bb1[0];
    const width2 = bb2[2] - bb2[0];
    const height1 = bb1[3] - bb1[1];
    const height2 = bb2[3] - bb2[1];

    const x_list = [bb1[0], bb1[2], bb2[0], bb2[2]];
    const y_list = [bb1[1], bb1[3], bb2[1], bb2[3]];

    const x_max = max(x_list);
    const x_min = min(x_list);
    const y_max = max(y_list);
    const y_min = min(y_list);

    const x_cond = x_max - x_min - (width1 + width2) <= 0;
    const y_cond = y_max - y_min - (height1 + height2) <= 0;

    return x_cond && y_cond;
  }

  set_bbox(width, height) {
    this.bbox_width = width;
    this.bbox_height = height;
  }

  bbox() {
    return [
      this.x - int(this.bbox_width / 2),
      this.y - int(this.bbox_height / 2),
      this.x + int(this.bbox_width / 2),
      this.y + int(this.bbox_height / 2),
    ];
  }
}

async function handle_message(msg_type) {
  if (is_notified) return;
  is_notified = true;
  const res_body = await notify_linkit(msg_type);
  const messages = {
    dead_battery: "バッテリー不足",
    derailment: "脱輪",
    jamming: "異物混入",
  };
  robot_message =
    messages[msg_type] + "\nメッセージ送信完了日時\n" + res_body.sent_at;
}

// post a message to linkit
async function notify_linkit(msg_type) {
  const url = "http://iot-intern.localhost:8080/api/v1/alert";
  const response = await fetch(url, {
    method: "POST", // *GET, POST, PUT, DELETE, etc.
    mode: "cors", // no-cors, *cors, same-origin
    cache: "no-cache", // *default, no-cache, reload, force-cache, only-if-cached
    credentials: "same-origin", // include, *same-origin, omit
    headers: { "Content-Type": "application/json" },
    redirect: "follow", // manual, *follow, error
    referrerPolicy: "no-referrer", // no-referrer, *no-referrer-when-downgrade, origin, origin-when-cross-origin, same-origin, strict-origin, strict-origin-when-cross-origin, unsafe-url
    body: JSON.stringify({ type: msg_type }), // 本文のデータ型は "Content-Type" ヘッダーと一致する必要があります
  });
  return response.json(); // レスポンスの JSON を解析
}

function show_text(msg, x, y) {
  textAlign(CENTER);
  textStyle(BOLD);
  text(msg, x, y);
}
