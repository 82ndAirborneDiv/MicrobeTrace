#!/bin/sh

ls components/ | sed -e 's/^/components\//' | sed "s/.*/        '&',/" >> temp

ls dist/ | sed -e 's/^/dist\//' | sed "s/.*/        '&',/" >> temp
ls scripts/ | sed -e 's/^/scripts\//' | sed "s/.*/        '&',/" >> temp
cat index.html | grep -o "node_modules/.*\.js" | sed "s/.*/        '&',/" >> temp
cat components/*.html | grep -o "node_modules/.*\.js" | sed "s/.*/        '&',/" >> temp
cat scripts/*.js | grep -o "node_modules/.*\.js" | sed "s/.*/        '&',/" >> temp
ls vendor/ | sed -e 's/^/vendor\//' | sed "s/.*/        '&',/" >> temp

cat index.html | grep -o "node_modules/.*\.css" | sed "s/.*/        '&',/" >> temp
cat components/*.html | grep -o "node_modules/.*\.css" | sed "s/.*/        '&',/" >> temp

ls img/ | sed -e 's/^/img\//' | sed "s/.*/        '&',/" >> temp

ls data/ | sed -e 's/^/data\//' | sed "s/.*/        '&',/" >> temp

ls help/*.md | sed "s/.*/        '&',/" >> temp

cat cache.extra | sed "s/.*/        '&',/" >> temp

echo "var CACHE = 'MicrobeTraceD`date +%Y-%m-%d`';

self.addEventListener('install', function(event) {
  event.waitUntil(
    caches.open(CACHE).then(function(cache) {
      return cache.addAll([" > sw.js

awk '!seen[$0]++' temp >> sw.js
rm temp

echo """      ]);
    })
  );
});

self.addEventListener('fetch', function(event) {
  if (event.request.cache === 'only-if-cached' && event.request.mode !== 'same-origin') return;
  event.respondWith(fromCache(event.request));
  event.waitUntil(update(event.request));
});

// Open the cache where the assets were stored and search for the requested
// resource. Notice that in case of no matching, the promise still resolves
// but it does with \`undefined\` as value.
function fromCache(request){
  return caches.open(CACHE).then(function(cache){
    return cache.match(request).then(function(matching){
      return matching || Promise.reject('No match for ' + request.url);
    });
  });
}

// Update consists in opening the cache, performing a network request and
// storing the new response data.
function update(request){
  return caches.open(CACHE).then(function(cache){
    return fetch(request).then(function(response){
      return cache.put(request, response);
    }).catch(function(error){
      //console.error(error + ' ' + request.url);
    });
  });
}

self.addEventListener('activate', function(event) {
  event.waitUntil(
    caches.keys().then(function(keyList) {
      return Promise.all(keyList.map(function(key) {
        if(key !== CACHE) {
          return caches.delete(key);
        }
      }));
    })
  );
});
""" >> sw.js
