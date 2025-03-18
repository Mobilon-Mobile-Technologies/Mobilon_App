'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter_bootstrap.js": "7a12b8220e407d0e31b1cafd2b9f655b",
"version.json": "4671ef606ada9f6e6891d82ef990201c",
"index.html": "630489a6ed93493e0ceac4a1ced7dd38",
"/": "630489a6ed93493e0ceac4a1ced7dd38",
"main.dart.js": "652c85bcd4e223b02c1c89e077db5c84",
"flutter.js": "76f08d47ff9f5715220992f993002504",
"favicon.png": "a734d5dd498f38dbf753f6b142a98abb",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"manifest.json": "f7ba6ea0cd36e5c73fd9cab77e93dda6",
"assets/AssetManifest.json": "d693a2fcb1df9dfa4ede79d68246dff9",
"assets/NOTICES": "f3a0e166f78cc313d6e3ef55873d1ba9",
"assets/FontManifest.json": "61390607f92984da2ba6332216ba3727",
"assets/AssetManifest.bin.json": "8265783204be8fdb12b3ea1bfea3ac26",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "6284b833aee65a8f601935955df9f72d",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin": "a9a15ab8f12ce7466cf5074f2e37b49a",
"assets/fonts/MaterialIcons-Regular.otf": "99d94d2df03ea590924d01ad9460ff09",
"assets/assets/FlutterImg.png": "e3912a9760246026d6c684d1e1cf0bff",
"assets/assets/mobile_next.jpeg": "a017f632bd875cc422f2bd8d29e0b8a4",
"assets/assets/images/img1.png": "6ba5e7d77cfe1515587872e6e99b8616",
"assets/assets/Background.png": "ea7c762b5b72db9037de6a148c73b776",
"assets/assets/Icons/UserOff.svg": "f604c3a4fc41cefa771e4c755eafffe3",
"assets/assets/Icons/LibraryOn.svg": "4f263c7df1b1e626052291a3d8843b1c",
"assets/assets/Icons/HomeOn.svg": "651b6d10315a5fcb48d9815424b528df",
"assets/assets/Icons/UserOn.svg": "df28f8fe65fd752a1185112b1e658892",
"assets/assets/Icons/LibraryOff.svg": "1349629f92ff21059f60431702529b4e",
"assets/assets/Icons/HomeOff.svg": "89cab9d81ed86ba939b13cd8f2009bdc",
"assets/assets/qr.png": "a7897770f690ff8ad8cd8e90aafa1f52",
"assets/assets/fonts/Aldrich-Regular.ttf": "d95d3c0366bed65728b9968195c0ea11",
"assets/assets/fonts/Inter-Regular.ttf": "0a77e23a8fdbe6caefd53cb04c26fabc",
"canvaskit/skwasm_st.js": "d1326ceef381ad382ab492ba5d96f04d",
"canvaskit/skwasm.js": "f2ad9363618c5f62e813740099a80e63",
"canvaskit/skwasm.js.symbols": "58dcc01e30099382fa92dce2380cd7cf",
"canvaskit/canvaskit.js.symbols": "737048e1d3ad50f18036f932917e50e0",
"canvaskit/skwasm.wasm": "fd2098ced28c6cdf814a261b666680c5",
"canvaskit/chromium/canvaskit.js.symbols": "8a65c5ebe7c9c953d1feb5a1388fa860",
"canvaskit/chromium/canvaskit.js": "73343b0c5d471d1114d7f02e06c1fdb2",
"canvaskit/chromium/canvaskit.wasm": "d6463da2fd70207a2bfece2f04715f19",
"canvaskit/skwasm_st.js.symbols": "da210335b5bbbc02ead100da96ab34be",
"canvaskit/canvaskit.js": "de27f912e40a372c22a069c1c7244d9b",
"canvaskit/canvaskit.wasm": "78b9309f3bf6ccd94c7569945c9c344d",
"canvaskit/skwasm_st.wasm": "14be5e6268cd4e3e80caa07e8ceed900"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
