# CubeMPU
Giroscopio 3D con Micropython y Javascript

<div align = "center">
<a href='https://postimages.org/' target='_blank'><img src='https://i.postimg.cc/3R1Y4Svw/modelado.gif' border='0' alt='modelado' width = "200px"/></a>
</div>

# Materiales

- UNIT Pulsar ESP32C6
- MPU6050
- Expansor I2C
  
# Instrucciones

1. Desde Thonny IDE guarda en tu microcontrolador los archivos que están dentro del directorio **Micropython** directamente en el microcontrolador.
2. Puedes depurar los resultados viendo la consola de Thonny IDE.
3. Entra al link que se encuentra en la descripción.
4. Conecta tu microcontrolador a la computadora y escoge el puerto COM donde se encuentra tu dispositivo.
5. Listo! Ya puedes empezara mover el MPU6050 y el modelo 3D lo seguirá!

# Microcontroladores probados:

| Tarjeta | Prueba        |
|---------|---------------| 
| ESP32C6 | Funcionando   |
| RP2040  | Falta probar  |
| STM32   | Falta probar  |

# Consideración

Puedes conectar tu MPU6050 sin necesidad del expansor I2C, solo tendrás que cambiar dentro de **MPU6050.py** los GPIO donde conectaste los puertos I2C.

# Primeros pasos

1. Actualiza el firmware de tu microcontrolador en la pestaña inferior derecha.
2. Busca tu dispositivo:
3. 
 <div align = "center">  
   
![image](https://github.com/user-attachments/assets/97c33242-f661-4415-a033-64ce971bba18)
</div>

3. Click en configurar intérprete:
   
<div align = "center">
  
![image](https://github.com/user-attachments/assets/f0419972-adf8-4d36-bfb9-9b438cc58a7c)
</div>

4. Click en instala Micropython:
   
<div align = "center">
  
![image](https://github.com/user-attachments/assets/15233b61-f32c-4d68-9503-f8c8b7d17f42)
</div>

5. Busca el modelo de tu dispositivo y actualiza el firmware en el botón de instalar.

