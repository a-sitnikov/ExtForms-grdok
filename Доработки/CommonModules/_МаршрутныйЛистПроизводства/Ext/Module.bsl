﻿
Процедура ПриСозданииНаСервере_ФормаДокумента(Форма, Отказ, СтандартнаяОбработка) Экспорт
	
	// Нормативы только для просмотра
	Элемент = Форма.Элементы.ВыходныеИзделияКоличествоУпаковок;
	Элемент.ТолькоПросмотр = Истина;
	
	Элемент = Форма.Элементы.ВозвратныеОтходыКоличествоУпаковок;
	Элемент.ТолькоПросмотр = Истина;
	
	Элемент = Форма.Элементы.МатериалыИУслугиКоличествоУпаковок;
	Элемент.ТолькоПросмотр = Истина;

	Элемент = Форма.Элементы.ТрудозатратыКоличество;
	Элемент.ТолькоПросмотр = Истина;
	
	
	Команда = Форма.Команды.Добавить("_ЗаполнитьПоКоличествуЛистов");
	Команда.Заголовок = "Л";
	Команда.ИзменяетСохраняемыеДанные = Истина;
	Команда.Действие  = "_ЗаполнитьПоКоличествуЛистов";
	Команда.Подсказка = "Ввод количества листов";
	
	Кнопка = Форма.Элементы.Вставить("_ЗаполнитьПоКоличествуЛистов", Тип("КнопкаФормы"), Форма.Элементы.ГруппаВыполнено, );
	Кнопка.ИмяКоманды = "_ЗаполнитьПоКоличествуЛистов";
	
КонецПроцедуры

