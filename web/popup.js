document.addEventListener('DOMContentLoaded', async () => {
  const rememberCheckbox = document.getElementById('rememberChoice');

  const storage = await chrome.storage.local.get(['defaultViewMode']);
  if (storage.defaultViewMode === 'tab') {
    chrome.tabs.create({ url: 'https://discipulus.harrydekat.dev' });
    window.close();
    return;
  } else if (storage.defaultViewMode === 'sidebar') {
    const win = await chrome.windows.getCurrent();
    if (win && win.id && chrome.sidePanel && chrome.sidePanel.open) {
      chrome.sidePanel.open({ windowId: win.id });
      window.close();
      return;
    }
  } else if (storage.defaultViewMode === 'popup') {
    loadInPopup();
    return;
  }

  function loadInPopup() {
    document.body.style.width = '420px';
    document.body.style.height = '600px';
    document.body.style.padding = '0';
    document.body.style.margin = '0';
    document.documentElement.style.width = '420px';
    document.documentElement.style.height = '600px';
    window.location.href = 'index.html';
  }

  document.getElementById('btnTab').addEventListener('click', async () => {
    if (rememberCheckbox && rememberCheckbox.checked) {
      await chrome.storage.local.set({ defaultViewMode: 'tab' });
    }
    chrome.tabs.create({ url: 'https://discipulus.harrydekat.dev' });
    window.close();
  });

  document.getElementById('btnSidebar').addEventListener('click', async () => {
    if (rememberCheckbox && rememberCheckbox.checked) {
      await chrome.storage.local.set({ defaultViewMode: 'sidebar' });
      if (chrome.sidePanel && chrome.sidePanel.setPanelBehavior) {
        chrome.sidePanel.setPanelBehavior({ openPanelOnActionClick: true });
      }
    }
    const win = await chrome.windows.getCurrent();
    if (win && win.id && chrome.sidePanel && chrome.sidePanel.open) {
      chrome.sidePanel.open({ windowId: win.id });
    }
    window.close();
  });

  document.getElementById('btnPopup').addEventListener('click', async () => {
    if (rememberCheckbox && rememberCheckbox.checked) {
      await chrome.storage.local.set({ defaultViewMode: 'popup' });
    }
    loadInPopup();
  });
});
