# roblox-arena

Навчальний проєкт: раундова арена-гра в Roblox (лобі → раунд → нагороди → магазин → збереження прогресу).
Мета: самоосвіта в розробці ігор на Roblox (Luau, ООП, найкращі практики).

## Про розробника

- Bohdan, Python backend-розробник (~2 роки: FastAPI, Django, async, ООП/SOLID, PostgreSQL, Redis, Docker, AWS/GCP).
- У Luau початківець. Пояснюй концепції Roblox через аналогії з Python і бекендом.
- **Код пише сам.** Давай завдання, підказки й рев'ю, а не готові рішення, якщо про них не просять.
- Відповідай українською.

## Середовище

- macOS, VS Code + Luau Language Server, Rokit (`rokit.toml`), Rojo 7.x (`default.project.json`).
- Синхронізація: `rojo serve` → Studio → Plugins → Rojo → Connect. Код запускається лише в Studio (Play), не у VS Code.
- Скрипти, синхронізовані Rojo, не редагуються в Studio. Карта, моделі й UI робляться в Studio.
- Git: працюємо в `develop`, стабільні версії мерджимо в `main`. Remote: github.com/kravetb/roblox-arena.

## Структура

| Папка | У грі | Призначення |
| --- | --- | --- |
| `src/shared` | `ReplicatedStorage.Shared` | модулі, спільні для сервера й клієнта |
| `src/server` | `ServerScriptService.Server` | серверна логіка |
| `src/client` | `StarterPlayer.StarterPlayerScripts.Client` | клієнтська логіка |

## Стиль коду

- `--!strict` першим рядком кожного файлу; типи для параметрів і `export type` для публічних типів.
- `game:GetService(...)` і `require` на початку файлу; кожен модуль підключається через `require` один раз.
- Таблицю модуля називати так само, як файл (`local ShopUtil = {}` ... `return ShopUtil`).
- ООП через метатаблиці: `Class.__index = Class`, `Class.new(...)`, методи через `:`.
- Лише `task.wait/spawn/delay/defer`, без застарілих `wait()`, `spawn()`.
- Мережеві виклики (DataStore, Marketplace) загортати в `pcall`.
- Сервер ніколи не довіряє клієнту: усі дані з RemoteEvent валідуються на сервері.

## План

1. [~] Luau і середовище: налаштування ✅, розминка ✅, далі класи Item/Weapon на метатаблицях
2. [ ] Архітектура клієнт-сервер: RemoteEvents як API, Services/Controllers, цикл раундів
3. [ ] Дані та економіка: DataStoreService (сесії, retry), leaderstats, валюта, магазин
4. [ ] UI, TweenService, звуки, тести (TestEZ), оптимізація, публікація

## Поточне завдання

Завдання 1, класи на метатаблицях:
- `src/shared/Items/Item.luau`: поля `name`, `price`; `Item.new(name, price)`, `item:describe(): string`.
- `src/shared/Items/Weapon.luau` наслідує Item: `damage`, `cooldown`, `weapon:canAttack(now: number): boolean`, перевизначений `describe()`.
- Перевірка з `src/server/init.server.luau`.

## Матеріали

- Шпаргалка Luau для Python-розробника: https://claude.ai/artifact/VAgnzEzKA57WcMfCooYR1w
