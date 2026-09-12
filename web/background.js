chrome.runtime.onInstalled.addListener(() => {
  chrome.contextMenus.create({
    id: 'open_tab',
    title: 'Open in nieuw tabblad',
    contexts: ['action']
  });

  chrome.contextMenus.create({
    id: 'open_sidebar',
    title: 'Open in zijpaneel',
    contexts: ['action']
  });

  chrome.contextMenus.create({
    id: 'reset_default',
    title: 'Keuzemenu weergeven',
    contexts: ['action']
  });
});

chrome.contextMenus.onClicked.addListener(async (info, tab) => {
  if (info.menuItemId === 'open_tab') {
    chrome.tabs.create({ url: 'https://discipulus.harrydekat.dev' });
  } else if (info.menuItemId === 'open_sidebar') {
    if (tab && tab.windowId && chrome.sidePanel && chrome.sidePanel.open) {
      chrome.sidePanel.open({ windowId: tab.windowId });
    }
  } else if (info.menuItemId === 'reset_default') {
    await chrome.storage.local.remove(['defaultViewMode']);
    if (chrome.sidePanel && chrome.sidePanel.setPanelBehavior) {
      chrome.sidePanel.setPanelBehavior({ openPanelOnActionClick: false });
    }
    chrome.action.setPopup({ popup: 'popup.html' });
  }
});
