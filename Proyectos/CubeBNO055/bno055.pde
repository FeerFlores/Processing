// ==== BNO055 → Processing 3D Viewer (Cube) ====
// Lectura robusta CSV: yaw,roll,pitch (grados)
// ================================================

import processing.serial.*;

// ───────────────────────────────────────────────
// Configuración de puerto serie
// ───────────────────────────────────────────────
String portName = "COM54";   // Cambia si tu puerto COM es otro
int    baud     = 115200;    // Debe coincidir con Arduino
Serial serial;

// ───────────────────────────────────────────────
// Estado de orientación (grados desde BNO055)
// ───────────────────────────────────────────────
float yawDeg   = 0;  // heading (alrededor del eje Z)
float rollDeg  = 0;  // roll    (alrededor del eje X)
float pitchDeg = 0;  // pitch   (alrededor del eje Y)

// Suavizado (0..1) – más alto = responde más rápido
float alpha = 0.15;

// Por si quieres invertir ejes más adelante
boolean invertYaw   = false;
boolean invertRoll  = false;
boolean invertPitch = false;

// Robustez de lectura
int     warmup     = 10;     // ignora las primeras N líneas
boolean debugIO    = false;  // true para imprimir algunas líneas entrantes
int     debugLines = 0;


// ==================================================
//                Processing lifecycle
// ==================================================
void settings() {
  size(900, 600, P3D);
}

void setup() {
  surface.setTitle("BNO055 → Processing 3D Viewer (Cube)");

  // Mostrar puertos disponibles en consola
  printArray(Serial.list());

  // Intentar abrir el puerto
  if (portName == null || portName.isEmpty()) {
    println(" Especifica portName ");
  } else {
    try {
      serial = new Serial(this, portName, baud);
      serial.clear();
      serial.bufferUntil('\n');
    } catch (Exception e) {
      println("No se pudo abrir el puerto " + portName + " a " + baud + " baudios.");
      println("¿Está el puerto ocupado por otra app? Cierra el Monitor Serie del Arduino IDE.");
    }
  }

  lights();
}

void draw() {
  background(18);
  lights();

  // ── Cámara sencilla ───────────────────────────
  translate(width / 2, height / 2, 0);
  rotateX(radians(15));
  translate(0, 0, -100);

  // ── Ejes de referencia ────────────────────────
  pushMatrix();
  drawAxes(180);
  popMatrix();

  // ── Convertir a radianes ──────────────────────
  float yawRad   = radians(invertYaw   ? -yawDeg   : yawDeg);
  float rollRad  = radians(invertRoll  ? -rollDeg  : rollDeg);
  float pitchRad = radians(invertPitch ? -pitchDeg : pitchDeg);

  // ── Aplicar rotaciones (orden BNO055: Z → Y → X) ─
  pushMatrix();
  rotateZ(yawRad);     // heading
  rotateY(pitchRad);   // pitch
  rotateX(rollRad);    // roll

  // ── Dibujar cubo ──────────────────────────────
  noStroke();
  fill(180);
  box(160);

  // “Nariz” para ver dirección (roja, eje +X del cubo)
  fill(240, 0, 0);
  translate(100, 0, 0);
  sphere(12);

  popMatrix();

  // ── HUD con valores ───────────────────────────
  camera();                   // volver a cámara 2D
  hint(DISABLE_DEPTH_TEST);   // que el texto quede arriba
  fill(255);
  textSize(14);
  text(
    "Yaw (°):   " + nf(yawDeg,   1, 2) +
    "\nPitch (°): " + nf(pitchDeg, 1, 2) +
    "\nRoll (°):  " + nf(rollDeg,  1, 2),
    12, 20
  );
  hint(ENABLE_DEPTH_TEST);
}


// ==================================================
//                 Serial / Parsing
// ==================================================
void serialEvent(Serial p) {
  String line = p.readStringUntil('\n');
  if (line == null) return;

  line = trim(line);
  if (line.length() == 0) return;

  if (debugIO && debugLines < 5) {   // imprime algunas líneas para verificar
    println("LINE:", line);
    debugLines++;
  }

  // Ignorar líneas de arranque del puerto
  if (warmup > 0) {
    warmup--;
    return;
  }

  // Validar formato CSV numérico: num,num,num (con signo/decimales opcionales)
  String csvRegex = "^[\\-+]?\\d+(?:\\.\\d+)?,[\\-+]?\\d+(?:\\.\\d+)?,[\\-+]?\\d+(?:\\.\\d+)?$";
  if (match(line, csvRegex) == null) {
    // línea no válida → ignorar
    return;
  }

  String[] t = split(line, ',');
  if (t.length != 3) return;

  float y0 = parseFloat(t[0]);  // yaw
  float r0 = parseFloat(t[1]);  // roll
  float p0 = parseFloat(t[2]);  // pitch

  // Evitar contaminar con NaN / Infinito
  if (Float.isNaN(y0) || Float.isNaN(r0) || Float.isNaN(p0) ||
      Float.isInfinite(y0) || Float.isInfinite(r0) || Float.isInfinite(p0)) {
    return;
  }

  // Suavizado exponencial
  yawDeg   = lerp(yawDeg,   y0, alpha);
  rollDeg  = lerp(rollDeg,  r0, alpha);
  pitchDeg = lerp(pitchDeg, p0, alpha);
}


// ==================================================
//                 Utilidades
// ==================================================
void keyPressed() {
  if (key == 'r' || key == 'R') {
    yawDeg = rollDeg = pitchDeg = 0;
    println("Reseteado: yaw/roll/pitch = 0");
  }
}

void drawAxes(float len) {
  strokeWeight(2);

  // X (rojo)
  stroke(255, 60, 60);
  line(0, 0, 0, len, 0, 0);

  // Y (verde)
  stroke(60, 255, 100);
  line(0, 0, 0, 0, len, 0);

  // Z (azul)
  stroke(80, 160, 255);
  line(0, 0, 0, 0, 0, len);

  noStroke();
}