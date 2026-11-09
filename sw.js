const CACHE='dulces-momentos-shell-v8';
const SHELL=['./','./index.html','./styles.css?v=8','./app.js?v=8','./manifest.webmanifest?v=8','./icon.svg','./icon-192.png','./icon-512.png','./apple-touch-icon.png','./favicon-32.png'];
self.addEventListener('install',e=>e.waitUntil(caches.open(CACHE).then(c=>c.addAll(SHELL)).then(()=>self.skipWaiting())));
self.addEventListener('activate',e=>e.waitUntil(caches.keys().then(keys=>Promise.all(keys.filter(k=>k!==CACHE).map(k=>caches.delete(k)))).then(()=>self.clients.claim())));
self.addEventListener('fetch',e=>{if(e.request.method!=='GET')return;e.respondWith(caches.match(e.request).then(cached=>cached||fetch(e.request).then(response=>{const copy=response.clone();if(new URL(e.request.url).origin===location.origin)caches.open(CACHE).then(c=>c.put(e.request,copy));return response}).catch(()=>caches.match('./index.html'))))});
