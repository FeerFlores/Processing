// js/serial.js

window.addEventListener('load', () => {
  const btn = document.getElementById('btnConnect');
  const log = document.getElementById('log');
  let pjs;  // instancia de Processing

  btn.addEventListener('click', async () => {
    try {
      // 1) Solicita permiso al usuario y abre el puerto
      const port = await navigator.serial.requestPort();
      await port.open({ baudRate: 115200 });

      // 2) Crea un lector de texto
      const decoder = new TextDecoderStream();
      port.readable.pipeTo(decoder.writable);
      const reader = decoder.readable.getReader();

      // 3) Obtén la instancia de Processing.js
      pjs = Processing.getInstanceById('canvas1');

      // 4) Lee líneas en bucle
      while (true) {
        const { value, done } = await reader.read();
        if (done) break;

        // Puede venir más de una línea por chunk
        value.split('\n').forEach(rawLine => {
          const line = rawLine.trim();
          if (!line) return;

          // Muestra en el log
          log.textContent = line;

          // Parsear seis floats
          const toks = line.split(' ');
          if (toks.length >= 6) {
            const nums = toks.map(parseFloat);
            // Llamada al método del sketch
            pjs.updateSensors(
              nums[0], nums[1], nums[2],
              nums[3], nums[4], nums[5]
            );
          }
        });
      }
    } catch (err) {
      console.error(err);
      log.textContent = '¡Error: ' + err.message;
    }
  });
});