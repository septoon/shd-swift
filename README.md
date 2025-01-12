# 🍢 Шашлычный дом - Мобильное приложение

## 📖 Описание проекта

**"Шашлычный дом"** — это мобильное приложение, созданное для упрощения заказов в ресторане. Приложение позволяет клиентам просматривать меню, добавлять блюда в корзину, оформлять заказы и вводить данные для доставки. Проект разработан с использованием **SwiftUI** и включает в себя современные решения для оптимизации работы и улучшения пользовательского опыта.

⚠️ Публикация в App Store временно приостановлена из-за санкционных ограничений. Решение этой проблемы находится в процессе.

---

## ✨ Основные функции

- 📋 **Меню ресторана**: Полный список блюд с фотографиями и описанием.
- 🛒 **Управление корзиной**: Добавление, удаление товаров и расчет общей стоимости.
- 📞 **Поддержка пользователей**: Поле ввода телефонного номера с валидацией.
- 📍 **Контакты и доставка**: Удобная форма для ввода данных о доставке.
- 🔧 **Мультимедиа**: Плавные анимации (Lottie) и загрузка изображений из сети (Kingfisher).

---

## 🗂 Структура проекта

```plaintext
shd/
│
├── common/                 # Общие утилиты и сервисы
│   ├── KeyboardHandler     # Управление клавиатурой
│   ├── TelegramService     # Интеграция с Telegram
│
├── Data/                   # Источники данных
│   ├── CartData            # Модель корзины
│   ├── ContactsData        # Контактные данные
│   ├── DeliveryData        # Данные о доставке
│   ├── MenuData            # Данные меню
│
├── Tab/                    # Основная вкладочная навигация
│   └── MainTabView         # Главный контейнер вкладок
│
├── Views/                  # UI-элементы приложения
│   ├── Cart/               # Экран корзины
│   │   ├── Order/          # Оформление заказа
│   │   │   ├── DatePickerView    # Выбор даты
│   │   │   ├── OrderTypeSwitcher # Переключение типов заказа
│   │   │   ├── OrderView         # Главный экран заказа
│   │   │   ├── OrderViewModel    # Логика заказа
│   │   │   ├── PolicyView        # Политики и условия
│   │   │
│   │   ├── CartItemRow     # Отображение строки товара
│   │   ├── CartView        # Общий экран корзины
│   │
│   ├── Menu/               # Экран меню
│   │   ├── MenuItemButton  # Кнопка для элемента меню
│   │   ├── MenuItemView    # Отображение элемента меню
│   │   ├── MenuView        # Общий экран меню
│   │
│   ├── ContactsView        # Экран контактов
│   ├── DeliveryView        # Экран доставки
│   ├── WebView             # Встроенный веб-браузер
│
├── Assets/                 # Ресурсы приложения
│   ├── Colors              # Цветовая палитра
│   ├── Info                # Информация о приложении
│   ├── LaunchScreenView    # Экран запуска
│   ├── LottieView          # Анимации
│   ├── PreLoader           # Экран загрузки
│   ├── SplashView          # Заставка
│
├── shdApp.swift            # Главная точка входа в приложение
```

---

## 📦 Зависимости

В проекте используются следующие библиотеки:

- **[Lottie](https://github.com/airbnb/lottie-ios) (v4.5.0)**: Для создания анимаций.
- **[Kingfisher](https://github.com/onevcat/Kingfisher) (v8.1.3)**: Для загрузки и кэширования изображений.
- **[iPhoneNumberField](https://github.com/Bonjoursoft/iPhoneNumberField) (v0.10.4)**: Для удобного ввода и форматирования телефонных номеров.

---

## ⚙️ Установка и запуск

### 1️⃣ Клонирование репозитория

```bash
git clone https://github.com/septoon/shd-swift.git
cd shd-swift
```

### 2️⃣ Установка зависимостей

1. Убедитесь, что на вашем устройстве установлен Xcode (14.0 или выше).
2. Зависимости интегрированы через Swift Package Manager и загружаются автоматически при открытии проекта.

### 3️⃣ Запуск проекта

1. Откройте файл `shd.xcodeproj` в Xcode.
2. Выберите устройство или симулятор.
3. Нажмите `⌘ + R` для запуска.

---

## 🔧 Основные шаги настройки

1. **Конфигурация API**:
   - В файле `Config.swift` добавьте базовый URL API:
     ```swift
     struct Config {
         static let apiBaseURL = "https://api.example.com"
     }
     ```

2. **Настройка анимаций**:
   - Lottie-анимации находятся в каталоге `Assets/`.

3. **Работа с изображениями**:
   - Используйте `Kingfisher` для загрузки изображений из сети.

---

## 🔏 Лицензия

Проект является частной разработкой для ресторана "Шашлычный дом".

---