/**
 * Mixture con datos de IMU
 */

float ax, ay, az, gx, gy, gz;
float roll, pitch;
float lastTime, gyroRoll = 0, gyroPitch = 0;

void setup() {
  size(640, 360, P3D);
  noStroke();
  lastTime = millis();
}

void draw() {
  background(0);
  translate(width/2, height/2, 0);

  // ————— Iluminación “Mixture” —————
  pointLight(150, 100, 0,  200, -150, 0);
  directionalLight(0, 102, 255,  1, 0, 0);
  spotLight(255, 255, 109,  0, 40, 200,  0, -0.5, -0.5,  PI/2, 2);

  // ————— Filtro complementario —————
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

// Este método lo invoca el JS cada vez que llega una línea del IMU
public void updateSensors(float _ax, float _ay, float _az,
                          float _gx, float _gy, float _gz) {
  ax = _ax;
  ay = _ay;
  az = _az;
  gx = _gx;
  gy = _gy;
  gz = _gz;
}