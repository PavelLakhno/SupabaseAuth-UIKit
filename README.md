## 📌 Особенности
- Полноценная аутентификация (Email/Password + Magic Links)
- Поддержка Xcode 14.0.1 и Swift 5.7
- Supabase version 0.3.0
- Чистый код без Storyboards
- Готовые экраны: Auth и Success
- Пример обработки Deep Links

## ⚙️ Настройки Supabase
(Туториал для быстрого старта на SwiftUI: https://supabase.com/docs/guides/getting-started/tutorials/with-swift)

Для работы необходимо настроить в [Supabase Dashboard](https://app.supabase.com):
1. **Authentication → Providers**:
   - Email/Password: Enabled
   - Enable "Confirm email"
2. **URL Configuration**:
   - Site URL: `youApp` 
   - Redirect URLs: `youApp://login-callback`
3. **Project URL and Api Key for x-code App**:
   Project Settings -> API Settings
   - Project URL
   - Project API Key
     
В x-code проекте настроить:
   - Project → Targets → Info → URL types → URL Schemes → `youApp` 

## 📸 Скриншоты
<p align="center">
  <img src="https://github.com/user-attachments/assets/66f75b86-3f7d-4098-848b-917b1a1f643a" width="250" alt="Экран авторизации">
   <img src="https://github.com/user-attachments/assets/450f38cf-f299-41d7-8ed9-38465891985e" width="250" alt="Экран авторизации с OTP">
  <img src="https://github.com/user-attachments/assets/ba73f115-0b38-4bf8-a581-878fd913d0e7" width="250" alt="Экран успешного входа">
</p>

