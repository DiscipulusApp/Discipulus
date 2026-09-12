// I thought it would be neat if the full screen version would be 'hosted' on `discipulus.harrydekat.dev` 
// instead of `extension://` as it just looks a bit nicer, so here you go, the script that replaces the 
// content of my own website.

(function () {
  // Stop any ongoing page loading or navigation
  try {
    window.stop();
  } catch (e) {}

  function renderDiscipulusApp() {
    try {
      window.stop();
    } catch (e) {}

    document.title = 'Discipulus';

    // Replace the DOM with the full-screen Flutter app iframe
    document.documentElement.innerHTML = `
      <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Discipulus</title>
        <link rel="icon" type="image/png" href="${chrome.runtime.getURL('favicon.png')}">
        <style>
          * { box-sizing: border-box; margin: 0; padding: 0; }
          html, body {
            width: 100vw;
            height: 100vh;
            overflow: hidden;
            background-color: #121212;
          }
          iframe#discipulus-app-frame {
            border: none;
            width: 100%;
            height: 100%;
            display: block;
          }
        </style>
      </head>
      <body>
        <iframe
          id="discipulus-app-frame"
          src="${chrome.runtime.getURL('index.html')}"
          allow="clipboard-read; clipboard-write; camera; microphone; geolocation"
        ></iframe>
      </body>
    `;
  }

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', renderDiscipulusApp);
  } else {
    renderDiscipulusApp();
  }
})();
