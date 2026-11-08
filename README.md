# Dulce cuenta

Aplicación web progresiva (PWA) para llevar pedidos, abonos, gastos y el resumen diario de un negocio de postres. Funciona en celular y computadora. Guarda los datos en el dispositivo mientras no haya Firebase conectado; con Firestore conectado, los cambios se actualizan en vivo entre dispositivos.

## Publicar en GitHub Pages

1. Crea un repositorio en GitHub y sube estos archivos a la raíz.
2. Abre **Settings → Pages** en el repositorio.
3. En **Build and deployment**, elige **Deploy from a branch**, selecciona `main` y la carpeta `/ (root)`, y guarda.
4. Cuando GitHub Pages termine de publicar, abre el enlace `https://TU-USUARIO.github.io/TU-REPOSITORIO/` desde el celular.
5. En iPhone, usa **Compartir → Añadir a pantalla de inicio**. En Android, usa **Instalar app** o la opción de instalación del navegador.

La app debe servirse por HTTPS para que la instalación y el funcionamiento sin conexión estén disponibles. GitHub Pages lo proporciona.

## Firebase

La configuración web que compartiste ya quedó integrada. La app intentará conectarse al proyecto `nuestros-negocios` automáticamente y usa Firestore para las colecciones `orders`, `expenses` y `settings`; no usa Analytics porque no es necesario para guardar ni sincronizar ventas.

Si Firestore todavía no está creado o sus reglas bloquean el acceso, la app mostrará el estado de conexión y seguirá guardando en el dispositivo. En Firebase Console, habilita Firestore y configura Firebase Authentication con cuentas para las personas del negocio; luego limita las reglas de Firestore a esas cuentas antes de guardar información real de clientes. No publiques reglas que permitan lectura y escritura a cualquier visitante. La API key incluida identifica el proyecto, pero no protege los datos.

## Qué incluye

- Precio base editable (inicia en COP $8.000) y precio específico por pedido.
- Pedidos con cantidades, fecha, nota y cliente.
- Pagos divididos entre efectivo y transferencia, con cuenta o responsable asociado a cada pago.
- Saldos pendientes y estados de pagado, abono o pendiente, calculados automáticamente.
- Gastos por categoría, medio de pago y cuenta.
- Resumen acumulado de ventas, unidades, cuentas pendientes, gastos, ganancia neta y recaudo por medio para todas las tandas.
- Búsqueda, filtros de fecha y estado, edición y eliminación.
- PWA instalable y shell disponible sin conexión.

## Datos y sincronización

Sin Firebase, los registros se guardan en el almacenamiento local del navegador y no se comparten con otros dispositivos. Al conectar Firebase, la app escucha cambios de Firestore en tiempo real. Los registros ya guardados localmente no se suben automáticamente al conectar, para evitar duplicados; pueden volver a registrarse o migrarse cuando se configure el proyecto.
