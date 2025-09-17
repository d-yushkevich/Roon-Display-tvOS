# Roon Display

![Alt text](/Distr/screen01.png?raw=true "Roon Display")
![Alt text](/Distr/screen02.png?raw=true "Roon Display")

A simple Roon Display App for Apple TV. This app is **not affiliated** with Roon Labs.  
It is a web display, not a Roon Player endpoint. For more info, see: https://kb.roonlabs.com/Displays#Web_Display  

---

## Quick Setup / Быстрая установка

### English

1. **Install Xcode** on your Mac (version 11.4.1 or newer). Free Apple Developer account is enough (app works 7 days with free account).  
2. **Clone or copy the project** and open **RoonDisplay** in Xcode.  
3. Open Roon Client, go to **Settings > Displays**, and copy the Web Display URL.  
4. In Xcode, open **ViewController.m** and replace the URL (around line 19) with your Roon Display URL.  
5. Update **Bundle Identifier** and Team for code signing.  
6. **Connect your Apple TV** via USB or Wi-Fi. Select your device in Xcode and press **Play** to build and deploy.  
7. After a successful build, the app appears on Apple TV. Rebuild only if project changes or your developer account expires.  
8. Play music in Roon and select the display via the volume icon.

**Tips:**  
- Press **Play/Pause** on the Apple remote to open a menu (set URL, reload page, clear cache/cookies).  
- Screen may turn black when returning to the app — normal, it reconnects to Roon.  
- If streaming Roon to Apple TV at the same time, Apple TV may switch to its **“Now Playing”** screen after a few minutes — cannot override.

---

### Русский

1. **Установите Xcode** на Mac (версия 11.4.1 или новее). Достаточно бесплатной учетной записи разработчика (приложение работает 7 дней при бесплатной подписке).  
2. **Скопируйте или клонируйте проект** и откройте **RoonDisplay** в Xcode.  
3. В Roon Client зайдите в **Settings > Displays** и скопируйте URL веб-дисплея.  
4. В Xcode откройте **ViewController.m** и вставьте этот URL (примерно строка 19).  
5. Обновите **Bundle Identifier** и Team для подписи приложения.  
6. **Подключите Apple TV** к Mac через USB или Wi-Fi. Выберите устройство в Xcode и нажмите **Play** для сборки и установки.  
7. После успешной сборки приложение появится на Apple TV. Пересборка нужна только при изменении проекта или истечении срока действия учетной записи.  
8. Воспроизведите музыку в Roon и выберите дисплей через иконку громкости.

**Советы:**  
- Нажмите **Play/Pause** на пульте, чтобы открыть меню (установить URL, перезагрузить страницу, очистить кэш/cookies).  
- Экран может становиться черным при возврате в приложение — это нормально, идет переподключение к Roon.  
- Если одновременно идет поток Roon на Apple TV, через несколько минут экран может переключиться на **“Now Playing”** tvOS — изменить это нельзя.

---

## Additional Info / Дополнительно

- The app is heavily stripped down and modified from:
  - https://github.com/jvanakker/tvOSBrowser  
  - https://github.com/Moballo-LLC/tvOS-Browser  
- Software provided “as-is” with no warranty. Use at your own risk.  

