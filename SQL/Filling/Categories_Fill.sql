DELETE FROM Categories;
DELETE FROM Subcategories;

INSERT INTO Categories VALUES
  ('Товары для учебы'),
  ('Транспорт'),
  ('Услуги'),
  ('Одежда'),
  ('Еда'),
  ('Товары для дома'),
  ('Электроника'),
  ('Хобби');

SELECT add_to_Category_Subcategory('Товары для учебы', 'Канцтовары');
SELECT add_to_Category_Subcategory('Товары для учебы', 'Электроника');
SELECT add_to_Category_Subcategory('Товары для учебы', 'Одежда');
SELECT add_to_Category_Subcategory('Товары для учебы', 'Остальное');

SELECT add_to_Category_Subcategory('Транспорт', 'Машины');
SELECT add_to_Category_Subcategory('Транспорт', 'Мотоциклы');
SELECT add_to_Category_Subcategory('Транспорт', 'Велосипеды');
SELECT add_to_Category_Subcategory('Транспорт', 'Скейтборды');
SELECT add_to_Category_Subcategory('Транспорт', 'Електрический транспорт');
SELECT add_to_Category_Subcategory('Транспорт', 'Запчасти');
SELECT add_to_Category_Subcategory('Транспорт', 'Инструменты');
SELECT add_to_Category_Subcategory('Транспорт', 'Остальное');

SELECT add_to_Category_Subcategory('Одежда', 'Футболки');
SELECT add_to_Category_Subcategory('Одежда', 'Джинсы');
SELECT add_to_Category_Subcategory('Одежда', 'Брюки');
SELECT add_to_Category_Subcategory('Одежда', 'Обувь');
SELECT add_to_Category_Subcategory('Одежда', 'Кроссовки');
SELECT add_to_Category_Subcategory('Одежда', 'Головные уборы');
SELECT add_to_Category_Subcategory('Одежда', 'Носки');
SELECT add_to_Category_Subcategory('Одежда', 'Спортивная одежда');
SELECT add_to_Category_Subcategory('Одежда', 'Аксессуары');
SELECT add_to_Category_Subcategory('Одежда', 'Остальное');

SELECT add_to_Category_Subcategory('Услуги', 'Уборка');
SELECT add_to_Category_Subcategory('Услуги', 'Починка');
SELECT add_to_Category_Subcategory('Услуги', 'Готовка');
SELECT add_to_Category_Subcategory('Услуги', 'Решения');
SELECT add_to_Category_Subcategory('Услуги', 'Остальное');

SELECT add_to_Category_Subcategory('Еда', 'Фрукты');
SELECT add_to_Category_Subcategory('Еда', 'Овощи');
SELECT add_to_Category_Subcategory('Еда', 'Мясо');
SELECT add_to_Category_Subcategory('Еда', 'Рыба');
SELECT add_to_Category_Subcategory('Еда', 'Макароны');
SELECT add_to_Category_Subcategory('Еда', 'Готовая еда');
SELECT add_to_Category_Subcategory('Еда', 'Снеки');
SELECT add_to_Category_Subcategory('Еда', 'Просрочка');
SELECT add_to_Category_Subcategory('Еда', 'Остальное');

SELECT add_to_Category_Subcategory('Товары для дома', 'Электроника');
SELECT add_to_Category_Subcategory('Товары для дома', 'Мебель');
SELECT add_to_Category_Subcategory('Товары для дома', 'Инструменты');
SELECT add_to_Category_Subcategory('Товары для дома', 'Остальное');

SELECT add_to_Category_Subcategory('Электроника', 'Телефоны');
SELECT add_to_Category_Subcategory('Электроника', 'Планшеты');
SELECT add_to_Category_Subcategory('Электроника', 'Товары для гаджетов');
SELECT add_to_Category_Subcategory('Электроника', 'Настольные компьютеры');
SELECT add_to_Category_Subcategory('Электроника', 'Ноутбуки');
SELECT add_to_Category_Subcategory('Электроника', 'Товары для компьютеров');
SELECT add_to_Category_Subcategory('Электроника', 'Аудио/Видео');
SELECT add_to_Category_Subcategory('Электроника', 'Остальное');

SELECT add_to_Category_Subcategory('Хобби', 'Радиодетали');
SELECT add_to_Category_Subcategory('Хобби', 'Рыбалка');
SELECT add_to_Category_Subcategory('Хобби', 'Книги');
SELECT add_to_Category_Subcategory('Хобби', 'Спорт');
SELECT add_to_Category_Subcategory('Хобби', 'Музыка');
SELECT add_to_Category_Subcategory('Хобби', 'Остальное');


SELECT *
FROM Subcategories S1 JOIN Subcategory_Category S2 ON S1.ID = S2.Subcategory_ID;