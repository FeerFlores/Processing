import processing.serial.*;

Serial myPort;

// Datos del sensor
float ax, ay, az, gx, gy, gz;
float roll = 0, pitch = 0;
float lastTime;

void setup() {
  size(800, 600, P3D);
  println(Serial.list());
  myPort = new Serial(this, Serial.list()[0], 115200);
  myPort.bufferUntil('\n');
  lastTime = millis();
}

void draw() {
  background(10);
  lights();
  ambientLight(60, 60, 60);
  directionalLight(255, 255, 255, -0.5, 0.5, -1);

  float dt = (millis() - lastTime) / 1000.0;
  lastTime = millis();

  // Filtro complementario para calcular roll y pitch
  float rollAcc  = degrees(atan2(ay, az));
  float pitchAcc = degrees(atan2(-ax, sqrt(ay * ay + az * az)));
  float gxDPS = gx / 131.0;
  float gyDPS = gy / 131.0;

  float alpha = 0.98;
  roll  = alpha * (roll + gxDPS * dt) + (1 - alpha) * rollAcc;
  pitch = alpha * (pitch + gyDPS * dt) + (1 - alpha) * pitchAcc;

  translate(width / 2, height / 2, -200);
  rotateX(radians(roll));
  rotateY(radians(pitch));
  rotateZ(radians(gz / 131.0 * dt)); // yaw opcional

  drawAvion();
}

// === Modelo del avión centrado ===
void drawAvion() {
  pushMatrix();
  noStroke();

  // === Fuselaje simple (naranja) ===
  fill(173, 79, 0);
  pushMatrix();
  translate(0, 0, -30); // centra con alas
  box(20, 20, 150);     // ancho, alto, largo
  popMatrix();

  // Alas triangulares blancas
  fill(255);
  pushMatrix();
  translate(0, 0, 0);
  drawTriWing();
  popMatrix();

  // Aleta trasera
  fill(255);
  pushMatrix();
  translate(0, -15, 40);
  box(5, 25, 3);
  popMatrix();

  popMatrix();

}


// === Alas en forma de triángulo tipo delta ===
void drawTriWing() {
  beginShape();
  vertex(0, 0, 0);           // centro del fuselaje
  vertex(-80, 0, -50);       // ala izquierda más ancha
  vertex(0, 0, -90);         // punta de ala
  vertex(80, 0, -50);        // ala derecha más ancha
  endShape(CLOSE);
}


// === Leer datos del sensor MPU6050 vía Serial ===
void serialEvent(Serial p) {
  String inData = p.readStringUntil('\n');
  if (inData != null) {
    String[] vals = trim(split(inData, ','));
    if (vals.length == 6) {
      ax = float(vals[0]);
      ay = float(vals[1]);
      az = float(vals[2]);
      gx = float(vals[3]);
      gy = float(vals[4]);
      gz = float(vals[5]);
    }
  }
}
void cylinder(float r, float h) {
  int sides = 36;
  float angle;
  float[] x = new float[sides+1];
  float[] z = new float[sides+1];
  for (int i = 0; i <= sides; i++) {
    angle = TWO_PI / sides * i;
    x[i] = cos(angle) * r;
    z[i] = sin(angle) * r;
  }

  // tapa inferior
  beginShape(TRIANGLE_FAN);
  vertex(0, 0, 0);
  for (int i = 0; i <= sides; i++) {
    vertex(x[i], z[i], 0);
  }
  endShape();

  // tapa superior
  beginShape(TRIANGLE_FAN);
  vertex(0, 0, h);
  for (int i = 0; i <= sides; i++) {
    vertex(x[i], z[i], h);
  }
  endShape();

  // costado
  beginShape(QUAD_STRIP);
  for (int i = 0; i <= sides; i++) {
    vertex(x[i], z[i], 0);
    vertex(x[i], z[i], h);
  }
  endShape();
}
