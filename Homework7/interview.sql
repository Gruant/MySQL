CREATE SCHEMA `social_network` ;

-- Задача 1.
-- У вас есть социальная сеть, где пользователи (id, имя) могут ставить друг другу лайки. Создайте необходимые таблицы для хранения данной информации.
-- Таблица пользователей
CREATE TABLE `social_network`.`user` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC) VISIBLE,
  INDEX `NAME` (`name` ASC) VISIBLE);
  
  -- Таблица лайков
  CREATE TABLE `social_network`.`like` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `like_from` INT UNSIGNED NOT NULL,
  `like_to` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `like_from_idx` (`like_from` ASC) VISIBLE,
  INDEX `like_to_idx` (`like_to` ASC) VISIBLE,
  CONSTRAINT `like_from`
    FOREIGN KEY (`like_from`)
    REFERENCES `social_network`.`user` (`id`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT,
  CONSTRAINT `like_to`
    FOREIGN KEY (`like_to`)
    REFERENCES `social_network`.`user` (`id`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT);

INSERT INTO `social_network`.`user` (`name`) VALUES ('Антон');
INSERT INTO `social_network`.`user` (`name`) VALUES ('Катя');
INSERT INTO `social_network`.`user` (`name`) VALUES ('Анна');
  
-- Создайте запрос, который выведет: id пользователя; имя; лайков получено; лайков отправлено; взаимные лайки

SELECT 
    u.id,
    u.name,
    (SELECT 
            COUNT(like_from)
        FROM
            social_network.like AS l
        WHERE
            u.id = l.like_from) AS like_sent,
    (SELECT 
            COUNT(like_to)
        FROM
            social_network.like AS l
        WHERE
            u.id = l.like_to) AS like_received,
    (SELECT 
            COUNT(DISTINCT a.id)
        FROM
            social_network.like AS a
                JOIN
            social_network.like AS b ON a.like_from = b.like_to
                AND a.like_to = b.like_from
        WHERE
            a.like_from = u.id) AS mutual_like
FROM
    social_network.user AS u
ORDER BY u.name;

-- Для структуры из задачи 1 выведите список всех пользователей, которые поставили лайк пользователям A и B (id задайте произвольно),
-- но при этом не поставили лайк пользователю C.

SELECT 
    u.id, u.name
FROM
    social_network.user AS u
        JOIN
    social_network.like AS l ON u.id = l.like_from
WHERE (l.like_to IN (3, 5))  AND l.like_to != 4
GROUP BY u.id, u.name, l.like_to
HAVING COUNT(u.id) > 1;


-- Добавим сущности «Фотография» и «Комментарии к фотографии». Нужно создать функционал для пользователей, который позволяет ставить лайки не только пользователям,
-- но и фото или комментариям к фото. Учитывайте следующие ограничения:
-- пользователь не может дважды лайкнуть одну и ту же сущность;
-- пользователь имеет право отозвать лайк;
-- необходимо иметь возможность считать число полученных сущностью лайков и выводить список пользователей, поставивших лайки;
-- в будущем могут появиться новые виды сущностей, которые можно лайкать.


-- создаем таблицу сущностей, которым возможно поставить лайкa
-- entity_type - название таблицы сущности
CREATE TABLE `social_network`.`entity` (
  `id` INT NOT NULL,
  `entity_type` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `entity_type_UNIQUE` (`entity_type` ASC) VISIBLE);
  
-- Таблица сущности "Фотография"
  CREATE TABLE `social_network`.`photo` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `filename` VARCHAR(45) NULL,
  `created_at` DATETIME NULL,
  `update_at` VARCHAR(45) NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC) VISIBLE,
  UNIQUE INDEX `filename_UNIQUE` (`filename` ASC) VISIBLE);
  
-- Таблица комментариев 
CREATE TABLE `social_network`.`comments` (
  `id` INT UNSIGNED NOT NULL,
  `comment` MEDIUMTEXT NOT NULL,
  `created_at` DATETIME NOT NULL,
  `update_at` DATETIME NOT NULL,
  `photo_id` INT UNSIGNED NOT NULL,
  `user_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `photo_idx` (`photo_id` ASC) VISIBLE,
  INDEX `user_idx` (`user_id` ASC) VISIBLE,
  UNIQUE INDEX `id_UNIQUE` (`id` ASC) VISIBLE,
  CONSTRAINT `photo`
    FOREIGN KEY (`photo_id`)
    REFERENCES `social_network`.`photo` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `user`
    FOREIGN KEY (`user_id`)
    REFERENCES `social_network`.`user` (`id`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT);
    
-- Изменения в таблице like
CREATE TABLE `social_network`.`like` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` INT UNSIGNED NOT NULL,
  `entity_type` VARCHAR(45) NULL,
  `entity_id` INT NULL,
  `is_like` TINYINT(2) NULL,
  `created_at` DATETIME NOT NULL,
  `update_at` DATETIME NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC) VISIBLE,
  INDEX `entity_type_idx` (`entity_type` ASC) VISIBLE,
  INDEX `user_id_idx` (`user_id` ASC) VISIBLE,
  CONSTRAINT `entity_type`
    FOREIGN KEY (`entity_type`)
    REFERENCES `social_network`.`entity` (`entity_type`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `user_id`
    FOREIGN KEY (`user_id`)
    REFERENCES `social_network`.`user` (`id`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT);
    
-- Уникальный индекс на user_id, entity_type, entity_id
ALTER TABLE `social_network`.`like` 
ADD UNIQUE INDEX `unique` (`user_id` ASC, `entity_type` ASC, `entity_id` ASC) VISIBLE;
;

-- таблица позволяет найти поставленный лайк конкретной сущности по имени таблицы этой сущности, увеличение сущностей возможно до бесконечности
-- подсчет и вывод сначала делается по entity_type и entity_id, а потом подтягивается сама сущность для вывода (кажется удобным)
-- is_like в like: 1- лайк поставлен, 2-отозван
-- уникальность по 3-м полям не даст поставить лайк больше чем 1-й сущности



  





 
