import processing.serial.*;

// --- Variables de serie y sensores ---
Serial myPort;
float ax, ay, az, gx, gy, gz;
float roll, pitch;
float lastTime, gyroRoll = 0, gyroPitch = 0;

void setup() {
  size(640, 360, P3D);
  noStroke();
  
  // Inicializa el puerto serie (ajusta el índice si no es [0])
  println( Serial.list() );
  myPort = new Serial(this, Serial.list()[0], 115200);
  myPort.bufferUntil('\n');
  
  lastTime = millis();
}

void serialEvent(Serial p) {
  String line = p.readStringUntil('\n');
  if (line != null) {
    line = trim(line);
    String[] tok = split(line, ' ');
    if (tok.length >= 6) {
      ax = float(tok[0]);
      ay = float(tok[1]);
      az = float(tok[2]);
      gx = float(tok[3]);
      gy = float(tok[4]);
      gz = float(tok[5]);
    }
  }
}

void draw() {
  background(0);
  translate(width/2, height/2, 0);

  // ————— Iluminación “Mixture” —————
  // Luz puntual naranja a la derecha
  pointLight(150, 100, 0,  200, -150, 0);
  // Luz direccional azul desde la izquierda
  directionalLight(0, 102, 255,  1, 0, 0);
  // Spotlight amarillo desde el frente
  spotLight(255, 255, 109,  0, 40, 200,  0, -0.5, -0.5,  PI/2, 2);

  // ————— Cálculo de ángulos con filtro complementario —————
  float rollAcc  = atan2(ay, az);
  float pitchAcc = atan2(-ax, sqrt(ay*ay + az*az));
  
  float dt = (millis() - lastTime) / 1000.0;
  lastTime = millis();
  
  gyroRoll  += radians(gx) * dt;
  gyroPitch += radians(gy) * dt;
  
  float alpha = 0.98;
  roll  = alpha * gyroRoll  + (1 - alpha) * rollAcc;
  pitch = alpha * gyroPitch + (1 - alpha) * pitchAcc;

  // ————— Dibujo del cubo —————
  pushMatrix();
    rotateY(roll);
    rotateX(pitch);
    box(150);
  popMatrix();
}