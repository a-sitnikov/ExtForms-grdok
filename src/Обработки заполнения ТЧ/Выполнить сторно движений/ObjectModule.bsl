﻿////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

#Область ПрограммныйИнтерфейс

// Возвращает сведения о внешней обработке.
Функция СведенияОВнешнейОбработке() Экспорт
	
	ПараметрыРегистрации = ДополнительныеОтчетыИОбработки.СведенияОВнешнейОбработке("2.2.2.1");
	
	ПараметрыРегистрации.Вид = ДополнительныеОтчетыИОбработкиКлиентСервер.ВидОбработкиЗаполнениеОбъекта();
	ПараметрыРегистрации.Версия = "1.0";
	ПараметрыРегистрации.Назначение.Добавить("Документ.КорректировкаРегистров");
	ПараметрыРегистрации.Вставить("БезопасныйРежим", ЛОЖЬ);

	ТаблицаКоманд = ПолучитьТаблицуКоманд();
	ДобавитьКоманду(ТаблицаКоманд, ЭтотОбъект.Метаданные().Представление(), "Сторно", "ОткрытиеФормы");
	ПараметрыРегистрации.Вставить("Команды", ТаблицаКоманд);

	//НоваяКоманда = ПараметрыРегистрации.Команды.Добавить();
	//НоваяКоманда.Представление = НСтр("ru = 'Заполнить сторно документа'");
	//НоваяКоманда.Идентификатор = "ЗаполнитьСторно";
	//НоваяКоманда.Использование = ДополнительныеОтчетыИОбработкиКлиентСервер.ТипКомандыВызовСерверногоМетода();
	//НоваяКоманда.ПоказыватьОповещение = Истина;
	
	//НоваяКоманда = ПараметрыРегистрации.Команды.Добавить();
	//НоваяКоманда.Представление = НСтр("ru = 'Добавить префикс к реквизиту ""Наименование"" (открытие формы)...'");
	//НоваяКоманда.Идентификатор = "ДобавитьПрефиксКНаименованию";
	//НоваяКоманда.Использование = ДополнительныеОтчетыИОбработкиКлиентСервер.ТипКомандыОткрытиеФормы();
	//НоваяКоманда.ПоказыватьОповещение = Ложь;
	//
	//НоваяКоманда = ПараметрыРегистрации.Команды.Добавить();
	//НоваяКоманда.Представление = НСтр("ru = 'Комплексная очистка (вызов серверного метода)'");
	//НоваяКоманда.Идентификатор = "ОчиститьВсе";
	//НоваяКоманда.Использование = ДополнительныеОтчетыИОбработкиКлиентСервер.ТипКомандыВызовСерверногоМетода();
	//НоваяКоманда.ПоказыватьОповещение = Ложь;
	//
	//НоваяКоманда = ПараметрыРегистрации.Команды.Добавить();
	//НоваяКоманда.Представление = НСтр("ru = 'Комплексное заполнение (вызов клиентского метода)'");
	//НоваяКоманда.Идентификатор = "ЗаполнитьВсе";
	//НоваяКоманда.Использование = ДополнительныеОтчетыИОбработкиКлиентСервер.ТипКомандыВызовКлиентскогоМетода();
	//НоваяКоманда.ПоказыватьОповещение = Истина;
	//
	//НоваяКоманда = ПараметрыРегистрации.Команды.Добавить();
	//НоваяКоманда.Представление = НСтр("ru = 'Заполнить реквизит ""ИНН"" не записывая объект (заполнение формы)'");
	//НоваяКоманда.Идентификатор = "ЗаполнитьИНН";
	//НоваяКоманда.Использование = ДополнительныеОтчетыИОбработкиКлиентСервер.ТипКомандыЗаполнениеФормы();
	//НоваяКоманда.ПоказыватьОповещение = Ложь;
	//НоваяКоманда.Скрыть = Истина;
	
	Возврат ПараметрыРегистрации;
	
КонецФункции

// Интерфейс для выполнения команд обработки.
Процедура ВыполнитьКоманду(ИмяКоманды, ОбъектыНазначения, ПараметрыВыполнения) Экспорт
	
	ПараметрыРегистрации = СведенияОВнешнейОбработке();
	ПараметрыРегистрации.Команды.Колонки.Идентификатор.Имя = "ИмяКоманды";
	ЭтаКоманда = ПараметрыРегистрации.Команды.Найти(ИмяКоманды, "ИмяКоманды");
	Если ЭтаКоманда = Неопределено Тогда
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Команда ""%1"" не поддерживается обработкой ""%2""'"),
			ИмяКоманды,
			Метаданные().Представление()
		);
	КонецЕсли;
	
	Если ИмяКоманды = "ЗаполнитьИНН" Тогда
		ЗаполнитьИНН(ПараметрыВыполнения.ЭтаФорма, ПараметрыВыполнения.РезультатВыполнения);
	Иначе
		ЗаполнитьПоСсылкам(ОбъектыНазначения, ПараметрыВыполнения.РезультатВыполнения, ЭтаКоманда,ПараметрыВыполнения.ЭтаФорма);
	КонецЕсли;
	
	// Имитация длительной операции для клиент-серверного режима.
	Если НЕ ОбщегоНазначения.ИнформационнаяБазаФайловая() Тогда
		ДатаОкончания = ТекущаяДата() + 4;
		Пока ДатаОкончания > ТекущаяДата() Цикл
			
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры


Процедура ДобавитьКоманду(ТаблицаКоманд, Представление, Идентификатор, Использование, ПоказыватьОповещение = Ложь, Модификатор = "")
	НоваяКоманда = ТаблицаКоманд.Добавить();
	НоваяКоманда.Представление = Представление;
	НоваяКоманда.Идентификатор = Идентификатор;
	НоваяКоманда.Использование = Использование;
	НоваяКоманда.ПоказыватьОповещение = ПоказыватьОповещение;
	НоваяКоманда.Модификатор = Модификатор;
КонецПроцедуры


Функция ПолучитьТаблицуКоманд()
	Команды = Новый ТаблицаЗначений;
	Команды.Колонки.Добавить("Представление", Новый ОписаниеТипов("Строка"));  // Представление, которое увидит пользователь в документе или справочнике
	Команды.Колонки.Добавить("Идентификатор", Новый ОписаниеТипов("Строка"));
	Команды.Колонки.Добавить("Использование", Новый ОписаниеТипов("Строка"));  // Варианты: ВызовСерверногоМетода, СценарийВБезопасномРежиме, ВызовКлиентскогоМетода, ОткрытиеФормы
	Команды.Колонки.Добавить("ПоказыватьОповещение", Новый ОписаниеТипов("Булево"));
	Команды.Колонки.Добавить("Модификатор", Новый ОписаниеТипов("Строка"));
	Возврат Команды;
КонецФункции


#КонецОбласти

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

#Область СлужебныеПроцедурыИФункции

// Обработчик команды.
Процедура ЗаполнитьИНН(Форма, РезультатВыполнения)
	
	Генератор = Новый ГенераторСлучайныхЧисел;
	
	Форма.Объект.ИНН = Формат(Генератор.СлучайноеЧисло(1, 999999999), "ЧЦ=12; ЧДЦ=0; ЧВН=; ЧГ=");
	Форма.Модифицированность = Истина;
	
	СтандартныеПодсистемыКлиентСервер.ВывестиСообщение(
		РезультатВыполнения,
		НСтр("ru = 'Поле ""ИНН"" успешно заполнено'"),
		"Объект.ИНН");
	
КонецПроцедуры

// Обработчик команд ЗаполнитьПолноеНаименование, ДобавитьПрефиксКНаименованию, ЗаполнитьВсе и ОчиститьВсе.
Процедура ЗаполнитьПоСсылкам(ОбъектыНазначения, РезультатВыполнения, ЭтаКоманда,Форма)
	ЗаполнятьНаименование = (ЭтаКоманда.ИмяКоманды = "ЗаполнитьПолноеНаименование" ИЛИ ЭтаКоманда.ИмяКоманды = "ЗаполнитьВсе");
	ДобавлятьПрефикс = (ЭтаКоманда.ИмяКоманды = "ДобавитьПрефиксКНаименованию" ИЛИ ЭтаКоманда.ИмяКоманды = "ЗаполнитьВсе");
	ОчищатьВсе = (ЭтаКоманда.ИмяКоманды = "ОчиститьВсе");
	///Галимуллин Д.М.
	ЗаполнитьСторно = (ЭтаКоманда.ИмяКоманды="Сторно");
	
	МассивОшибок = Новый Массив;
	
	// Заполнение объектов
	Для Каждого ЭлементОбъектНазначения Из ОбъектыНазначения Цикл
		ОбъектНазначения = ЭлементОбъектНазначения.ПолучитьОбъект();
		
		Если ЗаполнятьНаименование Тогда
			Если НЕ ПустаяСтрока(ОбъектНазначения.НаименованиеПолное) Тогда
				МассивОшибок.Добавить(
					СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						НСтр("ru = 'Объект ""%1"" не обработан: реквизит ""НаименованиеПолное"" не пустой!'"),
						Строка(ОбъектНазначения)
					)
				);
			Иначе
				ОбъектНазначения.НаименованиеПолное = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Команда: %1
					|Время изменения: %2'"),
					ЭтаКоманда.Представление,
					Строка(ТекущаяДатаСеанса())
				);
			КонецЕсли;
		КонецЕсли;
		
		Если ДобавлятьПрефикс Тогда
			ОбъектНазначения.Наименование = "ПР " + ОбъектНазначения.Наименование;
		КонецЕсли;
		
		Если ОчищатьВсе Тогда
			ОбъектНазначения.Наименование = СтрЗаменить(ОбъектНазначения.Наименование, "ПР ", "");
			ОбъектНазначения.Наименование = СтрЗаменить(ОбъектНазначения.Наименование, "Прфкс_", "");
			ОбъектНазначения.НаименованиеПолное = "";
			ОбъектНазначения.ИНН = "";
		КонецЕсли;
		
		//////Галимуллин Д.М.
		Если ЗаполнитьСторно Тогда
			МассивСторнируемыхДокументов=Новый Массив;
			
			Для каждого стрДокумент из Форма.СторнирумыеДокументы Цикл
				МассивСторнируемыхДокументов.Добавить(стрДокумент.Значение);
			КонецЦикла;
			//СформироватьДвиженияСторноСервер(ОбъектНазначения,МассивСторнируемыхДокументов,ОбъектНазначения.ТаблицаРегистров.ВыгрузитьКолонку("Имя"));	
		КонецЕсли;
		////
		
		ОбъектНазначения.Записать();
	КонецЦикла;
	
	// Вывод результата
	Всего = ОбъектыНазначения.Количество();
	Ошибок = МассивОшибок.Количество();
	Заполнено = Всего - Ошибок;
	
	Если Всего = 0 Тогда
		ВызватьИсключение НСтр("ru = 'Не выбраны объекты для изменения'");
	ИначеЕсли Всего = 1 Тогда
		Если Ошибок > 0 Тогда
			СтандартныеПодсистемыКлиентСервер.ВывестиСообщение(
				РезультатВыполнения,
				МассивОшибок[0],
				"Объект.НаименованиеПолное");
		Иначе
			СсылкаЭлемента = ОбъектыНазначения[0];
			Если ЭтаКоманда.ИмяКоманды = "ЗаполнитьВсе" Тогда
				ЗаголовокОповещения = НСтр("ru = 'Наименование и префикс заполнены'");
			ИначеЕсли ЗаполнятьНаименование Тогда
				ЗаголовокОповещения = НСтр("ru = 'Полное наименование заполнено'");
			ИначеЕсли ДобавлятьПрефикс Тогда
				ЗаголовокОповещения = НСтр("ru = 'Добавлен префикс к краткому наименованию'");
			ИначеЕсли ЗаполнитьСторно Тогда
				ЗаголовокОповещения = НСтр("ru = 'Сторно выбранного документа выполнено'");
			Иначе
				ЗаголовокОповещения = НСтр("ru = 'Наименование и префикс очищены'");
			КонецЕсли;
			СтандартныеПодсистемыКлиентСервер.ВывестиОповещение(
				РезультатВыполнения,
				ЗаголовокОповещения,
				Строка(СсылкаЭлемента),
				,
				ПолучитьНавигационнуюСсылку(СсылкаЭлемента));
		КонецЕсли;
	Иначе
		Если Ошибок > 0 тогда
			Кратко = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Всего объектов: %1
					|Успешно заполнено: %2
					|Ошибок: %3'"),
				Формат(Всего,     "ЧН=0; ЧГ=0"),
				Формат(Заполнено, "ЧН=0; ЧГ=0"), 
				Формат(Ошибок,    "ЧН=0; ЧГ=0")
			);
			
			Подробно = "";
			Для Каждого ТекстОшибки Из МассивОшибок Цикл
				Подробно = Подробно + "---" + Символы.ПС + Символы.ПС + ТекстОшибки + Символы.ПС + Символы.ПС;
			КонецЦикла;
			
			СтандартныеПодсистемыКлиентСервер.ВывестиПредупреждение(
				РезультатВыполнения,
				Кратко,
				Подробно);
		Иначе
			ТекстОповещения = НСтр("ru = 'Обработано'")
				+ " "
				+ СтроковыеФункцииКлиентСервер.ЧислоЦифрамиПредметИсчисленияПрописью(
					Всего,
					НСтр("ru = 'объект,объекта,объектов'"));
			СтандартныеПодсистемыКлиентСервер.ВывестиОповещение(
				РезультатВыполнения,
				НСтр("ru = 'Команда успешно выполнена'"),
				ТекстОповещения);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

