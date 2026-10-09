/* Grupo Virax — Service Worker (push em background) */
const SW_VERSION = 'vx-sw-2';

self.addEventListener('install', (e) => { self.skipWaiting(); });
self.addEventListener('activate', (e) => { e.waitUntil(self.clients.claim()); });

/* Recebe o push enviado pelo servidor (Supabase Edge Function) e mostra a notificação,
   mesmo com o site fechado. */
self.addEventListener('push', (event) => {
  let d = {};
  try { d = event.data ? event.data.json() : {}; } catch (e) {
    try { d = { body: event.data.text() }; } catch (_) { d = {}; }
  }
  const title = d.title || 'Cobrança · Grupo Virax';
  const options = {
    body: d.body || 'Você tem cobranças para realizar hoje.',
    icon: d.icon || 'icon-192.png',
    badge: 'notif-icon.png',
    tag: d.tag || 'vx-cobranca',
    renotify: true,
    requireInteraction: !!d.requireInteraction,
    data: { url: d.url || './' },
    vibrate: [120, 60, 120]
  };
  event.waitUntil(self.registration.showNotification(title, options));
});

/* Ao clicar na notificação, abre/foca o painel na aba de cobranças. */
self.addEventListener('notificationclick', (event) => {
  event.notification.close();
  const target = (event.notification.data && event.notification.data.url) || './';
  event.waitUntil((async () => {
    const all = await self.clients.matchAll({ type: 'window', includeUncontrolled: true });
    for (const c of all) {
      if ('focus' in c) { try { c.navigate && c.navigate(target); } catch (e) {} return c.focus(); }
    }
    if (self.clients.openWindow) return self.clients.openWindow(target);
  })());
});
